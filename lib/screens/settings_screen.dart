import 'package:agritech/bloc/profile_bloc.dart';
import 'package:agritech/bloc/profile_event.dart';
import 'package:agritech/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
  The SettingsScreen file defines the user interface for the "Settings" 
  tab within the user profile. 
  This StatelessWidget displays various user preferences, 
  particularly focusing on notification and privacy settings. 
  It uses SwitchListTile components to allow users to toggle SMS, email, 
  and push notifications, and a standard ListTile with a Switch for profile 
  visibility. 
  All toggles are connected to the ProfileBloc via UpdateSettings events, 
  ensuring that changes to user preferences are reflected in the application's 
  state.
  The screen is structured with clear section titles and containers for a clean, 
  organized presentation of settings options, and includes an example ListTile 
  for managing blocked users.
 */

class SettingsScreen extends StatelessWidget {

  const SettingsScreen({required this.profile, super.key});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Preferences
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Notification Preferences',
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'SMS Notifications',
                    ),
                    subtitle: const Text(
                      'Receive alerts, reports, and prices',
                    ),
                    value: profile.smsNotificationsEnabled,
                    onChanged: (bool value) {
                      context.read<ProfileBloc>().add(
                        UpdateSettings(
                          notificationPreferencesEnabled: 
                          profile.notificationPreferencesEnabled,
                          smsNotificationsEnabled: value,
                          emailNotificationsEnabled: 
                          profile.emailNotificationsEnabled,
                          pushNotificationsEnabled: 
                          profile.pushNotificationsEnabled,
                          profileVisibilityEnabled: 
                          profile.profileVisibilityEnabled,
                        ),
                      );
                    },
                    activeColor: Colors.green,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 8,
                    ),
                  ),
                  const Divider(
                    height: 1, 
                    indent: 16, 
                    endIndent: 16,
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Email Notifications',
                    ),
                    subtitle: const Text(
                      'Weekly reports, market prices',
                    ),
                    value: profile.emailNotificationsEnabled,
                    onChanged: (bool value) {
                      context.read<ProfileBloc>().add(
                        UpdateSettings(
                          notificationPreferencesEnabled: 
                          profile.notificationPreferencesEnabled,
                          smsNotificationsEnabled: 
                          profile.smsNotificationsEnabled,
                          emailNotificationsEnabled: value,
                          pushNotificationsEnabled: 
                          profile.pushNotificationsEnabled,
                          profileVisibilityEnabled: 
                          profile.profileVisibilityEnabled,
                        ),
                      );
                    },
                    activeColor: Colors.green,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Push Notifications
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Push Notifications',
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Allow Push Notifications',
                ),
                subtitle: const Text(
                  'Get urgent alerts on your device',
                ),
                value: profile.pushNotificationsEnabled,
                onChanged: (bool value) {
                  context.read<ProfileBloc>().add(
                    UpdateSettings(
                      notificationPreferencesEnabled: 
                      profile.notificationPreferencesEnabled,
                      smsNotificationsEnabled: 
                      profile.smsNotificationsEnabled,
                      emailNotificationsEnabled: 
                      profile.emailNotificationsEnabled,
                      pushNotificationsEnabled: value,
                      profileVisibilityEnabled: 
                      profile.profileVisibilityEnabled,
                    ),
                  );
                },
                activeColor: Colors.green,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, 
                  vertical: 8,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Privacy Settings
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Privacy Settings',
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Profile Visibility',
                    ),
                    subtitle: const Text(
                      'Visible to other farmers',
                    ),
                    trailing: Switch(
                      value: profile.profileVisibilityEnabled,
                      onChanged: (bool value) {
                        context.read<ProfileBloc>().add(
                          UpdateSettings(
                            notificationPreferencesEnabled: 
                            profile.notificationPreferencesEnabled,
                            smsNotificationsEnabled: 
                            profile.smsNotificationsEnabled,
                            emailNotificationsEnabled: 
                            profile.emailNotificationsEnabled,
                            pushNotificationsEnabled: 
                            profile.pushNotificationsEnabled,
                            profileVisibilityEnabled: value,
                          ),
                        );
                      },
                      activeColor: Colors.green,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 8,
                    ),
                  ),
                  const Divider(
                    height: 1, 
                    indent: 16, 
                    endIndent: 16,
                  ),
                  ListTile(
                    title: const Text(
                      'Manage Blocked Users',
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios, 
                      size: 16, 
                      color: Colors.grey,
                    ),
                    onTap: () {
                      // Navigate to manage blocked users screen
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
