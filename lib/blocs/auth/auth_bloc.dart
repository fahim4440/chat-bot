import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/user.dart';
import '../../services/auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  AuthBloc(this._authService) : super(AuthInitial()) {
    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.signInWithGoogle();
        emit(Authenticated(user));
      } catch (e) {
        print(e.toString());
        emit(Unauthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      await _authService.signOut();
      emit(Unauthenticated());
    });
  }
}
