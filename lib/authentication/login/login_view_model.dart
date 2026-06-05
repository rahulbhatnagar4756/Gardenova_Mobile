import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/login/profile_response_model.dart';
import 'package:kasagardem/authentication/social_sign_in_mixin.dart';
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
  final formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  RxBool isPasswordObscure = true.obs;
  RxBool isQuestionStatePassed = true.obs;
  RxString accountType = "".obs;
  RxInt remainingDays = 0.obs;

  @override
  onInit() {
    super.onInit();
    accountType.value =
        SharedPrefsService.instance.getString(AppKeys.role) ?? "";
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
      clientId: Platform.isIOS
          ? dotenv.env['iosClientId']!
          : dotenv.env['androidClientId']!,
    );
    // need change
    if (kDebugMode) {
      emailController.text = 'ashirwad11@yopmail.com';
      passwordController.text = 'Test@123';
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    scrollController.dispose();
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
      SharedPrefsService.instance.setString(
        AppKeys.submissionResponseId,
        responseId,
      );
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
      socialLoginReq: {
        ApiKeys.googleAccessToken: googleAuthToken,
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

  Future<void> registerFacebookToken() async {
    var loginResponse = await authRepository.registerFacebookToken(
      socialLoginReq: {
        ApiKeys.facebookAccessToken: facebookAuthToken,
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
      ProfileResponseModel profileResponse = ProfileResponseModel.fromJson(
        response,
      );

      debugPrint("response :::::${profileResponse.data?.name}");
      SharedPrefsService.instance.setString(
        AppKeys.name,
        profileResponse.data?.name ?? "",
      );
      SharedPrefsService.instance.setString(
        AppKeys.email,
        profileResponse.data?.email ?? "",
      );
      bool isSocialLoginUser = profileResponse.data?.isSsoUser ?? false;
      SharedPrefsService.instance.setBool(
        AppKeys.emailLogedInUser,
        !isSocialLoginUser,
      );
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
      SharedPrefsService.instance.setString(
        AppKeys.submissionResponseId,
        responseIdd,
      );
      SharedPrefsService.instance.setBool(AppKeys.isSoftLoggedIn, false);
      SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
      Get.offAllNamed(Routes.dashboard);
    }
  }

  Future<void> sendEmailVerification({required String responseIdd}) async {
    final String mail = emailController.text.trim();
    if (mail.isEmpty || !GetUtils.isEmail(mail)) {
      BaseSnackBar.show(
        title: "Error",
        message: "Please enter a valid email address.",
      );
      return;
    }

    final response = await authRepository.sentEmailVerification(mail);
    if (response != null) {
      var parsingModel = VerifiedEmailLocalParsingModel(
        email: emailController.text.trim(),
        fromLoginFlow: true,
        userType: 'user',
      );
      Get.toNamed(Routes.verifyEmailOtp, arguments: parsingModel)?.then((
        value,
      ) {
        if (value is VerifiedEmailLocalParsingModel) {
          if (value.requestSussessFull) {
            _navigateToDashboardFlow(responseIdd: responseIdd);
          }
        }
      });
    } else {
      BaseSnackBar.show(
        title: "Error",
        message: "Could not connect to verification service.",
      );
    }
  }

  void getProfessionalProfileDetail() async {
    var response = await authRepository.fetchProfessionalProfile();
    if (response != null) {
      debugPrint("response $response");
      final data = response['data'];
      ProfileResponseModel profileResponse = ProfileResponseModel.fromJson(
        response,
      );
      SharedPrefsService.instance.setString(
        AppKeys.name,
        profileResponse.data?.name ?? "",
      );
      SharedPrefsService.instance.setString(
        AppKeys.email,
        profileResponse.data?.email ?? "",
      );
      SharedPrefsService.instance.setString(
        AppKeys.accountStatus,
        data[AppKeys.accountStatus] ?? "",
      );
      SharedPrefsService.instance.setString(
        AppKeys.createdAt,
        data["startDate"] ?? "",
      );

      BaseCalculateRemainingDays().calculateRemainingDays(
        data["startDate"] ?? "",
      );

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
