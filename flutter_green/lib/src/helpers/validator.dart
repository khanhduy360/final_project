import 'package:validators/validators.dart' as validate;

class Validators {
  // Check email
  bool isValidEmail(String email) {
    return email != '' && validate.isEmail(email);
  }

  //check password
  bool isPassword(String password) {
    return password != null &&
        password != '' &&
        password.length >= 6 &&
        password.length <= 15;
  }

  //check phone number
  bool isPhoneNumber(String phone) {
    return phone != null && phone != '' && phone.length <= 11;
  }
}
