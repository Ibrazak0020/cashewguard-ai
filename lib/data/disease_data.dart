import 'package:flutter/material.dart';

class Disease {
  final String id;
  final String name;
  final String scientificName;
  final String type;
  final String severity;
  final Color severityColor;
  final Color color;
  final IconData icon;
  final String description;
  final String shortDescription;
  final String optimalTemp;
  final String humidity;
  final String spreadRate;
  final String target;
  final List<String> symptoms;
  final List<Map<String, String>> prevention;
  final String recommendedFungicide;
  final String fungicideDescription;
  final String biologicalControl;
  final String applicationWindow;
  final List<Map<String, String>> treatmentSteps;
  final String aiInsight;

  const Disease({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.type,
    required this.severity,
    required this.severityColor,
    required this.color,
    required this.icon,
    required this.description,
    required this.shortDescription,
    required this.optimalTemp,
    required this.humidity,
    required this.spreadRate,
    required this.target,
    required this.symptoms,
    required this.prevention,
    required this.recommendedFungicide,
    required this.fungicideDescription,
    required this.biologicalControl,
    required this.applicationWindow,
    required this.treatmentSteps,
    required this.aiInsight,
  });
}

class DiseaseData {
  static const List<Disease> diseases = [
    Disease(
      id: 'anthracnose',
      name: 'Anthracnose',
      scientificName: 'Colletotrichum gloeosporioides',
      type: 'Fungal',
      severity: 'High',
      severityColor: Color(0xFFBA1A1A),
      color: Color(0xFFBA1A1A),
      icon: Icons.coronavirus,
      description:
          'Anthracnose is a fungal disease caused by Colletotrichum spp. that affects cashew plants in tropical regions. It manifests as dark, irregular spots on leaves that grow and merge over time, leading to leaf deformation and premature drop.',
      shortDescription:
          'Dark irregular spots on leaves, shoots and fruits. Can cause up to 80% crop loss if untreated.',
      optimalTemp: '25-30°C',
      humidity: '>85%',
      spreadRate: 'RAPID',
      target: 'LEAVES/FRUIT',
      symptoms: [
        'Dark irregular brown or black spots on leaf surface',
        'Spots enlarge and merge causing leaf blight',
        'Infected leaves turn yellow and drop prematurely',
        'Dark sunken lesions on young shoots and fruits',
        'Severe defoliation in humid conditions',
      ],
      prevention: [
        {
          'title': 'Field Sanitation',
          'description':
              'Remove and burn all infected plant debris, including fallen leaves and nuts, to reduce inoculum levels.',
        },
        {
          'title': 'Canopy Management',
          'description':
              'Regular pruning to ensure adequate sunlight penetration and air circulation, reducing moisture buildup.',
        },
        {
          'title': 'Resistant Cultivars',
          'description':
              'Prioritize planting of certified disease-resistant cashew clones specific to your regional climate.',
        },
      ],
      recommendedFungicide: 'Copper Oxychloride (0.3%)',
      fungicideDescription:
          'Apply two sprays at 15-day intervals during the early stages of flowering and nut formation.',
      biologicalControl:
          'Application of Trichoderma viride spray can help suppress Colletotrichum growth naturally.',
      applicationWindow:
          'Spray before 9:00 AM or after 4:00 PM to ensure maximum adherence and minimize evaporation.',
      treatmentSteps: [
        {
          'title': 'Orchard Inspection',
          'description':
              'Walk through your cashew orchard and identify all trees showing signs of dark spots or lesions.',
          'duration': '1-2 hours',
        },
        {
          'title': 'Remove Infected Parts',
          'description':
              'Prune and remove all visibly infected branches, leaves and shoots. Bag and dispose outside the farm.',
          'duration': '2-3 hours',
        },
        {
          'title': 'Fungicide Application',
          'description':
              'Apply Copper Oxychloride 0.3% solution evenly to all tree surfaces, focusing on new growth areas.',
          'duration': '3-4 hours',
        },
        {
          'title': 'Orchard Sanitation',
          'description':
              'Clear all fallen leaves and debris from the ground. Apply lime to reduce fungal spore count.',
          'duration': '1-2 hours',
        },
        {
          'title': 'Follow-up Monitoring',
          'description':
              'Schedule weekly inspections. Reapply treatment after 14 days. Use CashewGuard AI to track progress.',
          'duration': 'Ongoing',
        },
      ],
      aiInsight:
          'Based on current weather telemetry and local sensor data, the risk of spread in your Northeast Quadrant is estimated at 84% over the next 48 hours. Immediate sanitation is advised.',
    ),
    Disease(
      id: 'gumosis',
      name: 'Gumosis',
      scientificName: 'Lasiodiplodia theobromae',
      type: 'Fungal',
      severity: 'High',
      severityColor: Color(0xFFE65100),
      color: Color(0xFFE65100),
      icon: Icons.water_drop,
      description:
          'Gumosis is a fungal disease that causes gum exudation from the bark and branches of cashew trees. It is caused by Lasiodiplodia theobromae and leads to bark cracking, dieback, and in severe cases, complete tree death.',
      shortDescription:
          'Gum exudation from bark and branches. Causes bark cracking and severe dieback if left untreated.',
      optimalTemp: '28-35°C',
      humidity: '>80%',
      spreadRate: 'MODERATE',
      target: 'BARK/STEM',
      symptoms: [
        'Gum or resin oozing from bark surface',
        'Dark brown discoloration under the bark',
        'Cracking and splitting of bark tissue',
        'Wilting and dieback of affected branches',
        'Darkening and rotting of wood beneath gum spots',
      ],
      prevention: [
        {
          'title': 'Wound Management',
          'description':
              'Avoid unnecessary wounds on tree bark. Seal all pruning cuts with wound sealant or copper paste.',
        },
        {
          'title': 'Proper Drainage',
          'description':
              'Ensure good soil drainage around tree bases to prevent waterlogging which encourages fungal growth.',
        },
        {
          'title': 'Healthy Nutrition',
          'description':
              'Maintain balanced fertilization to keep trees vigorous and resistant to infection.',
        },
      ],
      recommendedFungicide: 'Thiophanate-methyl (0.1%)',
      fungicideDescription:
          'Scrape off the infected bark and apply fungicide paste directly to the wound. Repeat every 21 days.',
      biologicalControl:
          'Trichoderma harzianum applied to soil around tree base helps reduce Lasiodiplodia infection.',
      applicationWindow:
          'Apply fungicide paste during dry weather. Avoid application before expected rain to ensure absorption.',
      treatmentSteps: [
        {
          'title': 'Identify Infected Trees',
          'description':
              'Look for gum exudation and dark discoloration on bark. Mark all affected trees for treatment.',
          'duration': '1 hour',
        },
        {
          'title': 'Scrape Infected Bark',
          'description':
              'Using a clean knife, scrape away all infected bark tissue until healthy wood is visible.',
          'duration': '2-3 hours',
        },
        {
          'title': 'Apply Fungicide Paste',
          'description':
              'Apply Thiophanate-methyl paste directly to all scraped wound surfaces. Cover completely.',
          'duration': '1-2 hours',
        },
        {
          'title': 'Dispose Infected Material',
          'description':
              'Collect and burn all scraped bark material away from the orchard to prevent reinfection.',
          'duration': '30 minutes',
        },
        {
          'title': 'Monitor and Repeat',
          'description':
              'Inspect treated trees weekly. Reapply fungicide paste if gum exudation resumes.',
          'duration': 'Ongoing',
        },
      ],
      aiInsight:
          'Gumosis thrives in warm humid conditions. With current soil moisture levels elevated, monitor your trees closely over the next 2 weeks and apply preventive fungicide treatment.',
    ),
    Disease(
      id: 'healthy',
      name: 'Healthy',
      scientificName: 'No pathogen detected',
      type: 'Healthy',
      severity: 'None',
      severityColor: Color(0xFF0D631B),
      color: Color(0xFF0D631B),
      icon: Icons.eco,
      description:
          'The scanned cashew leaf shows no signs of disease infection. The leaf appears healthy with normal coloration, texture, and structure. Continue regular monitoring to maintain the health of your cashew plantation.',
      shortDescription:
          'No disease detected. Leaf shows normal coloration and healthy tissue structure.',
      optimalTemp: '24-32°C',
      humidity: '60-80%',
      spreadRate: 'N/A',
      target: 'N/A',
      symptoms: [
        'Uniform green coloration across the leaf surface',
        'No visible spots, lesions or discoloration',
        'Normal leaf texture without powdery coating',
        'Healthy veins with no browning or darkening',
        'No signs of insect damage or fungal growth',
      ],
      prevention: [
        {
          'title': 'Regular Monitoring',
          'description':
              'Conduct weekly scans using CashewGuard AI to detect early signs of disease before they spread.',
        },
        {
          'title': 'Balanced Fertilization',
          'description':
              'Apply NPK fertilizer at recommended rates to maintain tree vigour and immune resistance.',
        },
        {
          'title': 'Preventive Spraying',
          'description':
              'Apply preventive copper fungicide at the start of the rainy season even when no disease is visible.',
        },
      ],
      recommendedFungicide: 'No treatment required',
      fungicideDescription:
          'The leaf is healthy. Continue preventive measures and regular monitoring to maintain this status.',
      biologicalControl:
          'Consider applying Trichoderma as a soil drench to boost natural disease resistance.',
      applicationWindow:
          'Schedule preventive spray at the beginning of each rainy season as a precautionary measure.',
      treatmentSteps: [
        {
          'title': 'Continue Monitoring',
          'description':
              'Scan leaves weekly using CashewGuard AI. Keep records of all scan results for comparison.',
          'duration': 'Weekly',
        },
        {
          'title': 'Apply Preventive Spray',
          'description':
              'Apply preventive copper fungicide at the start of the rainy season to protect against infection.',
          'duration': 'Seasonal',
        },
        {
          'title': 'Maintain Orchard Hygiene',
          'description':
              'Remove fallen leaves and debris regularly. Keep the orchard floor clean to reduce disease risk.',
          'duration': 'Weekly',
        },
        {
          'title': 'Fertilize Appropriately',
          'description':
              'Apply balanced NPK fertilizer at the recommended rate to maintain healthy tree vigour.',
          'duration': 'Monthly',
        },
        {
          'title': 'Prune for Air Circulation',
          'description':
              'Lightly prune dense canopy areas to ensure good air circulation and reduce humidity buildup.',
          'duration': 'Quarterly',
        },
      ],
      aiInsight:
          'Your cashew leaf scan is clean. Current farm conditions look favourable. Keep up your monitoring schedule and apply preventive spraying at the start of the next rainy season.',
    ),
    Disease(
      id: 'leaf_miner',
      name: 'Leaf Miner',
      scientificName: 'Acrocercops syngramma',
      type: 'Pest',
      severity: 'Moderate',
      severityColor: Color(0xFF795548),
      color: Color(0xFF795548),
      icon: Icons.bug_report,
      description:
          'Leaf Miner is caused by the larvae of Acrocercops syngramma moth that tunnel through cashew leaves, creating characteristic blotch mines. The larvae feed inside the leaf tissue causing brown blotches and severe leaf damage.',
      shortDescription:
          'Larvae tunnel inside leaves creating brown blotch mines. Can cause serious defoliation in young trees.',
      optimalTemp: '22-30°C',
      humidity: '60-75%',
      spreadRate: 'MODERATE',
      target: 'YOUNG LEAVES',
      symptoms: [
        'Brown blotch mines visible on leaf surface',
        'Translucent patches on the leaf where larvae have fed',
        'Curling and drying of affected leaf portions',
        'Tiny larvae visible when holding leaf to light',
        'Premature leaf drop in heavily infested trees',
      ],
      prevention: [
        {
          'title': 'Monitor Young Flushes',
          'description':
              'Inspect new leaf flushes regularly as leaf miners prefer young tender leaves for egg laying.',
        },
        {
          'title': 'Natural Enemies',
          'description':
              'Encourage natural predators like parasitic wasps that attack leaf miner larvae and pupae.',
        },
        {
          'title': 'Avoid Over-fertilizing',
          'description':
              'Excessive nitrogen promotes lush new growth which attracts more leaf miner activity.',
        },
      ],
      recommendedFungicide: 'Dimethoate (0.05%) or Quinalphos',
      fungicideDescription:
          'Apply systemic insecticide during new leaf flush period when larvae are most active. Two sprays at 10-day intervals.',
      biologicalControl:
          'Release of Sympiesis and Chrysocharis parasitoids has shown effective control of leaf miner populations.',
      applicationWindow:
          'Spray during early morning or evening to target active larvae. Focus on young leaf flushes.',
      treatmentSteps: [
        {
          'title': 'Inspect New Flushes',
          'description':
              'Check all new leaf growth for characteristic blotch mines. Record percentage of affected leaves.',
          'duration': '1 hour',
        },
        {
          'title': 'Remove Heavily Infested Leaves',
          'description':
              'Pick and destroy leaves with high infestation. This reduces the larval population immediately.',
          'duration': '1-2 hours',
        },
        {
          'title': 'Apply Systemic Insecticide',
          'description':
              'Spray Dimethoate 0.05% solution on all foliage, paying special attention to new leaf flushes.',
          'duration': '2-3 hours',
        },
        {
          'title': 'Repeat Application',
          'description':
              'Apply second insecticide spray after 10 days to target any newly hatched larvae.',
          'duration': '2-3 hours',
        },
        {
          'title': 'Post-treatment Monitoring',
          'description':
              'Monitor treated trees for 4 weeks. Use CashewGuard AI to scan leaves and verify recovery.',
          'duration': 'Ongoing',
        },
      ],
      aiInsight:
          'Leaf miner activity is typically highest during the dry season when new flushes emerge. Based on current seasonal patterns, apply preventive insecticide spray on all young leaf flushes this week.',
    ),
    Disease(
      id: 'red_rust',
      name: 'Red Rust',
      scientificName: 'Cephaleuros virescens',
      type: 'Algal',
      severity: 'Moderate',
      severityColor: Color(0xFFB71C1C),
      color: Color(0xFFB71C1C),
      icon: Icons.grain,
      description:
          'Red Rust is caused by the parasitic green alga Cephaleuros virescens that forms orange-red or rusty patches on cashew leaves. It is more common in trees with poor nutrition and in shaded, humid orchards.',
      shortDescription:
          'Orange-red algal patches on leaf surface. Reduces photosynthesis and weakens the tree over time.',
      optimalTemp: '20-28°C',
      humidity: '>75%',
      spreadRate: 'SLOW',
      target: 'LEAVES/BARK',
      symptoms: [
        'Orange or rust-red velvety patches on upper leaf surface',
        'Circular to irregular algal spots with raised texture',
        'Yellowing of leaf tissue surrounding the algal patches',
        'Bark of young branches may also show orange crusts',
        'Gradual reduction in photosynthetic capacity',
      ],
      prevention: [
        {
          'title': 'Improve Sunlight',
          'description':
              'Prune dense canopy areas to increase sunlight penetration as red rust thrives in shade.',
        },
        {
          'title': 'Boost Tree Nutrition',
          'description':
              'Apply potassium and phosphorus fertilizers to strengthen tree immunity against algal infection.',
        },
        {
          'title': 'Reduce Humidity',
          'description':
              'Improve air circulation through regular pruning and avoid overhead irrigation near leaves.',
        },
      ],
      recommendedFungicide: 'Copper Hydroxide (0.2%)',
      fungicideDescription:
          'Apply copper-based fungicide spray at the onset of the rainy season. Two applications at 3-week intervals.',
      biologicalControl:
          'No effective biological control currently available. Focus on cultural management and copper sprays.',
      applicationWindow:
          'Apply spray in dry weather. Ensure thorough coverage of upper and lower leaf surfaces.',
      treatmentSteps: [
        {
          'title': 'Identify Affected Trees',
          'description':
              'Walk the orchard and tag all trees showing orange-red patches on leaves or bark.',
          'duration': '1 hour',
        },
        {
          'title': 'Prune for Light',
          'description':
              'Remove dense branches to improve sunlight penetration and reduce humidity inside the canopy.',
          'duration': '2-3 hours',
        },
        {
          'title': 'Apply Copper Spray',
          'description':
              'Spray Copper Hydroxide 0.2% solution on all affected leaves and branches. Ensure full coverage.',
          'duration': '2-3 hours',
        },
        {
          'title': 'Fertilize Trees',
          'description':
              'Apply potassium and phosphorus fertilizer to improve tree vigour and resistance to algal infection.',
          'duration': '1 hour',
        },
        {
          'title': 'Monitor Progress',
          'description':
              'Inspect treated trees after 3 weeks. Reapply copper spray if algal patches persist.',
          'duration': 'Ongoing',
        },
      ],
      aiInsight:
          'Red rust spreads slowly but weakens trees significantly over time. The current shade and humidity levels in your orchard are favourable for algal growth. Prune and spray copper fungicide this week.',
    ),
  ];

  // Get disease by id
  static Disease getById(String id) {
    return diseases.firstWhere(
      (d) => d.id == id,
      orElse: () => diseases[0],
    );
  }

  // Get color for severity label
  static Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'healthy':
        return const Color(0xFF0D631B);
      case 'mild':
        return const Color(0xFF388E3C);
      case 'moderate':
        return const Color(0xFFE65100);
      case 'severe':
        return const Color(0xFFBA1A1A);
      default:
        return const Color(0xFF0D631B);
    }
  }
}
