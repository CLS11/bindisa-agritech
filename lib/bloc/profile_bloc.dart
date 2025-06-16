import 'package:agritech/bloc/profile_event.dart';
import 'package:agritech/bloc/profile_state.dart';
import 'package:agritech/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
  The ProfileBloc file orchestrates the state management for the user's profile,
  extending Bloc to process ProfileEvents and emit ProfileStates.
   Upon initialization, it's configured to handle various events like LoadProfile, 
   which simulates fetching initial profile data, and UpdatePersonalInfo, 
   UpdateFarmingDetails, or UpdateSettings, which trigger the update of specific
   profile sections. 
   For each event, the BLoC constructs a new, immutable ProfileState (e.g., 
   ProfileLoaded with the updated Profile object or ProfileError in case of 
   failure) and emits it, ensuring that the UI always reflects the most current 
   and consistent profile data without direct mutation.
 */

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdatePersonalInfo>(_onUpdatePersonalInfo);
    on<UpdateFarmingDetails>(_onUpdateFarmingDetails);
    on<UpdateSettings>(_onUpdateSettings);
  }

  // Simulate fetching data from an external source
  Future<void> _onLoadProfile(
    LoadProfile event, 
    Emitter<ProfileState> emit
    ) async {
    emit(
      ProfileLoading(),
    );
    try {
      // Simulate network delay
      await Future.delayed(
        const Duration(
          seconds: 1,
        ),
      );
      // Dummy data, in a real app this would come from an API call
      final profile = Profile(
        fullName: 'Rajesh Kumar',
        mobileNumber: '+91 98765 43210',
        emailAddress: 'rajesh.kumar@email.com',
        location: 'Pune, Maharashtra',
        memberSince: 'March 2023',
        primaryCrops: ['Rice & Wheat'],
        equipmentAndTools: [
          'Tractor - John Deere (300D)',
          'Irrigation System - Drip',
          'Harvester - Combine',
        ],
        totalRevenue: 87000,
        averagePerCrop: 90145,
      );
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(
        'Failed to load profile: ${e.toString()}',
       ),
      );
    }
  }

  void _onUpdatePersonalInfo(
    UpdatePersonalInfo event, 
    Emitter<ProfileState> emit,
    ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(
        ProfileLoaded(
          event.profile,
        ),
      ); 
      // Update the profile with new personal info
    }
  }

  void _onUpdateFarmingDetails(
    UpdateFarmingDetails event, 
    Emitter<ProfileState> emit,
    ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(
        ProfileLoaded(
          event.profile,
        ),
      ); // Update the profile with new farming details
    }
  }

  void _onUpdateSettings(
    UpdateSettings event, 
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedProfile = currentState.profile.copyWith(
        notificationPreferencesEnabled: event.notificationPreferencesEnabled,
        smsNotificationsEnabled: event.smsNotificationsEnabled,
        emailNotificationsEnabled: event.emailNotificationsEnabled,
        pushNotificationsEnabled: event.pushNotificationsEnabled,
        profileVisibilityEnabled: event.profileVisibilityEnabled,
      );
      emit(
        ProfileLoaded(
          updatedProfile,
        ),
      );
    }
  }
}
