import 'package:flutter/material.dart';
import 'package:my_chat/screen/signup_screen.dart';
import 'package:my_chat/widget/input_form_field.dart';
import 'package:my_chat/widget/my_eleveted_button.dart';
import 'package:my_chat/widget/utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final GlobalKey formkey;

  void _createAccount() {
    moveTo(context, const SignUpScreen());
  }

  @override
  void initState() {
    super.initState();
    formkey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          color: getThemeColor(context).primary,
          height: double.infinity,
          width: double.infinity,
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 1.5,
          right: 0,
          left: 0,
          child: Icon(
            Icons.chat_rounded,
            color: getThemeColor(context).onPrimary,
            size: 150,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          height: MediaQuery.of(context).size.height / 1.6,
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            color: getThemeColor(context).onPrimary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: getThemeColor(context).primary,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const InputFormField(
                      lableText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const InputFormField(
                      lableText: 'Password',
                      keyboardType: TextInputType.text,
                      prefixIcon: Icon(Icons.password),
                      isPassword: true,
                      observerText: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    MyElevetedButton(
                      onPressed: () {},
                      title: 'Login',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: _createAccount,
                      child: const Text('Create an account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
