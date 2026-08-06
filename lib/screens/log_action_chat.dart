import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/ai_service.dart';

class _DisplayMessage {
  final String role; // 'user' or 'assistant'
  final String content;
  final bool isError;

  const _DisplayMessage({
    required this.role,
    required this.content,
    this.isError = false,
  });
}

class LogActionChat extends StatefulWidget {
  const LogActionChat({super.key});

  @override
  State<LogActionChat> createState() => _LogActionChatState();
}

class _LogActionChatState extends State<LogActionChat> {
  final _aiService = AiService();
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  String _disease = 'Unknown';
  String _severity = 'Unknown';
  double? _confidence;
  double? _infectedArea;
  bool _argsLoaded = false;

  final List<_DisplayMessage> _messages = [];
  bool _isSending = false;

  static const _green = Color(0xFF0D631B);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsLoaded) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _disease = args['disease']?.toString() ?? 'Unknown';
      _severity = args['severity']?.toString() ?? 'Unknown';
      _confidence = (args['confidence'] as num?)?.toDouble();
      _infectedArea = (args['infectedArea'] as num?)?.toDouble();
    }
    _argsLoaded = true;
    _startConversation();
  }

  bool get _hasScanNumbers => _confidence != null && _infectedArea != null;

  // ✅ AI: opens the conversation. If we have real scan numbers (opened
  // right after a diagnosis), auto-request an explanation of the actual
  // result so the farmer sees it immediately without typing anything. If
  // not (opened from the disease library), just show a friendly greeting.
  Future<void> _startConversation() async {
    if (!_hasScanNumbers) {
      _messages.add(
        _DisplayMessage(
          role: 'assistant',
          content:
              "Hi! I'm here to help with your $_disease question. What would you like to know — treatment steps, prevention, or something else?",
        ),
      );
      return;
    }

    _isSending = true;
    try {
      final reply = await _aiService.getChatReply(
        disease: _disease,
        severity: _severity,
        confidence: _confidence,
        infectedArea: _infectedArea,
        message:
            'Please explain my scan result in simple terms and tell me what I should do next.',
      );
      if (!mounted) return;
      setState(() {
        _messages.add(_DisplayMessage(role: 'assistant', content: reply));
        _isSending = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _DisplayMessage(
            role: 'assistant',
            content:
                "Hi! I'm here to help explain your $_disease result — feel free to ask me anything about it.",
          ),
        );
        _isSending = false;
      });
    }
    _scrollToBottom();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<AiChatMessage> get _historyForApi {
    // Skip error bubbles — only real turns go to the API.
    return _messages
        .where((m) => !m.isError)
        .map((m) => AiChatMessage(role: m.role, content: m.content))
        .toList();
  }

  Future<void> _send() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isSending) return;

    final history = _historyForApi;

    setState(() {
      _messages.add(_DisplayMessage(role: 'user', content: text));
      _isSending = true;
    });
    _inputController.clear();
    _scrollToBottom();

    try {
      final reply = await _aiService.getChatReply(
        disease: _disease,
        severity: _severity,
        message: text,
        history: history,
        confidence: _confidence,
        infectedArea: _infectedArea,
      );
      if (!mounted) return;
      setState(() {
        _messages.add(_DisplayMessage(role: 'assistant', content: reply));
        _isSending = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _DisplayMessage(
            role: 'assistant',
            content:
                "Sorry, I couldn't get a response just now. Please check your connection and try again.",
            isError: true,
          ),
        );
        _isSending = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // ✅ AI: guaranteed display-time fix — forces numbered list items onto
  // their own line no matter what the AI service already did to the text.
  String _displayFormat(String text) {
    return text
        .replaceAllMapped(
          RegExp(r'\s*(\d+\))\s*'),
          (m) => '\n\n${m.group(1)} ',
        )
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    itemCount: _messages.length + (_isSending ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= _messages.length) {
                        return _buildTypingBubble();
                      }
                      return _buildBubble(_messages[index]);
                    },
                  ),
                ),
                _buildInputBar(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _green.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: _green, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ask CashewGuard AI',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _green,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _green.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$_disease · $_severity',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(_DisplayMessage message) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser
              ? _green
              : (message.isError
                  ? const Color(0xFFBA1A1A).withValues(alpha: 0.06)
                  : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          boxShadow: isUser
              ? []
              : [
                  BoxShadow(
                    color: _green.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Text(
          isUser ? message.content : _displayFormat(message.content),
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
            color: isUser
                ? Colors.white
                : (message.isError
                    ? const Color(0xFFBA1A1A)
                    : Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: _green.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              _green.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: _green.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _inputController,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Ask about your crop...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _isSending ? null : _send,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _isSending ? _green.withValues(alpha: 0.4) : _green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _green.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_upward,
                    color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E7D32).withValues(alpha: 0.07)
      ..style = PaintingStyle.fill;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
