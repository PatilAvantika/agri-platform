import 'package:agri_platform/services/tts_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../services/chat_service.dart';
import '../../shared/widgets/agri_bottom_nav.dart';
import '../../utils/platform_utils.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TtsApiService _ttsApiService = TtsApiService();

  String? _currentPlayingUrl;
  bool isLoading = false;
  bool _isRetrying = false;

  final List<Map<String, dynamic>> messages = [
    {
      "text": "Namaskar! 🌱\nI am Agri Bot.\nAsk me anything about farming.",
      "isUser": false,
      "audioUrl": null,
    }
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      print('Current player state: $s');
      setState(() {
        if (s == PlayerState.completed || s == PlayerState.stopped) {
          _currentPlayingUrl = null;
        }
      });
    });
    _audioPlayer.onLog.listen((String msg) {
      print('Audio player log: $msg');
    });
  }

  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    super.dispose();
  }

  final List<String> quickChips = [
    "Best crop for me",
    "Today mandi prices",
    "Will it rain?",
    "How to increase yield?"
  ];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "text": text,
        "isUser": true,
      });
      isLoading = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final reply = await ChatService.sendMessage(
        userId: "demo_user", // REQUIRED
        message: text,
      );

      if (!mounted) return;

      setState(() {
        messages.add({
          "text": reply,
          "isUser": false,
          "audioUrl": null,
        });
      });
    } catch (e) {
      print("Chat error: $e");

      if (!mounted) return;

      setState(() {
        messages.add({
          "text": "Sorry, something went wrong. Please try again.",
          "isUser": false,
          "audioUrl": null,
        });
      });
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
      _scrollToBottom();
    }
  }

  Future<void> playTts(Map<String, dynamic> message) async {
    String? audioUrl = message['audioUrl'];

    // If URL is not cached, generate and cache it.
    if (audioUrl == null) {
      try {
        print("Requesting TTS for text: '${message['text']}'");
        audioUrl = await _ttsApiService.convertTextToSpeech(message['text']);
        setState(() {
          message['audioUrl'] = audioUrl;
        });
      } catch (e) {
        print("TTS error: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not generate audio URL")),
          );
        }
        return;
      }
    }

    if (audioUrl == null) return;

    final isThisAudioPlaying =
        _currentPlayingUrl == audioUrl && _audioPlayer.state == PlayerState.playing;
    final isThisAudioPaused =
        _currentPlayingUrl == audioUrl && _audioPlayer.state == PlayerState.paused;

    if (isThisAudioPlaying) {
      await _audioPlayer.pause();
    } else if (isThisAudioPaused) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(audioUrl));
      setState(() {
        _currentPlayingUrl = audioUrl;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F3),
      appBar: AppBar(
        title: const Text('Ask Agri Bot'),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.alerts);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _quickChips(),
          Expanded(child: _chatList()),
          _inputBar(),
        ],
      ),
      bottomNavigationBar: const AgriBottomNav(currentIndex: 1),
    );
  }

  Widget _quickChips() {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: quickChips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => ActionChip(
          label: Text(quickChips[i]),
          onPressed: () => sendMessage(quickChips[i]),
          backgroundColor: Colors.green.shade100,
        ),
      ),
    );
  }

  Widget _chatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (_, index) {
        if (isLoading && index == messages.length) {
          return BotBubble(
            text: "Agri Bot is typing… 🌾",
            onTtsPressed: () {},
          );
        }

        final msg = messages[index];
        if (msg["isUser"]) {
          return UserBubble(text: msg["text"]);
        }

        final isPlaying = _currentPlayingUrl == msg['audioUrl'] &&
            _audioPlayer.state == PlayerState.playing;
        final isPaused = _currentPlayingUrl == msg['audioUrl'] &&
            _audioPlayer.state == PlayerState.paused;

        return BotBubble(
          text: msg["text"],
          onTtsPressed: () => playTts(msg),
          isPlaying: isPlaying,
          isPaused: isPaused,
        );
      },
    );
  }

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: sendMessage,
              decoration: InputDecoration(
                hintText: 'Ask your farming question…',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.green.shade700,
            onPressed: () => sendMessage(_controller.text),
            child: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}

class BotBubble extends StatelessWidget {
  final String text;
  final VoidCallback onTtsPressed;
  final bool isPlaying;
  final bool isPaused;

  const BotBubble({
    Key? key,
    required this.text,
    required this.onTtsPressed,
    this.isPlaying = false,
    this.isPaused = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (isPlaying) {
      icon = Icons.pause;
    } else if (isPaused) {
      icon = Icons.play_arrow;
    } else {
      icon = Icons.volume_up;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(text)),
            IconButton(
              icon: Icon(icon),
              onPressed: onTtsPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class UserBubble extends StatelessWidget {
  final String text;
  const UserBubble({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
