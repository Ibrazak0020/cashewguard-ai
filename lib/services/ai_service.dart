import 'package:supabase_flutter/supabase_flutter.dart';

/// A single message in an AI chat conversation, matching the shape the
/// `cashew-ai` Supabase Edge Function expects for its `history` field.
class AiChatMessage {
  final String role; // 'user' or 'assistant'
  final String content;

  const AiChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {'role': role, 'content': content};
}

/// Thrown when a call to the AI service fails — network issue, function
/// error, or a malformed response.
class AiServiceException implements Exception {
  final String message;
  AiServiceException(this.message);

  @override
  String toString() => message;
}

/// Wraps calls to the `cashew-ai` Supabase Edge Function, which proxies
/// requests to Groq for two purposes:
///   - a short AI-generated insight about a disease or diagnosis
///   - a conversational reply to a farmer's question, with disease context
class AiService {
  final _client = Supabase.instance.client;
  static const _functionName = 'cashew-ai';

  /// Requests a short, practical insight about a disease.
  ///
  /// Pass [confidence] and [infectedArea] when you have real scan numbers
  /// (e.g. right after a diagnosis) — the AI will tailor its response to
  /// those exact figures. Omit them when just browsing the disease library;
  /// the AI will fall back to general, still-practical guidance.
  Future<String> getInsight({
    required String disease,
    required String severity,
    double? confidence,
    double? infectedArea,
  }) async {
    try {
      final response = await _client.functions.invoke(
        _functionName,
        body: {
          'mode': 'insight',
          'disease': disease,
          'severity': severity,
          if (confidence != null) 'confidence': confidence,
          if (infectedArea != null) 'infectedArea': infectedArea,
        },
      );

      final data = response.data;
      if (data is Map && data['insight'] is String) {
        return data['insight'] as String;
      }
      if (data is Map && data['error'] != null) {
        throw AiServiceException(data['error'].toString());
      }
      throw AiServiceException('Unexpected response from AI service.');
    } on AiServiceException {
      rethrow;
    } catch (e) {
      throw AiServiceException('Could not reach AI service: $e');
    }
  }

  /// Sends a farmer's [message] (with optional prior [history] for
  /// multi-turn context) and returns the AI's reply, using [disease] and
  /// [severity] to ground its advice. Pass [confidence] and [infectedArea]
  /// when you have real scan numbers so the AI can reference them directly.
  Future<String> getChatReply({
    required String disease,
    required String severity,
    required String message,
    List<AiChatMessage> history = const [],
    double? confidence,
    double? infectedArea,
  }) async {
    try {
      final response = await _client.functions.invoke(
        _functionName,
        body: {
          'mode': 'chat',
          'disease': disease,
          'severity': severity,
          'message': message,
          'history': history.map((m) => m.toJson()).toList(),
          if (confidence != null) 'confidence': confidence,
          if (infectedArea != null) 'infectedArea': infectedArea,
        },
      );

      final data = response.data;
      if (data is Map && data['reply'] is String) {
        return _formatReply(data['reply'] as String);
      }
      if (data is Map && data['error'] != null) {
        throw AiServiceException(data['error'].toString());
      }
      throw AiServiceException('Unexpected response from AI service.');
    } on AiServiceException {
      rethrow;
    } catch (e) {
      throw AiServiceException('Could not reach AI service: $e');
    }
  }

  /// Sends a message to the general-purpose AI assistant — unlike
  /// [getChatReply], this is NOT scoped to farming/app topics. It can
  /// answer anything, the same as a general chatbot.
  Future<String> getAssistantReply({
    required String message,
    List<AiChatMessage> history = const [],
  }) async {
    try {
      final response = await _client.functions.invoke(
        _functionName,
        body: {
          'mode': 'assistant',
          'message': message,
          'history': history.map((m) => m.toJson()).toList(),
        },
      );

      final data = response.data;
      if (data is Map && data['reply'] is String) {
        return _formatReply(data['reply'] as String);
      }
      if (data is Map && data['error'] != null) {
        throw AiServiceException(data['error'].toString());
      }
      throw AiServiceException('Unexpected response from AI service.');
    } on AiServiceException {
      rethrow;
    } catch (e) {
      throw AiServiceException('Could not reach AI service: $e');
    }
  }

  /// Forces numbered list items ("1)", "2)", etc.) onto their own line,
  /// regardless of whether the AI actually included line breaks. This
  /// guarantees readable formatting even when the model runs a numbered
  /// list together as one paragraph.
  String _formatReply(String text) {
    return text
        .replaceAllMapped(
          RegExp(r'\s+(\d+\))'),
          (match) => '\n\n${match.group(1)}',
        )
        .trim();
  }
}
