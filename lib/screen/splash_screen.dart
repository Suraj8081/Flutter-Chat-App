import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_chat/helper/local_repo.dart';
import 'package:my_chat/screen/auth_screen.dart';
import 'package:my_chat/helper/utils.dart';
import 'package:my_chat/screen/dashbord_screen.dart';

class SplasScreen extends StatefulWidget {
  const SplasScreen({super.key});

  @override
  State<SplasScreen> createState() => _SplasScreenState();
}

class _SplasScreenState extends State<SplasScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalRepo().getProfileData(),
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Timer(const Duration(seconds: 3), () async {
            if (snapshot.hasData && null != snapshot.data) {
              // moveTo(context, const DashbordScreen(), clearRoute: true);
              moveTo(context, const AuthScreen(), clearRoute: true);
            } else {
              moveTo(context, const AuthScreen(), clearRoute: true);
            }
          });
        }
        return Scaffold(
          body: Container(
            color: getThemeColor(context).primary,
            child: const Center(
              child: Icon(
                Icons.chat_rounded,
                size: 200,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
