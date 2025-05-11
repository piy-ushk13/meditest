import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../theme.dart';
import 'ai_chat_sphere.dart';

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
    try {
      await _speechToText.initialize(
        onError: (error) {
          // Handle initialization errors
          if (mounted) {
            setState(() {
              _lastWords = "Speech recognition error: $error";
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          // Update UI if needed
        });
      }
    } catch (e) {
      // Handle any exceptions during initialization
      if (mounted) {
        setState(() {
          _lastWords = "Could not initialize speech recognition";
        });
      }
    }
  }

  void _startListening() async {
    try {
      _lastWords = '';

      // Check if speech recognition is available
      if (!_speechToText.isAvailable) {
        bool available = await _speechToText.initialize(
          onError: (error) {
            if (mounted) {
              setState(() {
                _isListening = false;
              });
            }
          },
        );

        if (!available) {
          if (mounted) {
            setState(() {
              _lastWords = "Speech recognition not available";
              _isListening = false;
            });
          }
          return;
        }
      }

      if (mounted) {
        setState(() {
          _isListening = true;
        });
      }

      await _speechToText.listen(
        onResult: (result) {
          if (mounted) {
            setState(() {
              _lastWords = result.recognizedWords;
            });
          }
        },
        listenOptions: SpeechListenOptions(
          cancelOnError: true,
          listenMode: ListenMode.confirmation,
          partialResults: true,
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isListening = false;
          _lastWords = "Error starting speech recognition";
        });
      }
    }
  }

  void _stopListening() async {
    try {
      await _speechToText.stop();

      if (mounted) {
        setState(() {
          _isListening = false;
          if (_lastWords.isNotEmpty) {
            _isProcessing = true;
          }
        });
      }

      // Limit text length to prevent crashes
      String processedText = _lastWords;
      if (processedText.length > 500) {
        processedText = "${processedText.substring(0, 497)}...";
      }

      if (processedText.isNotEmpty && mounted) {
        widget.onVoiceResult(processedText);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isListening = false;
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.9),
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
                  child: AiChatSphere(
                    isUserSpeaking: _isListening,
                    audioLevel: _getAudioLevel(),
                    isAiSpeaking: widget.isAiSpeaking,
                    size: 120.0,
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
                if (_lastWords.isNotEmpty &&
                    !widget.isAiSpeaking &&
                    !_isProcessing)
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
                          color: (_isListening
                                  ? Colors.red
                                  : AppTheme.primaryColor)
                              .withValues(alpha: 0.3),
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

  // Audio level simulation for the sphere
  double _getAudioLevel() {
    if (!_isListening) return 0.0;

    // Simulate audio level based on whether we're listening
    // In a real implementation, this would come from the speech recognition API
    return _isListening
        ? 0.5 + (DateTime.now().millisecondsSinceEpoch % 1000) / 2000
        : 0.0;
  }

  String _getStatusText() {
    if (widget.isAiSpeaking) return 'AI is speaking...';
    if (_isProcessing) return 'Processing...';
    if (_isListening) return 'Listening...';
    if (_lastWords.isEmpty) return 'Tap and hold to speak';
    return 'Processing your request...';
  }
}
