import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Define the color palette (consistent with main.dart theme if possible, or specific)
const Color aiPrimaryColor = Color(0xFF5A67D8); // Primary blue from theme
const Color aiSecondaryColor = Color(0xFF38B2AC); // Teal accent
const Color aiBackgroundColor = Color(0xFFF7FAFC); // Light background
const Color aiBubbleColor = Colors.white; // AI bubble background
const Color userBubbleColor = aiPrimaryColor; // User bubble background
const Color aiTextColor = Color(0xFF1A202C); // Dark text
const Color subtleTextColor = Color(0xFF718096); // Grey text
const Color inputBackgroundColor = Colors.white;
const Color iconColor = Color(0xFF4A5568);

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: aiBackgroundColor,
      appBar: AppBar(
        backgroundColor: aiBackgroundColor, // Match scaffold background
        elevation: 0,
        title: Text(
          'MediAssist AI',
          style: TextStyle(
            color: aiTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 18, // Slightly smaller title
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: iconColor),
            onPressed: () {
              // TODO: Implement notification action
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildAiMessage(
                  context,
                  message: 'Hello! I\'m your medical assistant. How can I help you today?',
                  showAvatar: true,
                ),
                const SizedBox(height: 16),
                _buildSuggestionChips(context),
                const SizedBox(height: 20),
                _buildAiMessage(
                  context,
                  message: 'Here\'s what I found about vitamin D supplements:\n'
                      '• Recommended daily intake: 600-800 IU\n'
                      '• Best taken with fatty meals',
                  showAvatar: true,
                ),
                const SizedBox(height: 12),
                _buildUserMessage(context, message: 'Thank you! What about vitamin B12?'),
              ].animate(interval: 100.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
            ),
          ),
          _buildInputArea(context),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _buildChip(context, 'Check medicine interactions'),
        _buildChip(context, 'Suggest vitamins'),
        _buildChip(context, 'Find symptoms cause'),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildChip(BuildContext context, String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        // TODO: Handle chip press
      },
      backgroundColor: aiSecondaryColor.withOpacity(0.1),
      labelStyle: TextStyle(color: aiSecondaryColor, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    );
  }

  Widget _buildAiMessage(BuildContext context, {required String message, bool showAvatar = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showAvatar)
          const CircleAvatar(
            radius: 18,
            backgroundColor: aiPrimaryColor, // Placeholder color
            child: Icon(Icons.android_rounded, size: 20, color: Colors.white), // Placeholder icon
          )
        else
          const SizedBox(width: 36), // Maintain alignment
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showAvatar)
                Row(
                  children: [
                    Text(
                      'MediAssist AI',
                      style: TextStyle(fontWeight: FontWeight.bold, color: aiTextColor, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Online',
                      style: TextStyle(color: Colors.green.shade600, fontSize: 12),
                    ),
                  ],
                ),
              if (showAvatar) const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: aiBubbleColor,
                  borderRadius: BorderRadius.circular(16.0).copyWith(topLeft: Radius.zero),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  message,
                  style: TextStyle(color: aiTextColor, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40), // Ensure bubble doesn't touch edge
      ],
    );
  }

  Widget _buildUserMessage(BuildContext context, {required String message}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 40), // Ensure bubble doesn't touch edge
        Flexible( // Use Flexible to prevent overflow
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: userBubbleColor,
              borderRadius: BorderRadius.circular(16.0).copyWith(bottomRight: Radius.zero),
              boxShadow: [
                BoxShadow(
                  color: userBubbleColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, height: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea( // Ensure input isn't under system UI (like home bar)
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.mic_none_rounded, color: iconColor),
              onPressed: () {
                // TODO: Implement voice input
              },
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: InputBorder.none,
                  filled: false, // No background fill needed
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  hintStyle: TextStyle(color: subtleTextColor),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send_rounded, color: aiPrimaryColor),
              onPressed: () {
                // TODO: Implement send message
              },
            ).animate().scale(delay: 400.ms, duration: 300.ms, curve: Curves.elasticOut),
          ],
        ),
      ),
    );
  }
}