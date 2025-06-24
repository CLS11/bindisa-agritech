import 'package:agritech/bloc/notification_event.dart';
import 'package:agritech/bloc/notification_state.dart';
import 'package:agritech/models/notification_model.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart'; 

/*
  This file contains the central business logic for managing the notification 
  state, implemented as a Bloc that listens for NotificationEvents (like 
  loading data, marking notifications as read, or changing settings) and 
  transforms them into corresponding NotificationState emissions, simulating 
  data operations and ensuring the application's notification data is 
  consistently and reactively updated.
 */

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllNotificationsAsRead);
    on<ToggleNotificationSetting>(_onToggleNotificationSetting);
    on<FilterNotifications>(_onFilterNotifications);
  }

  // Simulate fetching notifications and settings from an external source
  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationListStatus.loading,
      ),
    );
    try {
      await Future.delayed(
        const Duration(
          seconds: 1,
          ),
        ); // Simulate network delay

      final dummyNotifications = <AppNotification>[
        AppNotification(
          id: const Uuid().v4(),
          type: NotificationType.wheatHarvest,
          title: 'Wheat Harvest Reminder',
          description: 'Your wheat harvest is scheduled in 48 hours.',
          timeAgo: '1 hour ago',
          priority: 'High Priority',
        ),
        AppNotification(
          id: const Uuid().v4(),
          type: NotificationType.agriSmartTips,
          title: 'AgriSmart Tips',
          description: 'Fertilizer application per acre has been updated.',
          timeAgo: '2 hours ago',
          priority: 'Medium Priority',
        ),
        AppNotification(
          id: const Uuid().v4(),
          type: NotificationType.pesticideOrder,
          title: 'Pesticide Order - Hari',
          description: 'Sample pesticide delivered for 500gm label quantity.',
          timeAgo: 'Yesterday',
          priority: 'Low Priority',
        ),
        AppNotification(
          id: const Uuid().v4(),
          type: NotificationType.toolReturnReminder,
          title: 'Tool Return Reminder',
          description: 
          'Your tool rent map 3 months ago. Schedule a new rent today',
          timeAgo: '1 day ago',
          priority: 'Medium Priority',
        ),
        AppNotification(
          id: const Uuid().v4(),
          type: NotificationType.kharifCropReport,
          title: 'Kharif Crop Report',
          description: 
          'Kharif crop report - temperature, analysis of soil, moisture content, opposition plants.',
          timeAgo: '1 day ago',
          priority: 'Low Priority',
        ),
        AppNotification(
          id: const Uuid().v4(),
          type: NotificationType.systemUpdate,
          title: 'System Update',
          description: 'System updated successfully from v12.0 to v12.0.1.',
          timeAgo: '2 days ago',
          priority: 'Medium Priority',
        ),
        AppNotification(
          id: const Uuid().v4(),
          type: NotificationType.fertilizerApplicationTip,
          title: 'Fertilizer Application Tip',
          description: 
          'Apply phosphate fertilizer as per application tips to ensure maximum yields.',
          timeAgo: '3 days ago',
          priority: 'Low Priority',
        ),
        AppNotification(
          id: const Uuid().v4(),
          type: NotificationType.soilLeadAlert,
          title: 'Soil Lead Alert',
          description: 'Soil ph level decreased below optimum range. Submit a soil test for application to balance nutrients.',
          timeAgo: '4 days ago',
          priority: 'High Priority',
        ),
      ];

      // Simulate fetching settings
      const dummySettings = NotificationSettings(
        enableAlerts: true,
      );

      emit(
        state.copyWith(
        notifications: dummyNotifications,
        settings: dummySettings,
        status: NotificationListStatus.loaded,
       ),
     );
    } catch (e) {
      emit(state.copyWith(
        status: NotificationListStatus.error,
        errorMessage: 'Failed to load notifications: $e',
      ));
    }
  }

  void _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) {
    final updatedNotifications = state.notifications.map((notification) {
      return notification.id == event.notificationId
          ? notification.copyWith(isRead: true)
          : notification;
    }).toList();
    emit(
      state.copyWith(
        notifications: updatedNotifications,
      ),
    );
  }

  void _onMarkAllNotificationsAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) {
    final updatedNotifications = state.notifications.map((notification) {
      return notification.copyWith(isRead: true);
    }).toList();
    emit(
      state.copyWith(
        notifications: updatedNotifications,
      ),
    );
  }

  void _onToggleNotificationSetting(
    ToggleNotificationSetting event,
    Emitter<NotificationState> emit,
  ) {
    emit(
      state.copyWith(
        settings: event.settings,
      ),
    );
  }

  void _onFilterNotifications(
    FilterNotifications event,
    Emitter<NotificationState> emit,
  ) {
    emit(
      state.copyWith(
        currentFilter: event.filterType,
      ),
    );
  }
}
