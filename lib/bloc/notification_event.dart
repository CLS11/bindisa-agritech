import 'package:agritech/models/notification_model.dart';
import 'package:equatable/equatable.dart';

/*  This file enumerates all possible user interactions and system triggers 
    related to notifications as distinct event classes, such as 
    LoadNotifications to fetch data, MarkNotificationAsRead for individual items, 
    MarkAllNotificationsAsRead, ToggleNotificationSetting to update preferences,
    and FilterNotifications to apply display filters, with each event extending 
    Equatable to ensure proper comparison in the BLoC flow.
 */

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {

  const MarkNotificationAsRead(this.notificationId);
  final String notificationId;

  @override
  List<Object> get props => [notificationId];
}

class MarkAllNotificationsAsRead extends NotificationEvent {}

class ToggleNotificationSetting extends NotificationEvent {

  const ToggleNotificationSetting(this.settings);
  final NotificationSettings settings;

  @override
  List<Object> get props => [settings];
}

class FilterNotifications extends NotificationEvent { 
  // e.g., 'All', 'Wheat', 'Market', 'Tips', 'Soil'

  const FilterNotifications(this.filterType);
  final String filterType;

  @override
  List<Object> get props => [filterType];
}
