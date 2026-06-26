import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/login/profile_response_model.dart';
import 'package:kasagardem/authentication/social_sign_in_mixin.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/services/reminder_push_notification_service.dart';
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

import '../../base/widgets/base_calculate_remaining_days.dart';
import '../../settings/profile/verified_email_otp_view/verified_email_local_parsing_model.dart';
import '../../utils/constants/app_constants.dart';

class LoginViewModel extends GetxController with SocialSignInMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final verifyOtpFormKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  late final FocusNode otpFocusNode;
  RxBool isPasswordObscure = true.obs;
  RxBool isMobileOtpLoginMode = false.obs;
  RxBool isQuestionStatePassed = true.obs;
  RxString accountType = "".obs;
  RxInt remainingDays = 0.obs;
  Timer? resendTimer;
  Timer? expiryTimer;
  RxInt resendCountdown = 60.obs;
  RxBool canResendOtp = false.obs;
  RxInt otpExpiryCountdown = 300.obs;

  @override
  onInit() {
    super.onInit();
    otpFocusNode = FocusNode();
    accountType.value = SharedPrefsService.instance.getString(AppKeys.role) ?? "";
    debugPrint("accountType ${accountType.value}");
    bool questionStatePassed = false;
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;

      if (args.containsKey('question_state_passed')) {
        questionStatePassed = args['question_state_passed'] ?? false;

        debugPrint("questionStatePassed $questionStatePassed");
      }
    }
    isQuestionStatePassed.value = questionStatePassed;

    googleSignIn.initialize(
      serverClientId: dotenv.env['webClientId']!,
      clientId: Platform.isIOS ? dotenv.env['iosClientId']! : dotenv.env['androidClientId']!,
    );
    // need change
    if (kDebugMode) {
      emailController.text = 'ashirwad11@yopmail.com';
      passwordController.text = 'Test@123';
    }
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    expiryTimer?.cancel();
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    pinController.dispose();
    otpFocusNode.dispose();
    scrollController.dispose();
  }

  void toggleLoginMode() {
    isMobileOtpLoginMode.value = !isMobileOtpLoginMode.value;
    passwordController.clear();
    pinController.clear();
  }

  String get formattedPhoneNumber {
    final phone = phoneController.text.trim().replaceAll(' ', '');
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

  Future<void> sendLoginOtp({bool isResend = false}) async {
    resendTimer?.cancel();
    final response = await authRepository.sendLoginOtp(phoneNumber: formattedPhoneNumber);
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
        Get.toNamed(Routes.loginVerifyOtp);
      }
    }
  }

  Future<void> verifyLoginOtp() async {
    final response = await authRepository.verifyLoginOtp(
      phoneNumber: formattedPhoneNumber,
      otp: pinController.text.trim(),
      reqType: 'login',
    );
    print(
      'verifyLoginOtp response $response',

    );
    if (response != null) {
      final data = response[ApiKeys.data] ?? {};
      final isNewUser = data[ApiKeys.isNewUser] == true;

      SharedPrefsService.instance.setString(
        AppKeys.idToken,
        data[ApiKeys.token],
      );
      String responseId = data[ApiKeys.responseId]?.toString() ?? '';
      SharedPrefsService.instance.setString(AppKeys.submissionResponseId, responseId);
      SharedPrefsService.instance.setString(AppKeys.role, accountType.value);

      if (isNewUser) {
        _openEditProfileForNewOtpUser(responseId: responseId);
        return;
      }

      if (accountType.value == AppKeys.professional) {
        getProfessionalProfileDetail();
      } else {
        getProfileDetail(responseId: responseId);
      }
    }
  }

  void _openEditProfileForNewOtpUser({required String responseId}) {
    SharedPrefsService.instance.setBool(AppKeys.emailLogedInUser, false);
    final phone = formattedPhoneNumber.startsWith('+91')
        ? formattedPhoneNumber.substring(3)
        : formattedPhoneNumber.replaceAll(RegExp(r'\D'), '');

    Get.offAllNamed(
      Routes.editProfile,
      arguments: {
        AppKeys.isNewUserOtpLogin: true,
        ApiKeys.phoneNumber: phone,
        ApiKeys.responseId: responseId,
      },
    );
  }

  Future<void> login() async {
    log('userType accountType.value ${accountType.value}');
    var loginResponse = await authRepository.loginUser(
      loginReq: {
        ApiKeys.email: emailController.text.toString().trim(),
        ApiKeys.password: passwordController.text.toString().trim(),
        "loginType": accountType.value.isNotEmpty ? accountType.value : "user",
      },
    );
    if (loginResponse != null) {
      // SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
      SharedPrefsService.instance.setString(
        AppKeys.idToken,
        loginResponse[ApiKeys.data][ApiKeys.token],
      );
      String responseId = '';
      if (loginResponse.containsKey(ApiKeys.data) &&
          loginResponse[ApiKeys.data].containsKey(ApiKeys.responseId)) {
        responseId = loginResponse[ApiKeys.data][ApiKeys.responseId] ?? "";
      }
      SharedPrefsService.instance.setString(AppKeys.submissionResponseId, responseId);
      SharedPrefsService.instance.setString(AppKeys.role, accountType.value);

      if (accountType.value == AppKeys.professional) {
        getProfessionalProfileDetail();
      } else {
        getProfileDetail();
      }
    }
  }

  Future<void> registerGoogleToken() async {
    log('google register google token-> $googleAuthToken');
    var loginResponse = await authRepository.registerGoogleToken(
      socialLoginReq: {ApiKeys.googleAccessToken: googleAuthToken, ApiKeys.roleCode: "U"},
    );
    if (loginResponse != null) {
      // SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
      SharedPrefsService.instance.setString(
        AppKeys.idToken,
        loginResponse[ApiKeys.data][ApiKeys.token],
      );
      getProfileDetail();
    }
  }

  Future<void> registerFacebookToken() async {
    var loginResponse = await authRepository.registerFacebookToken(
      socialLoginReq: {ApiKeys.facebookAccessToken: facebookAuthToken, ApiKeys.roleCode: "U"},
    );
    if (loginResponse != null) {
      // SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
      SharedPrefsService.instance.setString(
        AppKeys.idToken,
        loginResponse[ApiKeys.data][ApiKeys.token],
      );
      getProfileDetail();
    }
  }

  Future<void> registerAppleToken() async {
    var loginResponse = await authRepository.registerAppleToken(
      socialLoginReq: {
        ApiKeys.firstName: appleCredential?.givenName,
        ApiKeys.lastName: appleCredential?.familyName,
        ApiKeys.email: appleCredential?.email,
        ApiKeys.appleIdToken: appleCredential?.identityToken,
        ApiKeys.roleCode: "U",
      },
    );
    if (loginResponse != null) {
      // SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
      SharedPrefsService.instance.setString(
        AppKeys.idToken,
        loginResponse[ApiKeys.data][ApiKeys.token],
      );
      getProfileDetail();
    }
  }

  void getProfileDetail({String responseId = ''}) async {
    var response = await authRepository.fetchProfile();
    if (response != null) {
      ProfileResponseModel profileResponse = ProfileResponseModel.fromJson(response);

      debugPrint("response :::::${profileResponse.data?.name}");
      SharedPrefsService.instance.setString(AppKeys.name, profileResponse.data?.name ?? "");
      SharedPrefsService.instance.setString(AppKeys.email, profileResponse.data?.email ?? "");
      bool isSocialLoginUser = profileResponse.data?.isSsoUser ?? false;
      SharedPrefsService.instance.setBool(AppKeys.emailLogedInUser, !isSocialLoginUser);
      if (profileResponse.data?.profileImage != null) {
        SharedPrefsService.instance.setString(
          AppKeys.profileImage,
          profileResponse.data!.profileImage!,
        );
      }
      String responseIdd = profileResponse.data?.responseId ?? responseId;
      bool isUserEmailVerifed = profileResponse.data?.isEmailVerified ?? false;
      log('isUserEmail verified $isUserEmailVerifed');
      // if (!isUserEmailVerifed && false) {
      //   sendEmailVerification(responseIdd: responseIdd);
      // } else {
      _navigateToDashboardFlow(responseIdd: responseIdd);
      // }
    }
  }

  void _navigateToDashboardFlow({required String responseIdd}) {
    if (responseIdd.trim().isEmpty) {
      SharedPrefsService.instance.setBool(AppKeys.isSoftLoggedIn, true);
      Get.offAllNamed(Routes.question);
    } else {
      SharedPrefsService.instance.setString(AppKeys.submissionResponseId, responseIdd);
      SharedPrefsService.instance.setBool(AppKeys.isSoftLoggedIn, false);
      SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
      ReminderPushNotificationService.instance.registerDeviceTokenIfNeeded();
      Get.offAllNamed(Routes.dashboard);
    }
  }

  Future<void> sendEmailVerification({required String responseIdd}) async {
    final String mail = emailController.text.trim();
    if (mail.isEmpty || !GetUtils.isEmail(mail)) {
      BaseSnackBar.show(title: "Error", message: "Please enter a valid email address.");
      return;
    }

    final response = await authRepository.sentEmailVerification(mail);
    if (response != null) {
      var parsingModel = VerifiedEmailLocalParsingModel(
        email: emailController.text.trim(),
        fromLoginFlow: true,
        userType: 'user',
      );
      Get.toNamed(Routes.verifyEmailOtp, arguments: parsingModel)?.then((value) {
        if (value is VerifiedEmailLocalParsingModel) {
          if (value.requestSussessFull) {
            _navigateToDashboardFlow(responseIdd: responseIdd);
          }
        }
      });
    } else {
      BaseSnackBar.show(title: "Error", message: "Could not connect to verification service.");
    }
  }

  void getProfessionalProfileDetail() async {
    var response = await authRepository.fetchProfessionalProfile();
    if (response != null) {
      debugPrint("response $response");
      final data = response['data'];
      ProfileResponseModel profileResponse = ProfileResponseModel.fromJson(response);
      SharedPrefsService.instance.setString(AppKeys.name, profileResponse.data?.name ?? "");
      SharedPrefsService.instance.setString(AppKeys.email, profileResponse.data?.email ?? "");
      SharedPrefsService.instance.setString(
        AppKeys.accountStatus,
        data[AppKeys.accountStatus] ?? "",
      );
      SharedPrefsService.instance.setString(AppKeys.createdAt, data["startDate"] ?? "");

      BaseCalculateRemainingDays().calculateRemainingDays(data["startDate"] ?? "");

      if (profileResponse.data?.profileImage != null) {
        SharedPrefsService.instance.setString(
          AppKeys.profileImage,
          profileResponse.data!.profileImage!,
        );
      }
      Get.offAllNamed(Routes.professionalDashboard);
      /*  Get.offAllNamed(
        Routes.upgradePlan,
        arguments: {AppKeys.screenType: AppKeys.login},
      );*/
    }
  }
}
