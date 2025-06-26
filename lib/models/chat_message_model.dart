import 'package:equatable/equatable.dart';

/*
  This file defines the immutable data structure for a single ChatMessage 
  within the chat feature. It encapsulates essential details such as the 
  message's unique id, the sender (e.g., 'user' or 'support'), the actual 
  message content, and a timestamp. The class extends Equatable, allowing for 
  efficient value-based comparison of chat messages, which is beneficial for 
  optimizing BLoC state management by preventing unnecessary UI rebuilds if 
  message content remains unchanged.
 */

class ChatMessage extends Equatable {

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.message,
    required this.timestamp,
  });
  final String id;
  final String sender; 
  final String message;
  final String timestamp;

  @override
  List<Object> get props => [id, sender, message, timestamp];
}