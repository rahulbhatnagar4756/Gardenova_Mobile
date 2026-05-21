import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/login/professional_profile_model.dart';
import 'package:kasagardem/settings/settings_repository.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

import '../../../utils/constants/app_keys.dart';
import '../../../utils/shared_prefs_service.dart';
import 'verified_email_local_parsing_model.dart';

class VerifiedEmailOtpViewModel extends GetxController {
  Rxn<ProfessionalProfileModel> professionalProfileData = Rxn();
  SettingsRepository profileRepository = SettingsRepository();

  late final FocusNode focusNode;
  final GlobalKey<FormState> verifyEmailFormKey = GlobalKey<FormState>();
  TextEditingController pinController = TextEditingController();
  var parsingArgument = Rxn<VerifiedEmailLocalParsingModel>();
  RxInt countdownTimer = 0.obs;
  Timer? _timer;

  @override
  onInit() {
    focusNode = FocusNode();
    parsingArgument =
        Get.arguments ??
        VerifiedEmailLocalParsingModel(
          email: '',
          fromLoginFlow: true,
          userType: 'user',
        );

    final bool isSuccess = parsingArgument.value?.requestSussessFull ?? false;
    startTimer(isSuccess ? 60 : 300);
    super.onInit();
  }

  void startTimer(int seconds) {
    countdownTimer.value = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownTimer.value > 0) {
        countdownTimer.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();

    focusNode.dispose();
  }

  Future<void> reSendVerificationTime() async {
    final String mail = parsingArgument.value?.email ?? ''.trim();
    if (mail.isEmpty || !GetUtils.isEmail(mail)) {
      BaseSnackBar.show(
        title: "Error",
        message: "Please enter a valid email address.",
      );
      return;
    }

    ApiRepository.instance.showLoader();
    try {
      final response = await profileRepository.sentEmailVerification(mail);
      ApiRepository.instance.hideLoader();

      if (response != null) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (response.statusCode == 200) {
          BaseSnackBar.show(
            title: "Success",
            message: body['message'] ?? "Email is already verified.",
          );
          startTimer(60);
        } else if (response.statusCode == 201) {
          BaseSnackBar.show(
            title: "Verification Sent",
            message: body['message'] ?? "Verification OTP sent to your email.",
          );
          startTimer(60);
        } else {
          BaseSnackBar.show(
            title: "Error",
            message: body['message'] ?? "Failed to send verification email.",
          );
        }
      } else {
        BaseSnackBar.show(
          title: "Error",
          message: "Could not connect to verification service.",
        );
      }
    } catch (e) {
      ApiRepository.instance.hideLoader();
      debugPrint("sendEmailVerification exception: $e");
      BaseSnackBar.show(
        title: "Error",
        message: "An error occurred during verification process.",
      );
    }
  }

  Future<void> verifyEmailOtp(String otp) async {
    if (otp.length < 4) {
      BaseSnackBar.show(
        title: "Error",
        message: "Please enter a valid 4-digit OTP.",
      );
      return;
    }

    ApiRepository.instance.showLoader();
    try {
      final response = await profileRepository.verifyEmail(otp);
      ApiRepository.instance.hideLoader();

      if (response != null) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (response.statusCode == 200 || body['success'] == true) {
          final String? newToken = body['data'];
          if (newToken != null && newToken.isNotEmpty) {
            await SharedPrefsService.instance.setString(
              AppKeys.idToken,
              newToken,
            );
          }
          // isEmailVerified.value = true;
          // showVerifyButton.value = false;
          // originalEmail.value = emailController.text.trim();
          // otpController.clear();
          parsingArgument.value?.requestSussessFull = true;
          Get.back(result: parsingArgument);
          BaseSnackBar.show(
            title: "Success",
            message: body['message'] ?? "Email verified successfully.",
          );
        } else {
          BaseSnackBar.show(
            title: "Error",
            message: body['message'] ?? "Invalid OTP code. Please try again.",
          );
        }
      } else {
        BaseSnackBar.show(
          title: "Error",
          message: "Failed to verify OTP. Please try again.",
        );
      }
    } catch (e) {
      ApiRepository.instance.hideLoader();
      debugPrint("verifyEmailOtp exception: $e");
      BaseSnackBar.show(
        title: "Error",
        message: "An error occurred while verifying the code.",
      );
    }
  }
}
