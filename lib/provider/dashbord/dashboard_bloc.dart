import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/firebase_operations.dart';
import 'package:my_chat/helper/local_repo.dart';
import 'package:my_chat/model/user_profile.dart';
import 'package:my_chat/provider/dashbord/dashboard_event.dart';
import 'package:my_chat/provider/dashbord/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FirebaseOperations fireOperations = FirebaseOperations();

  DashboardBloc() : super(InitialDashboardState()) {
    on<GetChatUserEvent>(_getUserList);
    on<ProfileUpdateEvent>(_userUpdate);
    on<LogoutUserEvent>(_logoutUser);
  }

  void _getUserList(
      GetChatUserEvent event, Emitter<DashboardState> emitter) async {
    emitter(LoadingState(isLoading: true));
    List<UserProfile> list = await fireOperations.getAllUser();

    UserProfile? userProfile = await LocalRepo().getProfileData();
    if (userProfile != null) {
      List<UserProfile> filterList =
          list.where((user) => user.emailId != userProfile.emailId).toList();
      emitter(LoadingState(isLoading: false));
      emitter(FetchedUserChatState(filterList));
    }
  }

  void _userUpdate(
      ProfileUpdateEvent event, Emitter<DashboardState> emitter) async {
    emitter(LoadingState(isLoading: true));

    try {
      String imageUrl = '';
      //upload Profile
      if (event.selectedFile != null) {
        imageUrl = await fireOperations.uploadImage(
          Collections.usersImage.name,
          event.userProfile.id!,
          event.selectedFile!,
        );
        dev.log('$imageUrl', name: 'Upadte Profile');
      }
      final UserProfile profile = event.userProfile.copyWith(
        profileimage: imageUrl,
      );

      await fireOperations.updateUser(profile);

      //save Data
      await LocalRepo().setProfileData(profile);

      emitter(ProfileUpdatedState());
    } catch (error) {
      emitter(ProfileUpdatedErrorState(error.toString()));
    }
  }

  void _logoutUser(
      LogoutUserEvent event, Emitter<DashboardState> emitter) async {
    UserProfile? userProfile = await LocalRepo().getProfileData();
    if (userProfile != null) {
      await fireOperations.unsubscibeAllNode(userProfile.id!);
      //save Data
      await LocalRepo().clearProfileData();
      fireOperations.logout();

      emitter(LoggedOutState());
    }
  }
}
