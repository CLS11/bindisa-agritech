import 'package:agritech/bloc/chat_message_event.dart';
import 'package:agritech/bloc/chat_message_state.dart';
import 'package:agritech/models/chat_message_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/*
  This file contains the core business logic for the chat functionality, 
  implementing the ChatBloc which extends Bloc to manage the chat's state. It 
  listens for incoming ChatEvents (such as LoadChatHistory, SendMessage, and 
  ReceiveMessage), processes these events—simulating network delays for loading 
  and automatic support replies—and then emits corresponding ChatStates to 
  update the UI. This BLoC ensures that chat messages are managed, sent, and 
  received in a predictable and reactive manner, maintaining data consistency.
 */
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ChatStatus.loading,
      ),
    );
    try {
      await Future.delayed(
        const Duration(
          seconds: 1,
        ),
      ); // Simulate network delay

      final dummyChat = <ChatMessage>[
        ChatMessage(
          id: const Uuid().v4(),
          sender: 'support',
          message: 'Hello! How can I help you today?',
          timestamp: DateFormat('h:mm a').format(
            DateTime.now().subtract(
              const Duration(
                minutes: 30,
                ),
              ),
          ),
        ),
      ];

      emit(state.copyWith(
        messages: dummyChat,
        status: ChatStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: 'Failed to load chat history: $e',
      ));
    }
  }

  void _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) {
    final newMessage = ChatMessage(
      id: const Uuid().v4(),
      sender: event.sender,
      message: event.message,
      timestamp: DateFormat('h:mm a').format(
        DateTime.now(),
      ),
    );
    final updatedMessages = List<ChatMessage>.from(state.messages)
    ..add(newMessage);
    emit(
      state.copyWith(
        messages: updatedMessages,
      ),
    );

    // Simulate immediate reply from support after a short delay
    Future.delayed(
      const Duration(
        seconds: 1,
      ), () {
      add(const ReceiveMessage(
        sender: 'support',
        message: 'Thank you for your message. Our team will get back to you shortly.',
      ));
    });
  }

  void _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ChatState> emit,
  ) {
    final newMessage = ChatMessage(
      id: const Uuid().v4(),
      sender: event.sender,
      message: event.message,
      timestamp: DateFormat('h:mm a').format(
        DateTime.now(),
      ),
    );
    final updatedMessages = List<ChatMessage>.from(state.messages)
    ..add(newMessage);
    emit(
      state.copyWith(
        messages: updatedMessages,
      ),
    );
  }
}
