import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/firebase_operations.dart';
import 'package:my_chat/helper/local_repo.dart';
import 'package:my_chat/model/user_profile.dart';
import 'package:my_chat/provider/auth_event.dart';
import 'package:my_chat/provider/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthSate> {
  final FireOperations fireOperations = FireOperations();

  AuthBloc() : super(AuthInitialState()) {
    on<RegisterEvent>(_userRegiser);
    on<SelectImage>(_selectImage);
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
        final DocumentReference<Map<String, dynamic>> doc =
            await fireOperations.createUser(event.profile);

        String imageUrl = '';
        //upload Profile
        if (event.profileImage != null) {
          imageUrl = await fireOperations.uploadImage(
              Collections.USERS_IMAGE.name,
              userCredential.user!.uid,
              event.profileImage!);
          dev.log('Profile Image : $imageUrl');
        }
        final UserProfile profile = event.profile.copyWith(
          id: doc.id,
          profileimage: imageUrl,
        );

        await fireOperations.updateUser(profile);

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
}
