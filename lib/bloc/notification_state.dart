import 'package:agritech/models/notification_model.dart';
import 'package:equatable/equatable.dart';

/*
  This file describes the various states that the notification feature can be in,
  acting as a complete snapshot of the data and UI at any given moment; 
  it features the NotificationListStatus enum to categorize loading states and 
  the NotificationState class itself, which encapsulates the list of 
  notifications, current settings, status, and active filter, all as an 
  immutable Equatable class with a copyWith method for precise state updates.
 */

enum NotificationListStatus { initial, loading, loaded, error }

class NotificationState extends Equatable { 
 
  const NotificationState({
    this.notifications = const [],
    this.settings = const NotificationSettings(),
    this.status = NotificationListStatus.initial,
    this.errorMessage,
    this.currentFilter = 'All',
     // e.g., 'All', 'Wheat', 'Market', 'Tips', 'Soil'

  });
  final List<AppNotification> notifications;
  final NotificationSettings settings;
  final NotificationListStatus status;
  final String? errorMessage;
  final String currentFilter;

  NotificationState copyWith({
    List<AppNotification>? notifications,
    NotificationSettings? settings,
    NotificationListStatus? status,
    String? errorMessage,
    String? currentFilter,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      settings: settings ?? this.settings,
      status: status ?? this.status,
      errorMessage: errorMessage,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        settings,
        status,
        errorMessage,
        currentFilter,
      ];
}
