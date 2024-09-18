import 'dart:convert';

import 'package:my_chat/helper/validator.dart';
import 'package:my_chat/model/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class LocalRepo {
  static const String PROFILE_DATA = "profile_data";
  static const String FCM_TOKEN = "fcm_token";

  Future<void> setProfileData(UserProfile profile) async {
    _prefs.then((value) {
      value.setString(PROFILE_DATA, jsonEncode(profile));
    });
  }

  Future<void> clearProfileData() async {
    _prefs.then((value) {
      value.setString(PROFILE_DATA, '');
    });
  }

  Future<void> setFCMToken(String? token) async {
    _prefs.then((value) {
      value.setString(FCM_TOKEN, token ?? '');
    });
  }

  Future<String?> getFCMToken(String? token) async {
    _prefs.then((value) {
      return value.getString(FCM_TOKEN);
    });
    return null;
  }

  Future<UserProfile?> getProfileData() async {
    return _prefs.then((value) {
      var stringValue = value.getString(PROFILE_DATA);
      if (!Validator.isStringNOE(stringValue)) {
        var decoded = jsonDecode(stringValue!);
        var signInData = UserProfile.fromJson(decoded);
        return signInData;
      } else {
        return null;
      }
    });
  }
}
