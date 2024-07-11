import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_chat/screen/auth_screen.dart';
import 'package:my_chat/widget/input_form_field.dart';
import 'package:my_chat/widget/my_eleveted_button.dart';
import 'package:my_chat/widget/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final GlobalKey _formkey;
  File? _selectedFile;

  void _login() {
    moveTo(
      context,
      const AuthScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
    _formkey = GlobalKey();
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
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: InkWell(
                  onTap: () {
                    showImagePicker(
                      context,
                      (selectedFile) {
                        setState(() {
                          _selectedFile = selectedFile;
                        });
                      },
                    );
                  },
                  child: _selectedFile == null
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: getThemeColor(context).onPrimary,
                              shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              Icons.person_add_alt,
                              size: 60,
                              color: getThemeColor(context).primary,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(
                            _selectedFile!,
                          ),
                        ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                color: getThemeColor(context).onPrimary,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'SignUp',
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
                          title: 'Sign Up',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: _login,
                          child: const Text('I Already have an account'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
