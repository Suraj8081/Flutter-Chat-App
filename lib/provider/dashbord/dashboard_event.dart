import 'dart:io';

import 'package:my_chat/model/user_profile.dart';

abstract class DashboardEvent {}

class GetChatUserEvent extends DashboardEvent {}

class ProfileUpdateEvent extends DashboardEvent {
  UserProfile userProfile;
  File? selectedFile;

  ProfileUpdateEvent(this.userProfile, this.selectedFile);
}

class LogoutUserEvent extends DashboardEvent {}
