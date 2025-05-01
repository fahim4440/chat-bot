import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/firebase_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseServices _firebaseServices;
  AuthBloc(this._firebaseServices) : super(AuthInitial()) {
    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _firebaseServices.signInWithGoogle();
        emit(Authenticated(user));
      } catch (e) {
        debugPrint(e.toString());
        emit(Unauthenticated(e.toString()));
      }
    });
  }
}
