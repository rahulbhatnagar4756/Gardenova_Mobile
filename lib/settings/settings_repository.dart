import 'dart:developer';

import 'package:kasagardem/settings/profile/update_profile_model.dart';
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

class SettingsRepository {
  final String profileEndPoint = 'api/v1/userProfile';
  final String sendEmailVerification =
      'api/v1/userProfile/sentemailvarification';
  final String verifryEmail = 'api/v1/userProfile/verifyemail';
  final String updateProfessionalProfileUrl = 'api/v1/professional/update';
  final String changePasswordEndPoint = 'api/v1/auth/resetPassword/auth';
  final String setPasswordEndPoint = 'api/v1/userProfile/addPasswordforsso';
  final String _professionalProfileDetail =
      'api/v1/professional/ProfessionalsProfile';
  final String _deleteAccountUrl = 'api/v1/userProfile/soft-delete';

  fetchProfile({bool showloader = false}) async {
    var profileResponse = await ApiRepository.instance.get(
      profileEndPoint,
      showDefaultLoader: showloader,
    );
    return profileResponse;
  }

  updateProfile({UpdateProfileModel? updateProfileReq}) async {
    var updateProfileResponse = await ApiRepository.instance.put(
      profileEndPoint,
      body: updateProfileReq,
    );
    return updateProfileResponse;
  }

  updateProfilePicture({UpdateProfilePictureModel? updateProfileReq}) async {
    var updateProfileResponse = await ApiRepository.instance.put(
      profileEndPoint,
      body: updateProfileReq,
    );
    return updateProfileResponse;
  }

  updateProfessionalProfile({
    Map<String, dynamic>? updateProfessionalProfileReq,
  }) async {
    var updateProfileResponse = await ApiRepository.instance.patch(
      updateProfessionalProfileUrl,
      updateProfessionalProfileReq,
    );
    return updateProfileResponse;
  }

  fetchProfessionalProfile() async {
    var profileResponse = await ApiRepository.instance.get(
      _professionalProfileDetail,
    );
    return profileResponse;
  }

  changePassword(String oldPassword, String password) async {
    var changePasswordResponse = await ApiRepository.instance.patch(
      changePasswordEndPoint,
      {ApiKeys.oldPassword: oldPassword, ApiKeys.password: password},
    );
    return changePasswordResponse;
  }

  setPassword(String password) async {
    var changePasswordResponse = await ApiRepository.instance.patch(
      setPasswordEndPoint,
      {ApiKeys.newPassword: password},
    );
    return changePasswordResponse;
  }

  deleteAccount() async {
    var deleteAccountResponse = await ApiRepository.instance.patch(
      _deleteAccountUrl,
      {},
    );
    return deleteAccountResponse;
  }

  Future<dynamic> sentEmailVerification(String email) async {
    var response = await ApiRepository.instance.patch(sendEmailVerification, {
      "email": email,
    });
    log('sentEmailVerification ${response}');
    log('sentEmailVerification ${response}');
    return response;

    // final token = SharedPrefsService.instance.getToken();
    // final String acceptLanguage =
    //     Get.locale?.languageCode ??
    //     SharedPrefsService.instance.getString(AppKeys.selectedLang) ??
    //     'en';
    // final uri = Uri.parse(
    //   ApiRepository.baseUrl + 'api/v1/userProfile/sentemailvarification',
    // );

    // try {
    //   final response = await http.patch(
    //     uri,
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'accept': 'application/json',
    //       'Accept-Language': acceptLanguage,
    //       'accept-language': acceptLanguage,
    //       if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    //     },
    //     body: jsonEncode({"email": email}),
    //   );
    //   return response;
    // } catch (e) {
    //   debugPrint("Error sending email verification: $e");
    //   return null;
    // }
  }

  Future<dynamic> verifyEmail(String otp) async {
    var response = await ApiRepository.instance.post(
      verifryEmail,
      body: {"otp": otp},
    );
    return response;

    // final token = SharedPrefsService.instance.getToken();
    // final String acceptLanguage =
    //     Get.locale?.languageCode ??
    //     SharedPrefsService.instance.getString(AppKeys.selectedLang) ??
    //     'en';
    // final uri = Uri.parse(
    //   ApiRepository.baseUrl + 'api/v1/userProfile/verifyemail',
    // );

    // try {
    //   final response = await http.post(
    //     uri,
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'accept': 'application/json',
    //       'Accept-Language': acceptLanguage,
    //       'accept-language': acceptLanguage,
    //       if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    //     },
    //     body: jsonEncode({"otp": otp}),
    //   );
    //   return response;
    // } catch (e) {
    //   debugPrint("Error verifying email: $e");
    //   return null;
    // }
  }
}
