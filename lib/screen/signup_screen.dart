import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/helper/validator.dart';
import 'package:my_chat/model/user_profile.dart';
import 'package:my_chat/provider/auth/auth_bloc.dart';
import 'package:my_chat/provider/auth/auth_event.dart';
import 'package:my_chat/provider/auth/auth_state.dart';
import 'package:my_chat/screen/auth_screen.dart';
import 'package:my_chat/screen/dashbord_screen.dart';
import 'package:my_chat/widget/input_form_field.dart';
import 'package:my_chat/widget/my_eleveted_button.dart';
import 'package:my_chat/helper/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final GlobalKey<FormState> _formkey;
  File? _selectedFile;
  late final AuthBloc _authBloc;
  String name = '';
  String email = '';
  String password = '';

  void _login() {
    moveTo(context, const AuthScreen(), clearRoute: true);
  }

  void _signUp() {
    final bool isValidate = _formkey.currentState!.validate();

    if (isValidate) {
      _formkey.currentState!.save();
      final profile = UserProfile(
        name: name,
        emailId: email,
        password: password,
        createdDate: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      _authBloc.add(RegisterEvent(profile, _selectedFile));
    }
  }

  @override
  void initState() {
    super.initState();
    _formkey = GlobalKey<FormState>();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _formkey.currentState!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthSate>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          showSnackBar(context, state.error);
        } else if (state is RegiseredState) {
          _formkey.currentState!.reset();
          moveTo(context, const DashbordScreen(), clearRoute: true);
          showSnackBar(context, 'User Register Succesfully..',
              bgColor: Colors.green[700]);
        }
      },
      builder: (context, state) {
        return Stack(
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
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
                              InputFormField(
                                lableText: 'Name',
                                prefixIcon: const Icon(Icons.person_2_outlined),
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                    Validator.validateValue(value),
                                onSaved: (value) {
                                  name = value!;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InputFormField(
                                lableText: 'Email',
                                prefixIcon: const Icon(Icons.email_outlined),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => Validator.validateValue(
                                    value,
                                    forEmail: true),
                                onSaved: (value) {
                                  email = value!;
                                },
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
                                validator: (value) => Validator.validateValue(
                                    value,
                                    forPass: true),
                                onSaved: (value) {
                                  password = value!;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              MyElevetedButton(
                                onPressed: _signUp,
                                title: 'Sign Up',
                                isLoading: state is LoadingState
                                    ? state.isLoading
                                    : false,
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
                ),
              ],
            ),
          ],
        );
      },
    ));
  }
}
