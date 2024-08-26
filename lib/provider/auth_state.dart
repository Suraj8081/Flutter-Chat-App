import 'dart:io';

abstract class AuthSate {}

class AuthInitialState extends AuthSate {}

class LoadingState extends AuthSate {
  final bool isLoading;
  LoadingState({this.isLoading = false});
}

class LoggedState extends AuthSate {}

class RegiseredState extends AuthSate {}

class AuthErrorState extends AuthSate {
  final String error;
  AuthErrorState(this.error);
}

class SelectedImage extends AuthSate {
  final File imageFile;
  SelectedImage(this.imageFile);
}
