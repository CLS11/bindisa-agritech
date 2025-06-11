import 'package:agritech/models/profile_model.dart';
import 'package:equatable/equatable.dart';

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
