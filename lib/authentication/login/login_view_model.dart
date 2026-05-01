import 'dart:async';
import 'dart:io';
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
    if (Get.arguments != null) {
      isQuestionStatePassed.value =
          Get.arguments['question_state_passed'] ?? false;
    }

    googleSignIn.initialize(
      serverClientId: dotenv.env['webClientId']!,
      clientId: Platform.isIOS
          ? dotenv.env['iosClientId']!
          : dotenv.env['androidClientId']!,
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    scrollController.dispose();
  }

  Future<void> login() async {
    var loginResponse = await authRepository.loginUser(
      loginReq: {
        ApiKeys.email: emailController.text.toString().trim(),
        ApiKeys.password: passwordController.text.toString().trim(),
        "loginType": accountType.value.isNotEmpty ? accountType.value : "user",
      },
    );
    if (loginResponse != null) {
      SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
      SharedPrefsService.instance.setString(
        AppKeys.idToken,
        loginResponse[ApiKeys.data][ApiKeys.token],
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
    var loginResponse = await authRepository.registerGoogleToken(
      socialLoginReq: {
        ApiKeys.googleAccessToken: googleAuthToken,
        ApiKeys.roleCode: "U",
      },
    );
    if (loginResponse != null) {
      SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
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
      SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
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
      SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
      SharedPrefsService.instance.setString(
        AppKeys.idToken,
        loginResponse[ApiKeys.data][ApiKeys.token],
      );
      getProfileDetail();
    }
  }

  void getProfileDetail() async {
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
      if (profileResponse.data?.profileImage != null) {
        SharedPrefsService.instance.setString(
          AppKeys.profileImage,
          profileResponse.data!.profileImage!,
        );
      }
      Get.offAllNamed(Routes.introduction);
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
