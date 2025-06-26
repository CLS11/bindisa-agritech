import 'package:equatable/equatable.dart';

/*
  This file enumerates all possible events or actions that can occur within the 
  chat functionality, serving as the input for the ChatBloc. It defines an 
  abstract ChatEvent base class and specific events like LoadChatHistory to 
  fetch initial messages, SendMessage when a user sends a message, and 
  ReceiveMessage for incoming support replies. Each event carries the necessary 
  data (e.g., the message content and sender) and extends Equatable to ensure 
  proper equality checks within the BLoC system.
 */

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChatHistory extends ChatEvent {}

class SendMessage extends ChatEvent { 

  const SendMessage({required this.message, required this.sender});
  final String message;
  final String sender;

  @override
  List<Object> get props => [message, sender];
}

class ReceiveMessage extends ChatEvent {

  const ReceiveMessage({required this.message, required this.sender});
  final String message;
  final String sender;

  @override
  List<Object> get props => [message, sender];
}
