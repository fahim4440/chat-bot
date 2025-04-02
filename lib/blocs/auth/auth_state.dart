part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  final UserModel user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}
