import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../theme.dart';

class VoiceInteractionWidget extends StatefulWidget {
  final Function(String) onVoiceResult;
  final Function() onClose;
  final bool isAiSpeaking;

  const VoiceInteractionWidget({
    super.key,
    required this.onVoiceResult,
    required this.onClose,
    required this.isAiSpeaking,
  });

  @override
  State<VoiceInteractionWidget> createState() => _VoiceInteractionWidgetState();
}

class _VoiceInteractionWidgetState extends State<VoiceInteractionWidget> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    _lastWords = '';
    if (await _speechToText.initialize()) {
      setState(() {
        _isListening = true;
      });
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
          });
        },
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
      if (_lastWords.isNotEmpty) {
        _isProcessing = true;
      }
    });
    if (_lastWords.isNotEmpty) {
      widget.onVoiceResult(_lastWords);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarGlow(
                  glowColor: _getGlowColor(),
                  animate: _isListening || widget.isAiSpeaking,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: _getAvatarColor(),
                    child: Icon(
                      _getIcon(),
                      size: 36,
                      color: _getIconColor(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _getStatusText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_lastWords.isNotEmpty && !widget.isAiSpeaking && !_isProcessing)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _lastWords,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: widget.onClose,
            ),
          ),
          if (!widget.isAiSpeaking && !_isProcessing)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTapDown: (_) => _startListening(),
                  onTapUp: (_) => _stopListening(),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isListening ? Colors.red : AppTheme.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? Colors.red : AppTheme.primaryColor).withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getGlowColor() {
    if (widget.isAiSpeaking) return Colors.blue;
    if (_isListening) return Colors.red;
    return AppTheme.primaryColor;
  }

  Color _getAvatarColor() {
    if (widget.isAiSpeaking) return Colors.blue.withOpacity(0.2);
    if (_isListening) return Colors.red.withOpacity(0.2);
    return AppTheme.primaryColor.withOpacity(0.2);
  }

  Color _getIconColor() {
    if (widget.isAiSpeaking) return Colors.blue;
    if (_isListening) return Colors.red;
    return AppTheme.primaryColor;
  }

  IconData _getIcon() {
    if (widget.isAiSpeaking) return Icons.record_voice_over;
    if (_isProcessing) return Icons.psychology;
    if (_isListening) return Icons.mic;
    return Icons.mic_none;
  }

  String _getStatusText() {
    if (widget.isAiSpeaking) return 'AI is speaking...';
    if (_isProcessing) return 'Processing...';
    if (_isListening) return 'Listening...';
    if (_lastWords.isEmpty) return 'Tap and hold to speak';
    return 'Processing your request...';
  }
}