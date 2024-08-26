import 'package:flutter/material.dart';
import 'package:my_chat/helper/validator.dart';
import 'package:my_chat/screen/signup_screen.dart';
import 'package:my_chat/widget/input_form_field.dart';
import 'package:my_chat/widget/my_eleveted_button.dart';
import 'package:my_chat/helper/utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final GlobalKey<FormState> _formkey;

  void _createAccount() {
    moveTo(
      context,
      const SignUpScreen(),
      clearRoute: true,
    );
  }

  void _submit() {
    _formkey.currentState!.validate();
  }

  @override
  void initState() {
    super.initState();
    _formkey = GlobalKey<FormState>();
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
                key: _formkey,
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
                    InputFormField(
                      lableText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        return Validator.validateValue(value, forEmail: true);
                      },
                      onSaved: (value) {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputFormField(
                      lableText: 'Password',
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(Icons.password),
                      isPassword: true,
                      observerText: true,
                      validator: (value) {
                        return Validator.validateValue(value, forPass: true);
                      },
                      onSaved: (value) {},
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    MyElevetedButton(
                      onPressed: _submit,
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
