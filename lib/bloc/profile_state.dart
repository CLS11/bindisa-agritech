import 'package:agritech/models/profile_model.dart';
import 'package:equatable/equatable.dart';

/*
  The profile_state.dart file defines the various states that the user's profile
  can be in, acting as immutable snapshots of the data and UI for the BLoC state 
  management pattern.
  It establishes an abstract ProfileState base class, leveraging Equatable for 
  efficient value comparison, and then specializes into concrete states: 
  ProfileInitial (the starting state), ProfileLoading (indicating data is being 
  fetched), ProfileLoaded (containing the successfully loaded Profile data), and
  ProfileError (carrying an error message if something went wrong). 
  Each state explicitly defines the data it holds, allowing the ProfileBloc to 
  emit precise status updates that the UI can react to and render accordingly, 
  ensuring a clear and predictable user experience.
 */

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {

  const ProfileLoaded(this.profile);
  final Profile profile;

  @override
  List<Object> get props => [profile];
}

class ProfileError extends ProfileState {

  const ProfileError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
