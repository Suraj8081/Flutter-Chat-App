import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/helper/local_repo.dart';
import 'package:my_chat/helper/validator.dart';
import 'package:my_chat/model/user_profile.dart';
import 'package:my_chat/provider/dashbord/dashboard_bloc.dart';
import 'package:my_chat/provider/dashbord/dashboard_event.dart';
import 'package:my_chat/provider/dashbord/dashboard_state.dart';
import 'package:my_chat/screen/auth_screen.dart';
import 'package:my_chat/widget/input_form_field.dart';
import 'package:my_chat/widget/my_eleveted_button.dart';
import 'package:my_chat/helper/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final GlobalKey<FormState> _formkey;
  File? _selectedFile;
  late final DashboardBloc _dashboardBloc;
  String name = '';
  String email = '';
  String password = '';
  UserProfile? userProfile;

  void _signUp(UserProfile userProfile) {
    final bool isValidate = _formkey.currentState!.validate();

    if (isValidate) {
      _formkey.currentState!.save();
      UserProfile updateProfile = userProfile.copyWith(
        name: name,
        emailId: email,
        password: password,
      );

      _dashboardBloc.add(ProfileUpdateEvent(updateProfile, _selectedFile));
    }
  }

  void _logout() {
    _dashboardBloc.add(LogoutUserEvent());
  }

  @override
  void initState() {
    super.initState();
    _formkey = GlobalKey<FormState>();
    _dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    getUser();
  }

  void getUser() async {
    userProfile = await LocalRepo().getProfileData();
  }

  @override
  void dispose() {
    super.dispose();
    _formkey.currentState!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is ProfileUpdatedState) {
          showSnackBar(
            context,
            'User Profile Update Succesfully..',
            bgColor: Colors.green[700],
          );
        } else if (state is LoggedOutState) {
          showSnackBar(
            context,
            'Log Out Succesfully..',
            bgColor: Colors.green[700],
          );
          moveTo(context, const AuthScreen(), clearRoute: true);
        } else if (state is ProfileUpdatedErrorState) {
          showSnackBar(
            context,
            state.error,
            bgColor: Colors.red[700],
          );
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
            FutureBuilder(
              future: LocalRepo().getProfileData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  userProfile = snapshot.data;
                  return Column(
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
                            child: profileImageView(_selectedFile,
                                userProfile?.profileimage, context),
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
                                      'Profile',
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
                                      initialValue: userProfile?.name,
                                      prefixIcon:
                                          const Icon(Icons.person_2_outlined),
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
                                      isDisable: true,
                                      initialValue: userProfile?.emailId,
                                      prefixIcon:
                                          const Icon(Icons.email_outlined),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) =>
                                          Validator.validateValue(value,
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
                                      initialValue: userProfile?.password,
                                      keyboardType: TextInputType.text,
                                      prefixIcon: const Icon(Icons.password),
                                      isPassword: true,
                                      observerText: true,
                                      validator: (value) =>
                                          Validator.validateValue(value,
                                              forPass: true),
                                      onSaved: (value) {
                                        password = value!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    MyElevetedButton(
                                      onPressed: () {
                                        _signUp(userProfile!);
                                      },
                                      title: 'Update',
                                      isLoading: state is LoadingState
                                          ? state.isLoading
                                          : false,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 80, 10, 0),
                child: IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _logout,
                ),
              ),
            ),
          ],
        );
      },
    ));
  }
}

Widget profileImageView(
    File? selectedFile, String? imageUrl, BuildContext context) {
  return selectedFile == null
      ? (imageUrl == null || imageUrl == '')
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
              backgroundImage: NetworkImage(imageUrl),
            )
      : CircleAvatar(
          radius: 50,
          backgroundImage: FileImage(
            selectedFile,
          ),
        );
}

Widget themeChage() {
  return const Column(
    children: [],
  );
}
