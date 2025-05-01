part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class GoogleSignInRequested extends AuthEvent {
  @override
  List<Object?> get props => [];
}
