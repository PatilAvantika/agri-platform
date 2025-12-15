import 'package:flutter/material.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

/// ChatbotScreen
/// -------------
/// Purpose:
/// - Farmer advisory via chat
/// - Ask farming questions in simple language
///
/// UX Principles:
/// - Familiar chat layout (WhatsApp-like)
/// - Large text & spacing
/// - Big input & send buttons
/// - Voice-ready UI
///
/// NOTE:
/// - UI only
/// - No backend / AI logic
/// - Placeholder messages

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 AppBar for trust & clarity
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Ask Agri Bot',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Column(
        children: [
          // 💬 Chat Messages Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ChatBubble(
                  message:
                      'Hello! I am Agri Bot 🌱\nAsk me any farming question.',
                  isUser: false,
                ),
                SizedBox(height: 12),
                ChatBubble(
                  message: 'What is the best time to sow wheat?',
                  isUser: true,
                ),
                SizedBox(height: 12),
                ChatBubble(
                  message:
                      'Wheat is usually sown between October and November for better yield.',
                  isUser: false,
                ),
              ],
            ),
          ),

          // ✍️ Input Area (Large & Farmer-Friendly)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                // 🎤 Voice Button (UI-only)
                SizedBox(
                  height: 52,
                  width: 52,
                  child: IconButton(
                    icon: Icon(
                      Icons.mic,
                      size: 30,
                      color: Colors.green.shade700,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voice input coming soon 🎤'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // 📝 Text Input
                Expanded(
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Ask your farming question…',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // 📤 Send Button (Big Tap Area)
                SizedBox(
                  height: 56,
                  width: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // UI only
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.green.shade700,
                      elevation: 2,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 🟢 Bottom Navigation (Ask tab active)
      bottomNavigationBar: const AgriBottomNav(currentIndex: 1),
    );
  }
}

/// 💬 ChatBubble
/// Large, readable message bubble
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = isUser ? Colors.green.shade100 : Colors.grey.shade200;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black87,
              ),
        ),
      ),
    );
  }
}
