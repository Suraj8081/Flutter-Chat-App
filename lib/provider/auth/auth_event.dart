import 'dart:io';

import 'package:my_chat/model/user_profile.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class RegisterEvent extends AuthEvent {
  final UserProfile profile;
  final File? profileImage;

  RegisterEvent(this.profile, this.profileImage);
}

class SelectImage extends AuthEvent {
  final File imageFile;
  SelectImage(this.imageFile);
}
