import 'package:agritech/models/profile_model.dart';
import 'package:equatable/equatable.dart';

/*
  The profile_event.dart file defines all the possible "actions" or "intents" 
  that can occur within the user profile section of the application, serving as 
  the communication mechanism between the UI and the ProfileBloc. 
  It establishes an abstract ProfileEvent base class, inheriting from Equatable 
  to enable easy value comparison, and then specializes into distinct event types
  like LoadProfile (to fetch initial data), UpdatePersonalInfo, 
  UpdateFarmingDetails, and UpdateSettings. 
  Each concrete event class carries the specific, immutable data required to 
  perform its respective operation on the profile, ensuring that the ProfileBloc
  receives clear instructions on how to update the application's state in 
  response to user interactions or system triggers.

 */


abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdatePersonalInfo extends ProfileEvent { 
  // Pass the entire profile or specific fields

  const UpdatePersonalInfo(this.profile);
  final Profile profile;

  @override
  List<Object> get props => [profile];
}

class UpdateFarmingDetails extends ProfileEvent { 
  // Pass the entire profile or specific fields

  const UpdateFarmingDetails(this.profile);
  final Profile profile;

  @override
  List<Object> get props => [profile];
}

class UpdateSettings extends ProfileEvent {

  const UpdateSettings({
    required this.notificationPreferencesEnabled,
    required this.smsNotificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.pushNotificationsEnabled,
    required this.profileVisibilityEnabled,
  });
  final bool notificationPreferencesEnabled;
  final bool smsNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool pushNotificationsEnabled;
  final bool profileVisibilityEnabled;

  @override
  List<Object> get props => [
        notificationPreferencesEnabled,
        smsNotificationsEnabled,
        emailNotificationsEnabled,
        pushNotificationsEnabled,
        profileVisibilityEnabled,
      ];
}
