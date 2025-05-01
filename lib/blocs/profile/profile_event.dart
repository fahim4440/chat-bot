part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}
class UpdateProfileEvent extends ProfileEvent {
  final Map<String, String> apiKeys;
  const UpdateProfileEvent(this.apiKeys);
  @override
  List<Object?> get props => [apiKeys];
}

class LogoutEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}