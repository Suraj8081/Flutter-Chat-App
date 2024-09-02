import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/firebase_operations.dart';
import 'package:my_chat/helper/local_repo.dart';
import 'package:my_chat/model/user_profile.dart';
import 'package:my_chat/provider/dashbord/dashboard_event.dart';
import 'package:my_chat/provider/dashbord/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FireOperations fireOperations = FireOperations();

  DashboardBloc() : super(InitialChatState()) {
    on<GetChatUserEvent>(_getUserList);
    on<ProfileUpdateEvent>(_userUpdate);
    on<LogoutUserEvent>(_logoutUser);
  }

  void _getUserList(
      GetChatUserEvent event, Emitter<DashboardState> emitter) async {
    emitter(LoadingState(isLoading: true));
    List<UserProfile> list = await fireOperations.getAllUser();
    emitter(LoadingState(isLoading: false));
    emitter(FetchedUserChatState(list));
  }

  void _userUpdate(
      ProfileUpdateEvent event, Emitter<DashboardState> emitter) async {
    emitter(LoadingState(isLoading: true));

    try {
      String imageUrl = '';
      //upload Profile
      if (event.selectedFile != null) {
        imageUrl = await fireOperations.uploadImage(
          Collections.USERS_IMAGE.name,
          event.userProfile.id!,
          event.selectedFile!,
        );
        dev.log('$imageUrl', name: 'Upadte Profile');
      }
      final UserProfile profile = event.userProfile.copyWith(
        profileimage: imageUrl,
      );

      await fireOperations.updateProfileUser(profile);

      //save Data
      await LocalRepo().setProfileData(profile);

      emitter(ProfileUpdatedState());
    } catch (error) {
      emitter(ProfileUpdatedErrorState(error.toString()));
    }
  }

  void _logoutUser(
      LogoutUserEvent event, Emitter<DashboardState> emitter) async {
      //save Data
    await LocalRepo().clearProfileData();
    fireOperations.logout();

    emitter(LoggedOutState());
  }
}
