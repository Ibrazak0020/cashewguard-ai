from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
import cv2
from PIL import Image
import base64
import io
import os

app = Flask(__name__)
CORS(app)

# ============================================
# MODEL CONFIGURATION
# ============================================

MODEL_PATH     = os.path.join(os.path.dirname(__file__), 'cashew_model_final.tflite')
VALIDATOR_PATH = os.path.join(os.path.dirname(__file__), 'leaf_validator.tflite')

CLASS_NAMES = ['anthracnose', 'gumosis', 'healthy', 'leaf_miner', 'red_rust']

DISPLAY_NAMES = {
    'anthracnose': 'Anthracnose',
    'gumosis':     'Gumosis',
    'healthy':     'Healthy',
    'leaf_miner':  'Leaf Miner',
    'red_rust':    'Red Rust',
}

# ✅ FIX: threshold now matches how it was actually calibrated during
# validator training (optimal_threshold=0.3 on the 'not_cashew_leaf'
# sigmoid output). The old (1.0 - threshold) formula compared against
# 0.55-0.7 instead of the real calibrated 0.3, making the validator far
# more lenient than intended.
VALIDATOR_THRESHOLD = 0.3

# ============================================
# FAST PRE-FILTER: rejects screenshots/charts/documents/UI images
# BEFORE the ML validator even runs. No retraining needed.
#
# Why this is needed: the leaf validator was trained only on real
# photographs (cashew leaves + other-plant leaves), so it has never
# seen a screenshot, chart, or document and its behavior on one is
# essentially undefined. Real camera photos have high pixel-color
# diversity (natural noise/gradients); screenshots and charts use
# large areas of flat, identical color and often large white margins.
# This catches that specific failure mode cheaply and immediately.
# ============================================
def looks_photographic(img_rgb_full_res, min_diversity=0.12, max_white_ratio=0.35):
    small = cv2.resize(img_rgb_full_res, (100, 100))
    total_pixels = 100 * 100

    pixels = small.reshape(-1, 3)
    unique_colors = len(np.unique(pixels, axis=0))
    color_diversity_ratio = unique_colors / total_pixels

    near_white = np.all(small > 245, axis=-1)
    white_ratio = float(np.sum(near_white)) / total_pixels

    is_photographic = (color_diversity_ratio > min_diversity) and (white_ratio < max_white_ratio)
    return is_photographic, color_diversity_ratio, white_ratio

# ============================================
# LOAD DISEASE MODEL
# ============================================
interpreter = None

def load_model():
    global interpreter
    try:
        print(f'🔍 Model path: {MODEL_PATH}')
        print(f'🔍 Model exists: {os.path.exists(MODEL_PATH)}')
        interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
        interpreter.allocate_tensors()
        print('✅ Disease model loaded successfully')
        input_details = interpreter.get_input_details()
        print(f'✅ Input shape: {input_details[0]["shape"]}')
        return True
    except Exception as e:
        print(f'❌ Error loading disease model: {e}')
        return False

# ============================================
# ✅ LOAD LEAF VALIDATOR MODEL
# ============================================
validator_interpreter = None

def load_validator():
    global validator_interpreter
    try:
        print(f'🔍 Validator path: {VALIDATOR_PATH}')
        print(f'🔍 Validator exists: {os.path.exists(VALIDATOR_PATH)}')
        validator_interpreter = tf.lite.Interpreter(model_path=VALIDATOR_PATH)
        validator_interpreter.allocate_tensors()
        print('✅ Leaf validator model loaded successfully')
        return True
    except Exception as e:
        print(f'❌ Error loading validator model: {e}')
        return False

# ============================================
# IMAGE PREPROCESSING
# ✅ UPDATED: now returns BOTH the 224x224 array for the classifier/
# validator AND the original full-resolution RGB array for severity
# estimation (color segmentation needs real pixel detail -- the 224x224
# classifier input is too small for an accurate area measurement).
# ============================================
def preprocess_image(image_data):
    try:
        if ',' in image_data:
            image_data = image_data.split(',')[1]

        image_bytes = base64.b64decode(image_data)
        original_image = Image.open(io.BytesIO(image_bytes)).convert('RGB')
        full_res_array = np.array(original_image)

        resized_image = original_image.resize((224, 224))
        img_array = np.array(resized_image, dtype=np.float32) / 255.0
        img_array = np.expand_dims(img_array, axis=0)

        return img_array, full_res_array

    except Exception as e:
        print(f'❌ Error preprocessing image: {e}')
        return None, None

# ============================================
# ✅ RUN LEAF VALIDATOR — binary classifier
# Returns confidence score (0.0 to 1.0)
# cashew_leaf = close to 0.0
# not_cashew  = close to 1.0
# ============================================
def run_validator(img_array):
    try:
        if validator_interpreter is None:
            print('⚠️ Validator not loaded — skipping')
            return None

        input_details  = validator_interpreter.get_input_details()
        output_details = validator_interpreter.get_output_details()

        validator_interpreter.set_tensor(input_details[0]['index'], img_array)
        validator_interpreter.invoke()

        output = validator_interpreter.get_tensor(output_details[0]['index'])
        return float(output[0][0])  # single sigmoid value

    except Exception as e:
        print(f'❌ Validator error: {e}')
        return None

# ============================================
# RUN DISEASE PREDICTION
# ============================================
def run_prediction(img_array):
    try:
        input_details  = interpreter.get_input_details()
        output_details = interpreter.get_output_details()

        interpreter.set_tensor(input_details[0]['index'], img_array)
        interpreter.invoke()

        output = interpreter.get_tensor(output_details[0]['index'])
        return output[0]

    except Exception as e:
        print(f'❌ Error running prediction: {e}')
        return None

# ============================================
# ✅ SEVERITY ESTIMATION — color segmentation
# Replaces the old confidence-based get_infected_area/get_severity.
# infected_area = diseased_px / leaf_px * 100 -- a real measured
# pixel-area ratio, NOT classifier confidence.
# ============================================
def segment_leaf(img_rgb):
    hsv = cv2.cvtColor(img_rgb, cv2.COLOR_RGB2HSV)
    s_channel = hsv[:, :, 1]
    _, leaf_mask = cv2.threshold(s_channel, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    leaf_mask = leaf_mask.astype(bool)
    kernel = np.ones((5, 5), np.uint8)
    m = (leaf_mask * 255).astype(np.uint8)
    m = cv2.morphologyEx(m, cv2.MORPH_CLOSE, kernel)
    m = cv2.morphologyEx(m, cv2.MORPH_OPEN, kernel)
    return m.astype(bool)

def segment_diseased_tissue(img_rgb, leaf_mask):
    hsv = cv2.cvtColor(img_rgb, cv2.COLOR_RGB2HSV)
    h_channel = hsv[:, :, 0]
    s_channel = hsv[:, :, 1]
    healthy_green = (h_channel >= 30) & (h_channel <= 95) & (s_channel > 40)
    return leaf_mask & (~healthy_green)

def get_infected_area(img_rgb, disease_key, min_leaf_pixels=500):
    """Measures infected leaf area % via color segmentation on the
    ORIGINAL full-resolution image (not the 224x224 classifier input)."""
    if disease_key == 'healthy':
        return 0.0

    leaf_mask = segment_leaf(img_rgb)
    leaf_pixel_count = int(leaf_mask.sum())
    if leaf_pixel_count < min_leaf_pixels:
        return None  # segmentation failed (bad background, tiny leaf in frame)

    diseased_mask = segment_diseased_tissue(img_rgb, leaf_mask)
    diseased_pixel_count = int(diseased_mask.sum())

    infected = round((diseased_pixel_count / leaf_pixel_count) * 100, 1)
    return min(infected, 100.0)

def get_severity(disease_key, infected_area):
    """
    Healthy  : only when predicted class is healthy
    Mild     : 0%  to 25% infected area
    Moderate : 26% to 50% infected area
    Severe   : above 50% infected area
    """
    if disease_key == 'healthy':
        return 'Healthy'
    if infected_area is None:
        return 'Unknown'
    if infected_area <= 25:
        return 'Mild'
    elif infected_area <= 50:
        return 'Moderate'
    else:
        return 'Severe'

# ============================================
# ROUTES
# ============================================

@app.route('/', methods=['GET'])
def home():
    return jsonify({
        'status':           'CashewGuard AI API is running ✅',
        'disease_model':    'VGG16 (Tuned) — 96.15% val accuracy',
        'validator_model':  'MobileNetV2 Binary Classifier',
        'severity_method':  'Color segmentation (HSV)',
        'classes':          CLASS_NAMES,
        'version':          '4.0.0'
    })

@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        'status':             'healthy',
        'model_loaded':       interpreter is not None,
        'validator_loaded':   validator_interpreter is not None,
    })

# ============================================
# VALIDATE ENDPOINT
# ============================================
@app.route('/validate', methods=['POST'])
def validate():
    """
    Validates if image is a cashew leaf using leaf_validator.tflite.
    Returns: { 'is_leaf': bool, 'confidence': float, 'message': str }
    """
    try:
        data = request.get_json()

        if not data or 'image' not in data:
            return jsonify({'error': 'No image provided'}), 400

        img_array, full_res_array = preprocess_image(data['image'])
        if img_array is None:
            return jsonify({'error': 'Failed to process image'}), 400

        # Fast pre-filter: catches screenshots/charts/documents before
        # the ML validator runs at all.
        is_photo, diversity, white_ratio = looks_photographic(full_res_array)
        print(f'📷 Photographic check: diversity={diversity:.3f} white_ratio={white_ratio:.3f} is_photo={is_photo}')
        if not is_photo:
            return jsonify({
                'is_leaf':    False,
                'confidence': 0.0,
                'reason':     'not_a_photo',
                'message':    'This does not look like a photo of a leaf. '
                              'Please upload a clear camera photo of a cashew leaf.',
            })

        confidence = run_validator(img_array)

        if confidence is None:
            print('⚠️ Validator unavailable — using color analysis fallback')
            is_leaf, reason = _color_analysis(full_res_array)
            message = 'This does not appear to be a cashew leaf. Please upload a clear photo of a cashew leaf.' \
                      if not is_leaf else 'Image looks good. Proceeding to analysis.'
            return jsonify({
                'is_leaf':    is_leaf,
                'confidence': 0.0,
                'reason':     reason,
                'message':    message,
            })

        # cashew_leaf=0 → sigmoid close to 0.0, not_cashew_leaf=1 → sigmoid close to 1.0
        # ✅ FIX: direct comparison against the trained optimal_threshold (0.3)
        is_cashew = confidence < VALIDATOR_THRESHOLD

        print(f'🌿 Validator confidence: {confidence*100:.1f}% | '
              f'threshold: {VALIDATOR_THRESHOLD} | isCashew: {is_cashew}')

        if not is_cashew:
            return jsonify({
                'is_leaf':    False,
                'confidence': round(confidence, 4),
                'reason':     'not_cashew_leaf',
                'message':    'This does not appear to be a cashew leaf. '
                              'Please upload a clear photo of a cashew leaf.',
            })

        return jsonify({
            'is_leaf':    True,
            'confidence': round(confidence, 4),
            'reason':     'valid',
            'message':    'Image validated as cashew leaf. Proceeding to analysis.',
        })

    except Exception as e:
        print(f'❌ Validation error: {e}')
        return jsonify({'error': str(e)}), 500


def _color_analysis(img_rgb_full_res):
    """Fallback color analysis if validator model is unavailable."""
    small = cv2.resize(img_rgb_full_res, (64, 64))
    r = small[:, :, 0].astype(float)
    g = small[:, :, 1].astype(float)
    b = small[:, :, 2].astype(float)
    mean_r, mean_g, mean_b = np.mean(r), np.mean(g), np.mean(b)
    green_dominant  = (mean_g > mean_r) and (mean_g > mean_b)
    green_pixels    = np.sum((g > r * 0.85) & (g > b * 0.85) & (g > 60))
    total_pixels    = small.shape[0] * small.shape[1]
    green_ratio     = green_pixels / total_pixels
    mean_brightness = (mean_r + mean_g + mean_b) / 3

    if mean_brightness < 30:
        return False, 'too_dark'
    if mean_brightness > 230:
        return False, 'too_bright'
    if not green_dominant and green_ratio < 0.15:
        return False, 'not_green'
    return True, 'valid'


# ============================================
# PREDICT ENDPOINT
# ============================================
@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()

        if not data or 'image' not in data:
            return jsonify({'error': 'No image provided'}), 400

        # Step 1: Preprocess (now returns classifier input + full-res image)
        img_array, full_res_array = preprocess_image(data['image'])
        if img_array is None:
            return jsonify({'error': 'Failed to process image'}), 400

        # Step 1b: Fast pre-filter -- catches screenshots/charts/documents
        # before the disease classifier or ML validator even run.
        is_photo, diversity, white_ratio = looks_photographic(full_res_array)
        print(f'📷 Photographic check: diversity={diversity:.3f} white_ratio={white_ratio:.3f} is_photo={is_photo}')
        if not is_photo:
            return jsonify({
                'success':         False,
                'disease':         'Unrecognized',
                'disease_key':     'unrecognized',
                'confidence':      0.0,
                'severity':        'Unknown',
                'infected_area':   0.0,
                'all_predictions': {},
                'reason':          'not_a_photo',
                'message':         'This does not look like a photo of a leaf. '
                                    'Please upload a clear camera photo of a cashew leaf.',
            })

        # Step 2: Run disease prediction
        predictions = run_prediction(img_array)
        if predictions is None:
            return jsonify({'error': 'Prediction failed'}), 500

        # Step 3: Validate with binary classifier
        val_confidence = run_validator(img_array)

        if val_confidence is not None:
            is_leaf = val_confidence < VALIDATOR_THRESHOLD
            print(f'🌿 Predict-level validator: {val_confidence*100:.1f}% | isCashew: {is_leaf}')
        else:
            is_leaf, _ = _color_analysis(full_res_array)

        if not is_leaf:
            return jsonify({
                'success':         False,
                'disease':         'Unrecognized',
                'disease_key':     'unrecognized',
                'confidence':      0.0,
                'severity':        'Unknown',
                'infected_area':   0.0,
                'all_predictions': {},
                'reason':          'not_cashew_leaf',
                'message':         'The uploaded image does not appear to be a cashew leaf.',
            })

        # Step 4: Process valid prediction
        predicted_index = int(np.argmax(predictions))
        confidence      = float(predictions[predicted_index])
        disease_key     = CLASS_NAMES[predicted_index]
        disease_name    = DISPLAY_NAMES[disease_key]

        # Step 5: Severity via color segmentation on the FULL-RES image
        # (NOT derived from classifier confidence)
        infected_area = get_infected_area(full_res_array, disease_key)
        severity      = get_severity(disease_key, infected_area)
        if infected_area is None:
            infected_area = 0.0  # segmentation failed; report conservatively

        all_predictions = {
            DISPLAY_NAMES[CLASS_NAMES[i]]: round(float(predictions[i]) * 100, 2)
            for i in range(len(CLASS_NAMES))
        }

        print(f'✅ Result: {disease_name} | Confidence: {confidence*100:.1f}% | '
              f'Infected Area: {infected_area}% | Severity: {severity}')

        return jsonify({
            'success':         True,
            'disease':         disease_name,
            'disease_key':     disease_key,
            'confidence':      round(confidence, 4),
            'severity':        severity,
            'infected_area':   infected_area,
            'all_predictions': all_predictions,
        })

    except Exception as e:
        print(f'❌ Error in predict: {e}')
        return jsonify({'error': str(e)}), 500

# ============================================
# START SERVER
# ============================================
if __name__ == '__main__':
    print('🌱 Starting CashewGuard AI API v4.0...')
    load_model()
    load_validator()
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)), debug=False)
else:
    load_model()
    load_validator()