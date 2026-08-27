import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class ValidationHelper {
  static final RegExp _nameRegex = RegExp(r'^[A-Za-z0-9]+(?: +[A-Za-z0-9]+)*$');

  /// =========================
  /// NAME VALIDATION
  /// Letters, numbers, and spaces only.
  /// =========================
  static String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty || name.length < 2 || !_nameRegex.hasMatch(name)) {
      return ErrorStrings.invalidName;
    }

    return null;
  }

  /// =========================
  /// EMAIL VALIDATION
  /// =========================
  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty ||
        email.startsWith('.') ||
        !RegExp(emailRegexPattern).hasMatch(email)) {
      return ErrorStrings.invalidEmail;
    }

    return null;
  }

  /// =========================
  /// PHONE VALIDATION
  /// =========================
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ErrorStrings.invalidPhoneNo;
    }
    if (value.length != 10) {
      return ErrorStrings.phoneNoMustBeAtleast7Digits;
    }

    // Remove spaces
    final phone = value.trim().replaceAll(' ', '');

    // Only digits allowed
    final phoneRegex = RegExp(r'^[0-9]{7,14}$');

    if (!phoneRegex.hasMatch(phone)) {
      return ErrorStrings.phoneNoMustBeAtleast7Digits;
    }

    return null;
  }

  /// =========================
  /// PASSWORD VALIDATION
  /// =========================
  static String? validatePassword(
    String? value, {
    bool requireMinLength = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return ErrorStrings.pwdFieldNotEmpty;
    }

    if (requireMinLength && value.length < 8) {
      return ErrorStrings.pwdMustBeAtLeadEightCharecter;
    }

    // At least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return ErrorStrings.pwdMustContainAtLeastOneCapitalLetter;
    }

    // At least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return ErrorStrings.pwdMustContainAtLeastOneSmallLetter;
    }

    // At least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return ErrorStrings.pwdMustContainAtLeastOneNumber;
    }

    // At least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return ErrorStrings.pwdMustContainAtLeastOneSpecialCharacter;
    }

    return null;
  }

  /// =========================
  /// CONFIRM PASSWORD VALIDATION
  /// =========================
  static String? validateConfirmPassword({
    required String? password,
    required String? confirmPassword,
  }) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return ErrorStrings.confirmNewPwdFieldNotEmpty;
    }

    if (password != confirmPassword) {
      return ErrorStrings.confirmPasswordsNotMatch;
    }

    return null;
  }
}
