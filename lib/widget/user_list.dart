import 'package:flutter/material.dart';
import 'package:my_chat/model/user_profile.dart';

class UserList extends StatelessWidget {
  const UserList({super.key, required this.userProfile});

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 40,
        backgroundImage: userProfile.profileimage != null
            ? NetworkImage(userProfile.profileimage!)
            : const NetworkImage('url'),
      ),
      title: Text(
        userProfile.name!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        userProfile.emailId!,
      ),
      minVerticalPadding: 20,
      horizontalTitleGap: 5,
    );
  }
}
