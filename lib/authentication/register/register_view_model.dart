import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/register/register_request_model.dart';
import 'package:kasagardem/authentication/social_sign_in_mixin.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

class RegisterViewModel extends GetxController with SocialSignInMixin {
  RxBool isPasswordObscure = true.obs;
  RxBool isUserAgreedToTerms = false.obs;
  RxBool isShowLoader = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late final FocusNode otpFocusNode;

  final formKey = GlobalKey<FormState>();
  final verifyOtpFormKey = GlobalKey<FormState>();

  Timer? resendTimer;
  Timer? expiryTimer;
  RxInt resendCountdown = 60.obs;
  RxBool canResendOtp = false.obs;
  RxInt otpExpiryCountdown = 300.obs;

  RxString selectedQuestion = "".obs;

  @override
  void onInit() {
    otpFocusNode = FocusNode();
    super.onInit();
  }

  String get formattedPhoneNumber {
    final phone = phoneNoController.text.trim().replaceAll(' ', '');
    if (phone.startsWith('+91')) return phone;
    if (phone.startsWith('91')) return '+$phone';
    return '+91$phone';
  }

  void startResendTimer() {
    resendTimer?.cancel();
    canResendOtp.value = false;
    resendCountdown.value = 60;
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value <= 1) {
        canResendOtp.value = true;
        timer.cancel();
      } else {
        resendCountdown.value--;
      }
    });
  }

  void startOtpExpiryTimer() {
    expiryTimer?.cancel();
    otpExpiryCountdown.value = 300;
    expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpExpiryCountdown.value <= 0) {
        timer.cancel();
      } else {
        otpExpiryCountdown.value--;
      }
    });
  }

  Future<void> registerUser() async {
    await _submitRegistration();
  }

  /// Resend email OTP after registration.
  Future<void> sendRegisterOtp({bool isResend = false}) async {
    resendTimer?.cancel();
    final email = emailController.text.trim();
    if (email.isEmpty) {
      BaseSnackBar.show(
        title: AppLocalizations.of(Get.context!)!.error,
        message: AppLocalizations.of(Get.context!)!.pleaseEnterValidEmailId,
      );
      return;
    }

    final response = await authRepository.resedOtp(email: email);
    if (response != null) {
      pinController.clear();
      startResendTimer();
      startOtpExpiryTimer();
      _showApiMessage(
        response,
        fallbackMessage: isResend
            ? AppLocalizations.of(Get.context!)!.codeSentSuccessfully
            : null,
      );
    }
  }

  /// Verify email OTP after the register API has succeeded.
  Future<void> verifyRegisterOtp() async {
    final response = await authRepository.verifyOtpOnRegister(
      email: emailController.text.trim(),
      otp: pinController.text.trim(),
    );
    if (response != null) {
      _saveRegisterSession(response);
      registerSuccessDialog();
    }
  }

  void _showApiMessage(dynamic response, {String? fallbackMessage}) {
    final apiMessage = response is Map
        ? response[ApiKeys.message]?.toString().trim()
        : null;
    final message = (apiMessage != null && apiMessage.isNotEmpty)
        ? apiMessage
        : fallbackMessage;
    if (message == null || message.isEmpty) return;

    BaseSnackBar.show(
      title: AppLocalizations.of(Get.context!)!.success,
      message: message,
    );
  }

  void _saveRegisterSession(dynamic response) {
    final data = response[ApiKeys.data];
    if (data == null) return;

    SharedPrefsService.instance.setString(
      AppKeys.idToken,
      data[ApiKeys.token] ?? '',
    );
    SharedPrefsService.instance.setString(
      ApiKeys.refreshToken,
      data[ApiKeys.refreshToken] ?? '',
    );
    SharedPrefsService.instance.setString(AppKeys.role, AppKeys.user);
    SharedPrefsService.instance.setString(AppKeys.name, nameController.text.trim());
    SharedPrefsService.instance.setString(AppKeys.email, emailController.text.trim());
    SharedPrefsService.instance.setBool(AppKeys.emailLogedInUser, true);

    String responseId = '';
    if (data is Map && data.containsKey(ApiKeys.responseId)) {
      responseId = data[ApiKeys.responseId] ?? '';
    }
    SharedPrefsService.instance.setString(AppKeys.submissionResponseId, responseId);
    SharedPrefsService.instance.setBool(AppKeys.isSoftLoggedIn, true);
  }

  /// Create account first, then open email OTP verification.
  Future<void> _submitRegistration() async {
    isShowLoader.value = true;
    final requestModel = RegisterRequestModel()
      ..email = emailController.text.trim()
      ..name = nameController.text.trim()
      ..password = passwordController.text
      ..roleCode = userRoleCode
      ..phoneNumber = formattedPhoneNumber;

    final registerResponse = await authRepository.registerUser(registerReq: requestModel);
    isShowLoader.value = false;
    if (registerResponse != null) {
      pinController.clear();
      startResendTimer();
      startOtpExpiryTimer();
      Get.toNamed(Routes.registerVerifyOtp);
      _showApiMessage(registerResponse);
    }
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    expiryTimer?.cancel();
    otpFocusNode.dispose();
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    phoneNoController.dispose();
    pinController.dispose();
    scrollController.dispose();
  }

  void registerSuccessDialog() {
    return BaseDialog.showFullScreenDialog(
      Get.context!,
      dialogTitle: AppLocalizations.of(Get.context!)!.success,
      dialogDescription: AppLocalizations.of(Get.context!)!.yourAccountHasBeenCreated,
      buttonLabel: AppLocalizations.of(Get.context!)!.continueText,
      onButtonPressed: () {
        Get.offAllNamed(Routes.question);
      },
    );
  }

  void onCheckTermsAndCondition() {
    isUserAgreedToTerms.value = !isUserAgreedToTerms.value;
  }
}
