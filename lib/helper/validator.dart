const String emailRegex =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const passwordRegex =
    r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$";

class Validator {
  String checkEmail({String email}) {
    if (email.isEmpty) {
      return 'Required field';
    }
    if (!RegExp(emailRegex).hasMatch(email)) {
      return 'Enter a valid email!';
    }
    return null;
  }

  String checkPasswordStrength({String password}) {
    if (password.isEmpty) {
      return 'Required field';
    }
    if (!RegExp(passwordRegex).hasMatch(password)) {
      return 'Require 1 upper case, 1 lower case, 1 number and 8 characters';
    }
    return null;
  }

  String checkEmpty({String value}) {
    if (value.isEmpty) {
      return 'Required field';
    }
    return null;
  }
}
