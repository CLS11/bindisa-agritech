// ignore_for_file: deprecated_member_use

import 'package:agritech/bloc/chat_message_bloc.dart';
import 'package:agritech/bloc/chat_message_event.dart';
import 'package:agritech/bloc/chat_message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
  This Canvas renders the main user interface for the "Help & Support" section, 
  which includes static information about support options (Live Chat, Video 
  Tutorials, FAQs, Call Support, Email Support, Response Time) and dynamically 
  displays the chat interface. It integrates with the ChatBloc using BlocBuilder 
  to react to ChatState changes and update the chat messages in real-time, also 
  featuring a TextField for user input, a "Send" button, and automatic scrolling 
  to the latest message, thereby providing a comprehensive support hub.
 */

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(LoadChatHistory());
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(
        message: _messageController.text.trim(),
        sender: 'user',
      ));
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Live Support Chat', 
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section (Help & Support)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.spa, 
                          color: Colors.white, 
                          size: 30,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Help & Support',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get the help you need to make the most of Bindisa Agritech',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
        
            // Live Chat, Video Tutorials, FAQs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildSupportOption(
                      Icons.chat_outlined, 
                      'Live Chat',
                    ),
                    const Divider(
                      height: 1,
                    ),
                    _buildSupportOption(
                      Icons.play_circle_outline, 
                      'Video Tutorials',
                    ),
                    const Divider(
                      height: 1,
                    ),
                    _buildSupportOption(
                      Icons.help_outline, 
                      'FAQs',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
        
            // Chat with Support Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline, 
                            color: Colors.black87,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Chat with Support',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10, 
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Online',
                              style: TextStyle(
                                color: Colors.green.shade700, 
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16, 
                        vertical: 4,
                      ),
                      child: Text(
                        'Our support team is available 24/7 to help you',
                        style: TextStyle(
                          color: Colors.grey, 
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state.status == ChatStatus.loading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state.status == ChatStatus.error) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Error: ${state.errorMessage}',
                              ),
                            ),
                          );
                        } else if (state.status == ChatStatus.loaded) {
                          // Ensure _scrollToBottom is called after messages are rendered
                          _scrollToBottom();
                          return Container(
                            height: 200, // Fixed height for chat window
                            padding: const EdgeInsets.all(16),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final message = state.messages[index];
                                return Align(
                                  alignment: message.sender == 'user'
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: message.sender == 'user'
                                          ? Colors.green.shade100
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: message.sender == 'user'
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.message,
                                          style: TextStyle(
                                            color: message.sender == 'user'
                                                ? Colors.green.shade900
                                                : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          message.timestamp,
                                          style: const TextStyle(
                                            fontSize: 10, 
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox.shrink(); // Fallback
                      },
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, 
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _sendMessage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20, 
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Send', 
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
        
            // Call Support, Email Support, Response Time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildContactInfoCard(
                      Icons.call_outlined,
                      'Call Support',
                      'Speak directly with our experts',
                      '1800-123-4567',
                      Colors.green.shade50,
                      Colors.green.shade800,
                    ),
                    const Divider(height: 1),
                    _buildContactInfoCard(
                      Icons.mail_outline,
                      'Email Support',
                      'Send us detailed queries',
                      'support@bindisa.com',
                      Colors.orange.shade50,
                      Colors.orange.shade800,
                    ),
                    const Divider(height: 1),
                    _buildContactInfoCard(
                      Icons.access_time,
                      'Response Time',
                      'Average response time',
                      '< 2 hours',
                      Colors.blue.shade50,
                      Colors.blue.shade800,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon, 
        color: Colors.black87,
      ),
      title: Text(
        title, 
        style: const TextStyle(
          fontSize: 16, 
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios, 
        size: 16, 
        color: Colors.grey,
      ),
      onTap: () {
        // Handle navigation for each option (e.g., Live Chat, Video Tutorials, FAQs)
      },
    );
  }

  Widget _buildContactInfoCard(
    IconData icon,
    String title,
    String subtitle,
    String value,
    Color backgroundColor,
    Color valueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: valueColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13, 
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15, 
                    color: valueColor, 
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
