import 'package:agritech/models/chat_message_model.dart';
import 'package:equatable/equatable.dart';

/*
  This file defines the various states that the chat feature can adopt, 
  representing a snapshot of the chat's current data and UI status. It includes 
  the ChatStatus enum to categorize the state (e.g., initial, loading, loaded, 
  error) and the ChatState class itself, which holds the list of ChatMessage 
  objects, the current status, and any errorMessage. As an immutable class 
  extending Equatable, it also provides a copyWith method, enabling the ChatBloc 
  to produce new state instances efficiently for UI updates without modifying 
  the existing state.
 */

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {

  const ChatState({
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.errorMessage,
  });
  final List<ChatMessage> messages;
  final ChatStatus status;
  final String? errorMessage;

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatStatus? status,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [messages, status, errorMessage];
}
