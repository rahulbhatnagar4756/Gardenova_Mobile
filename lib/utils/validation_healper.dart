import 'package:kasagardem/utils/constants/app_strings.dart';

class ValidationHelper {
  /// =========================
  /// NAME VALIDATION
  /// =========================
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ErrorStrings.invalidName;
    }

    if (value.trim().length < 2) {
      return ErrorStrings.invalidName;
    }

    return null;
  }

  /// =========================
  /// EMAIL VALIDATION
  /// =========================
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ErrorStrings.invalidEmail;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
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
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ErrorStrings.pwdFieldNotEmpty;
    }

    // Minimum 8 characters
    if (value.length < 8) {
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
