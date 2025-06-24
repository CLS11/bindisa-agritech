// ignore_for_file: deprecated_member_use

import 'package:agritech/bloc/notification_bloc.dart';
import 'package:agritech/bloc/notification_event.dart';
import 'package:agritech/bloc/notification_state.dart';
import 'package:agritech/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
  This file renders the main user interface for notifications, dynamically 
  displaying a list of AppNotifications, interactive filter chips, and 
  customizable NotificationSettings based on the current NotificationState 
  received from the NotificationBloc, allowing users to interact with and 
  manage their notifications and preferences.
 */

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Map filter strings to their corresponding NotificationType for display
  final Map<String, List<NotificationType>> _filterMap = {
    'All': NotificationType.values,
    'Wheat': [NotificationType.wheatHarvest],
    'Market': [NotificationType.pesticideOrder],
    'Tips': [
      NotificationType.agriSmartTips, 
      NotificationType.fertilizerApplicationTip,
    ],
    'Soil': [
      NotificationType.soilLeadAlert, 
      NotificationType.kharifCropReport,
    ], // Assuming Kharif report might include soil
    'New': [], // This will be handled by isRead status
  };

  @override
  void initState() {
    super.initState();
    // Dispatch LoadNotifications when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationBloc>().add(LoadNotifications());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'notifications', 
          style: TextStyle(
            color: Colors.black,
            ),
          ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: false,
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
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.status == NotificationListStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == NotificationListStatus.error) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
              ),
            );
          } else if (state.status == NotificationListStatus.loaded) {
            // Apply filter based on currentFilter state
            final filteredNotifications = state.notifications.where((notification){
              if (state.currentFilter == 'All') {
                return true;
              } else if (state.currentFilter == 'New') {
                return !notification.isRead;
              } else {
                return _filterMap[state.currentFilter]!
                    .contains(notification.type);
              }
            }).toList();

            return Column(
              children: [
                // Unread Count and Mark All Read
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16, 
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredNotifications.where((n) => !n.isRead).
                        length} unread',
                        style: const TextStyle(
                          fontSize: 14, 
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<NotificationBloc>().add(
                            MarkAllNotificationsAsRead(),
                          );
                        },
                        child: const Text(
                          'Mark All Read',
                          style: TextStyle(
                            color: Colors.green, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Filter Chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          'All', 
                          state.currentFilter, 
                          context,
                        ),
                        _buildFilterChip(
                          'Wheat', 
                          state.currentFilter, 
                          context,
                        ),
                        _buildFilterChip(
                          'Market', 
                          state.currentFilter, 
                          context,
                        ),
                        _buildFilterChip(
                          'Tips', 
                          state.currentFilter, 
                          context,
                        ),
                        _buildFilterChip(
                          'Soil', 
                          state.currentFilter, 
                          context,
                        ),
                        _buildFilterChip(
                          'New', 
                          state.currentFilter, 
                          context,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notifications List
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredNotifications.length + 1, 
                    // +1 for settings card
                    itemBuilder: (context, index) {
                      if (index < filteredNotifications.length) {
                        final notification = filteredNotifications[index];
                        return _buildNotificationCard(
                          notification, 
                          context,
                        );
                      } else {
                        // Notification Settings Card at the end
                        return _buildNotificationSettingsCard(
                          state.settings, 
                          context,
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: Text(
              'No notifications to display.',
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(
    String text, 
    String currentFilter, 
    BuildContext context,
  ){
    final isSelected = text == currentFilter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(text),
        selected: isSelected,
        selectedColor: Colors.green.shade100,
        backgroundColor: Colors.grey.shade200,
        labelStyle: TextStyle(
          color: isSelected ? Colors.green.shade800 : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide.none, // No border for a cleaner look
        ),
        onSelected: (selected) {
          context.read<NotificationBloc>().add(
            FilterNotifications(text),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    AppNotification notification, 
    BuildContext context,
  ) {
    final cardColor = notification.isRead ? Colors.white : Colors.white; 
    // Can change if unread has a different background
    final border = BorderSide(
      color: Colors.grey.shade200,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16, 
        vertical: 8,
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: border,
        ),
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getNotificationIcon(notification.type), 
                      color: Colors.green.shade800, 
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead ? 
                            FontWeight.normal : 
                            FontWeight.bold,
                            fontSize: 16,
                            color: notification.isRead ? 
                            Colors.grey.shade800 : 
                            Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: notification.isRead ? 
                            Colors.grey.shade600 : 
                            Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notification.timeAgo,
                              style: const TextStyle(
                                fontSize: 12, 
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8, 
                                vertical: 4,
                                ),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(
                                  notification.priority,
                                  ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                notification.priority,
                                style: TextStyle(
                                  color: _getPriorityColor(
                                    notification.priority,
                                  ),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<NotificationBloc>().add(
                        MarkNotificationAsRead(
                          notification.id,
                        ),
                      );
                    },
                    child: Icon(
                      notification.isRead ? 
                      Icons.check_circle : 
                      Icons.circle_outlined,
                      color: notification.isRead ? 
                      Colors.green : 
                      Colors.grey,
                      size: 20,
                    ),
                  ),
                ],
              ),
              if (!notification.isRead) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.read<NotificationBloc>().add(
                        MarkNotificationAsRead(
                          notification.id,
                        ),
                      );
                    },
                    child: const Text(
                      'Mark as Read',
                      style: TextStyle(
                        color: Colors.green, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.wheatHarvest:
        return Icons.eco;
      case NotificationType.agriSmartTips:
        return Icons.lightbulb_outline;
      case NotificationType.pesticideOrder:
        return Icons.shopping_bag_outlined;
      case NotificationType.toolReturnReminder:
        return Icons.handyman_outlined;
      case NotificationType.kharifCropReport:
        return Icons.assessment_outlined;
      case NotificationType.systemUpdate:
        return Icons.system_update_alt_outlined;
      case NotificationType.fertilizerApplicationTip:
        return Icons.grass_outlined;
      case NotificationType.soilLeadAlert:
        return Icons.warning_amber_outlined;
      case NotificationType.unknown:
      return Icons.notifications_none;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High Priority':
        return Colors.red;
      case 'Medium Priority':
        return Colors.orange;
      case 'Low Priority':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildNotificationSettingsCard(
    NotificationSettings settings, 
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16, 
        vertical: 16,
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notification Settings',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingSwitch(
                label: 'Enable Alerts',
                value: settings.enableAlerts,
                onChanged: (value) {
                  context.read<NotificationBloc>().add(
                    ToggleNotificationSetting(
                      settings.copyWith(
                        enableAlerts: value,
                      ),
                    ),
                  );
                },
              ),
              _buildSettingSwitch(
                label: 'System Updates',
                value: settings.enableSystemUpdates,
                onChanged: (value) {
                  context.read<NotificationBloc>().add(
                    ToggleNotificationSetting(
                      settings.copyWith(
                        enableSystemUpdates: value,
                      ),
                    ),
                  );
                },
              ),
              _buildSettingSwitch(
                label: 'Agricultural Tips',
                value: settings.enableAgriculturalTips,
                onChanged: (value) {
                  context.read<NotificationBloc>().add(
                    ToggleNotificationSetting(
                      settings.copyWith(
                        enableAgriculturalTips: value,
                      ),
                    ),
                  );
                },
              ),
              _buildSettingSwitch(
                label: 'Soil Reminders',
                value: settings.enableSoilReminders,
                onChanged: (value) {
                  context.read<NotificationBloc>().add(
                    ToggleNotificationSetting(
                      settings.copyWith(
                        enableSoilReminders: value,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Show a SnackBar to confirm settings are updated
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Notification settings updated!',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.green, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                value ? 
                Icons.check_circle_outline : 
                Icons.circle_outlined, color: 
                value ? 
                Colors.green : 
                Colors.grey, size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: value ? 
                  Colors.black87 : 
                  Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
