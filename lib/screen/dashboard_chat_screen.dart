import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/helper/utils.dart';
import 'package:my_chat/provider/dashbord/dashboard_bloc.dart';
import 'package:my_chat/provider/dashbord/dashboard_event.dart';
import 'package:my_chat/provider/dashbord/dashboard_state.dart';
import 'package:my_chat/widget/loading.dart';
import 'package:my_chat/widget/user_list.dart';

class DashboardChatScreen extends StatefulWidget {
  const DashboardChatScreen({super.key});

  @override
  State<DashboardChatScreen> createState() => _DashboardChatScreenState();
}

class _DashboardChatScreenState extends State<DashboardChatScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DashboardBloc>(context).add(GetChatUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: getThemeColor(context).primary,
            title: Text(
              'Dashboard',
              style: TextStyle(
                  color: getThemeColor(context).onPrimary,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: state is FetchedUserChatState
              ? SingleChildScrollView(
                child: Column(
                    children: [
                      ...state.userList.map((user) => UserList(userProfile: user))
                    ],
                  ),
              )
              : const Loading(),
        );
      },
    );
  }
}
