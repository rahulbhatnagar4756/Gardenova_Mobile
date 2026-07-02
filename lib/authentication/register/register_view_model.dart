import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/register/register_request_model.dart';
import 'package:kasagardem/authentication/social_sign_in_mixin.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/routes.dart';

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
    await sendRegisterOtp();
  }

  Future<void> sendRegisterOtp({bool isResend = false}) async {
    resendTimer?.cancel();
    final response = await authRepository.sendOtp(email: emailController.text.trim());
    if (response != null) {
      pinController.clear();
      startResendTimer();
      startOtpExpiryTimer();
      if (isResend) {
        BaseSnackBar.show(
          title: AppLocalizations.of(Get.context!)!.success,
          message: AppLocalizations.of(Get.context!)!.codeSentSuccessfully,
        );
      } else {
        Get.toNamed(Routes.registerVerifyOtp);
      }
    }
  }

  Future<void> verifyRegisterOtp() async {
    final response = await authRepository.verifyOtp(
      email: emailController.text.trim(),
      otp: pinController.text.trim(),
    );
    if (response != null) {
      await _submitRegistration();
    }
  }

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
      Get.back();
      registerSuccessDialog();
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
      buttonLabel: AppLocalizations.of(Get.context!)!.backToLogin,
      onButtonPressed: () {
        Navigator.pushNamedAndRemoveUntil(
          Get.context!,
          Routes.login,
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  void onCheckTermsAndCondition() {
    isUserAgreedToTerms.value = !isUserAgreedToTerms.value;
  }
}
