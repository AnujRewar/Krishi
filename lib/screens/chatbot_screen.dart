// chatbot_screen.dart
import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, dynamic>> _chatMessages = [];
  final TextEditingController _chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KrishiAI Farming Assistant'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () => _showLanguageOptions(context),
            tooltip: 'Change Language',
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: _chatMessages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.agriculture, size: 60, color: Colors.green),
                        SizedBox(height: 16),
                        Text(
                          'Hello! I am KrishiAI',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Ask me about crops, weather, or farming techniques',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _chatMessages.length,
                    itemBuilder: (context, index) {
                      final message = _chatMessages[index];
                      return _buildChatMessage(
                        message['text'] as String,
                        message['isUser'] as bool,
                        message['time'] as String,
                      );
                    },
                  ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'Ask about crops, weather, farming...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(String text, bool isUser, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundColor: Colors.green,
              child: const Icon(Icons.agriculture, color: Colors.white, size: 18),
            ),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    final userMessage = {
      'text': _chatController.text,
      'isUser': true,
      'time': _formatTime(DateTime.now()),
    };

    setState(() {
      _chatMessages.add(userMessage);
    });

    _chatController.clear();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      final aiResponse = _getAIResponse(userMessage['text'] as String);
      setState(() {
        _chatMessages.add({
          'text': aiResponse,
          'isUser': false,
          'time': _formatTime(DateTime.now()),
        });
      });
    });
  }

  String _getAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    if (message.contains('wheat') || message.contains('crop')) {
      return "For wheat cultivation, ensure soil pH between 6.0-7.5. Optimal temperature is 20-25°C. Requires 500-600mm rainfall. Best planting time is October-November.";
    } else if (message.contains('weather') || message.contains('rain')) {
      return "Current weather is favorable for farming. Temperature: 28°C, Humidity: 65%. Expected rainfall in next 3 days: 15mm.";
    } else if (message.contains('fertilizer') || message.contains('nutrient')) {
      return "For most crops, use NPK 20:20:20. Apply 100kg/hectare before planting and 50kg/hectare during growth stage.";
    } else if (message.contains('pest') || message.contains('insect')) {
      return "Common pests: Aphids, Bollworms. Use neem-based pesticides. Monitor crops weekly. Remove infected plants immediately.";
    } else if (message.contains('irrigation') || message.contains('water')) {
      return "Water requirements vary by crop. Wheat: 4-6 irrigations. Rice: Continuous flooding. Vegetables: Daily light watering.";
    } else {
      return "I can help you with crop selection, weather information, pest control, irrigation scheduling, and fertilizer recommendations. What would you like to know?";
    }
  }

  void _showLanguageOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, 'English'),
            _buildLanguageOption(context, 'Hindi'),
            _buildLanguageOption(context, 'Marathi'),
            _buildLanguageOption(context, 'Tamil'),
            _buildLanguageOption(context, 'Telugu'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(language),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to $language'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}