import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/firebase_operations.dart';
import 'package:my_chat/helper/local_repo.dart';
import 'package:my_chat/model/user_profile.dart';
import 'package:my_chat/provider/auth/auth_event.dart';
import 'package:my_chat/provider/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthSate> {
  final FirebaseOperations fireOperations = FirebaseOperations();

  AuthBloc() : super(AuthInitialState()) {
    on<RegisterEvent>(_userRegiser);
    on<SelectImage>(_selectImage);
    on<LoginEvent>(_login);
  }

  void _userRegiser(RegisterEvent event, Emitter<AuthSate> emit) async {
    emit(LoadingState(isLoading: true));
    try {
      final UserCredential userCredential =
          await fireOperations.authenticateUser(
        event.profile.emailId!,
        event.profile.password!,
      );

      if (userCredential.user != null) {
        String imageUrl = '';
        //upload Profile
        if (event.profileImage != null) {
          imageUrl = await fireOperations.uploadImage(
              Collections.usersImage.name,
              userCredential.user!.uid,
              event.profileImage!);
          dev.log('Profile Image : $imageUrl');
        }
        final UserProfile profile = event.profile.copyWith(
          id: userCredential.user!.uid,
          profileimage: imageUrl,
        );
        await fireOperations.createUser(profile);

        //save Data
        await LocalRepo().setProfileData(profile);

        //emit State
        emit(LoadingState());
        emit(RegiseredState());
      } else {
        emit(AuthErrorState('Authentication failed'));
      }
    } on FirebaseAuthException catch (e) {
      dev.log(e.code.toString());
      emit(AuthErrorState(e.code));
    } catch (e) {
      dev.log(e.toString());
      emit(AuthErrorState(e.toString()));
    }
  }

  void _selectImage(SelectImage event, Emitter<AuthSate> emit) async {
    emit(SelectedImage(event.imageFile));
  }

  void _login(LoginEvent event, Emitter<AuthSate> emit) async {
    emit(LoadingState(isLoading: true));
    try {
      final UserCredential userCredential =
          await fireOperations.loginUser(event.email, event.password);
      if (userCredential.user != null) {
        UserProfile? userProfile = await fireOperations.getUser(event.email);

        if (userProfile != null) {
          //save Data
          await LocalRepo().setProfileData(userProfile);
          emit(LoggedState());
        } else {
          emit(AuthErrorState('User Data Not Found'));
        }
      } else {
        emit(AuthErrorState('Invalid email and passord'));
      }
    } on FirebaseAuthException catch (e) {
      dev.log(e.code.toString());
      emit(AuthErrorState(e.code));
    } catch (e) {
      dev.log(e.toString());
      emit(AuthErrorState(e.toString()));
    }
    //emit State
    emit(LoadingState());
  }
}
