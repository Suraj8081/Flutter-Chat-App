import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_chat/screen/auth_screen.dart';
import 'package:my_chat/helper/utils.dart';

class SplasScreen extends StatefulWidget {
  const SplasScreen({super.key});

  @override
  State<SplasScreen> createState() => _SplasScreenState();
}

class _SplasScreenState extends State<SplasScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      moveTo(context, const AuthScreen(), clearRoute: true);
    });
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
