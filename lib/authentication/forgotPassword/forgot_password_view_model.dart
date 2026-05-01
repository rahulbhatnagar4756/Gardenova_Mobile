import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/auth_repository.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/routes.dart';

import '../../utils/utils.dart';

class ForgotPasswordViewModel extends GetxController {
  RxBool isShowLoader = false.obs;
  RxBool isNewPasswordObscure = true.obs;
  RxBool isPasswordObscure = true.obs;
  RxBool isConfirmPasswordObscure = true.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  late final FocusNode focusNode;
  late final GlobalKey<FormState> sendOtpFormKey;
  late final GlobalKey<FormState> verifyOtpFormKey;
  AuthRepository authRepository = AuthRepository();
  Timer? timer;
  RxInt start = 300.obs;
  RxBool canResend = false.obs;

  void startTimer() {
    canResend.value = false;
    start.value = 300;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (start.value == 1) {
        canResend.value = true;
        timer.cancel();
      } else {
        start--;
      }
    });
  }

  @override
  void onInit() {
    sendOtpFormKey = GlobalKey<FormState>();
    verifyOtpFormKey = GlobalKey<FormState>();
    focusNode = FocusNode();
    super.onInit();
  }

  Future<void> sendOtp({bool? isResend = false}) async {
    timer?.cancel();
    isShowLoader.value = true;
    var registerResponse = await authRepository.sendPasswordResetCode(
      email: emailController.text,
      isResend: isResend ?? false,
    );
    isShowLoader.value = false;
    if (registerResponse != null) {
      if (isResend!) {
        pinController.clear();
        BaseSnackBar.show(
          title: AppLocalizations.of(Get.context!)!.success,
          message: AppLocalizations.of(Get.context!)!.codeSentSuccessfully,
        );
      } else {
        pinController.clear();
        Get.toNamed(Routes.verifyOtp);
      }
      startTimer();
    }
  }

  Future<void> verifyOtp() async {
    isShowLoader.value = true;
    var verifyOtpResponse = await authRepository.verifyOtp(
      email: emailController.text,
      otp: pinController.text,
    );
    isShowLoader.value = false;
    if (verifyOtpResponse != null) {
      newPasswordController.clear();
      confirmPasswordController.clear();

      Get.offAndToNamed(Routes.resetPassword);
    }
  }

  Future<void> resetPassword() async {
    isShowLoader.value = true;
    var resetPasswordResponse = await authRepository.resetPassword(
      email: emailController.text,
      password: newPasswordController.text,
      otp: pinController.text,
    );

    isShowLoader.value = false;
    if (resetPasswordResponse != null) {
      BaseDialog.showFullScreenDialog(
        barrieDismissible: false,
        Get.context!,
        buttonLabel: AppLocalizations.of(
          Get.context!,
        )!.backToLogin.toUpperCase(),
        dialogTitle: AppLocalizations.of(Get.context!)!.passwordChanged,
        dialogDescription: AppLocalizations.of(
          Get.context!,
        )!.passwordChangedSuccessfully,
        onButtonPressed: () {
          Get.back();
          Get.offAllNamed(Routes.login);
        },
      );
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    focusNode.dispose();
    super.dispose();
  }

}
