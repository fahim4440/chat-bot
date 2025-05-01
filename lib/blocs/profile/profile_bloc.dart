import 'package:bloc/bloc.dart';
import 'package:chat_bot/models/user.dart';
import 'package:chat_bot/services/firebase_services.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseServices _firebaseServices;
  ProfileBloc(this._firebaseServices) : super(ProfileInitial()) {
    on<LoadProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        UserModel user = await _firebaseServices.getUserFromFirebase();
        emit(ProfileLoaded(user: user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        await _firebaseServices.updateUserInfoInFirebase(event.apiKeys);
        UserModel user = await _firebaseServices.getUserFromFirebase();
        emit(ProfileLoaded(user: user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      await _firebaseServices.signOut();
      emit(ProfileLogout());
    });
  }
}
