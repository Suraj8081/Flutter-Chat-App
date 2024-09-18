import 'package:my_chat/model/user_profile.dart';

abstract class DashboardState {}

class InitialDashboardState extends DashboardState {}

class LoadingState extends DashboardState {
  bool isLoading;
  LoadingState({this.isLoading = false});
}

class FetchedUserChatState extends DashboardState {
  final List<UserProfile> userList;

  FetchedUserChatState(this.userList);
}


class ProfileUpdatedState extends DashboardState {}

class ProfileUpdatedErrorState extends DashboardState {
  String error;
  ProfileUpdatedErrorState(this.error);
}


class LoggedOutState extends DashboardState {}