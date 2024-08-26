class Validator {
  static bool isStringNOE(String? text) {
    return text == null || text.isEmpty;
  }

  static bool isEmailValid(String email) {
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailRegExp.hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return password.length >= 6;
  }

  static String? validateValue(String? text,
      {bool forEmail = false, bool forPass = false}) {
    if (isStringNOE(text)) {
      return 'This Field is Required';
    }
    if (forEmail && !isEmailValid(text!)) {
      return 'Incorrect Email ID';
    }
    if (forPass && text!.length<6) {
      return 'Password length must be 6';
    }
    return null;
  }
}
