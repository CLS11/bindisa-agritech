import 'package:equatable/equatable.dart';

//This file defines the core data structures for the notification feature, 
//including the AppNotification class, which outlines the properties of an 
//individual notification (like ID, type, title, description, priority, 
//and read status), and the NotificationSettings class, 
//which holds user preferences for different notification categories, 
//both designed as immutable classes using Equatable for 
//efficient state comparison.



enum NotificationType {
  wheatHarvest,
  agriSmartTips,
  pesticideOrder,
  toolReturnReminder,
  kharifCropReport,
  systemUpdate,
  fertilizerApplicationTip,
  soilLeadAlert,
  unknown,
}

// Helper to parse string to NotificationType
NotificationType notificationTypeFromString(String type) {
  switch (type) {
    case 'Wheat Harvest':
      return NotificationType.wheatHarvest;
    case 'AgriSmart Tips':
      return NotificationType.agriSmartTips;
    case 'Pesticide Order':
      return NotificationType.pesticideOrder;
    case 'Tool Return Reminder':
      return NotificationType.toolReturnReminder;
    case 'Kharif Crop Report':
      return NotificationType.kharifCropReport;
    case 'System Update':
      return NotificationType.systemUpdate;
    case 'Fertilizer Application Tip':
      return NotificationType.fertilizerApplicationTip;
    case 'Soil Lead Alert':
      return NotificationType.soilLeadAlert;
    default:
      return NotificationType.unknown;
  }
}


class AppNotification extends Equatable {

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.priority,
    this.isRead = false,
  });
  final String id;
  final NotificationType type;
  final String title;
  final String description;
  final String timeAgo;
  final String priority; 
  // e.g., 'High Priority', 'Medium Priority', 'Low Priority'
  final bool isRead;

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? description,
    String? timeAgo,
    String? priority,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      timeAgo: timeAgo ?? this.timeAgo,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object> get props => [
        id,
        type,
        title,
        description,
        timeAgo,
        priority,
        isRead,
      ];
}

class NotificationSettings extends Equatable {

  const NotificationSettings({
    this.enableAlerts = true,
    this.enableSystemUpdates = true,
    this.enableAgriculturalTips = true,
    this.enableSoilReminders = false,
     // Default is false for soil reminders
  });
  final bool enableAlerts;
  final bool enableSystemUpdates;
  final bool enableAgriculturalTips;
  final bool enableSoilReminders;

  NotificationSettings copyWith({
    bool? enableAlerts,
    bool? enableSystemUpdates,
    bool? enableAgriculturalTips,
    bool? enableSoilReminders,
  }) {
    return NotificationSettings(
      enableAlerts: enableAlerts 
      ?? this.enableAlerts,
      enableSystemUpdates: enableSystemUpdates 
      ?? this.enableSystemUpdates,
      enableAgriculturalTips: enableAgriculturalTips 
      ?? this.enableAgriculturalTips,
      enableSoilReminders: enableSoilReminders 
      ?? this.enableSoilReminders,
    );
  }

  @override
  List<Object> get props => [
        enableAlerts,
        enableSystemUpdates,
        enableAgriculturalTips,
        enableSoilReminders,
      ];
}
