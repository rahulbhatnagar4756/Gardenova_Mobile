import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasagardem/authentication/login/professional_profile_model.dart';
import 'package:kasagardem/authentication/login/profile_response_model.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/settings/profile/update_profile_model.dart';
import 'package:kasagardem/settings/settings_repository.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

import '../base/widgets/base_calculate_remaining_days.dart';
import '../utils/constants/app_keys.dart';
import '../utils/permission_manager.dart';
import '../utils/routes.dart';
import '../utils/shared_prefs_service.dart';
import '../utils/device_info_helper.dart';

class SettingsViewModel extends GetxController {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController specialtyController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final changePasswordFormKey = GlobalKey<FormState>();
  final profileFormKey = GlobalKey<FormState>();
  Rx<File> imageFile = File('').obs;
  RxString email = ''.obs;
  RxString name = ''.obs;
  RxBool isEmailVerified = true.obs;
  RxString originalEmail = ''.obs;
  RxBool showVerifyButton = false.obs;

  RxString profileImage = ''.obs;
  RxString screenType = ''.obs;
  RxBool isShareInProgress = false.obs;
  Rxn<ProfessionalProfileModel> professionalProfileData = Rxn();
  SettingsRepository profileRepository = SettingsRepository();
  RxString appVersion = '1.0.0'.obs;

  @override
  onInit() {
    fetchAppVersion();
    emailController.addListener(() {
      final mail = emailController.text.trim();
      if (mail.isNotEmpty && mail != originalEmail.value) {
        isEmailVerified.value = false;
        showVerifyButton.value = true;
      } else {
        isEmailVerified.value = true;
        showVerifyButton.value = false;
      }
    });
    if (Get.arguments != null && Get.arguments is String) {
      screenType.value = Get.arguments as String;
    }
    if (screenType.value == AppKeys.professional) {
      getProfessionalProfileDetail();
    } else {
      bool isUserLoggedIn =
          SharedPrefsService().getBool(AppKeys.isLoggedIn) ?? false;
      if (isUserLoggedIn) {
        getProfileDetail();
      }
    }

    super.onInit();
  }

  void fetchAppVersion() async {
    appVersion.value = await DeviceInfoHelper.getAppVersion();
  }

  @override
  void dispose() {
    super.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    emailController.dispose();
    otpController.dispose();
  }

  Future<void> pickImage({
    required bool isCamera,
    required bool directApiCall,
  }) async {
    print('pickImage gallery t0 source:  $isCamera');
    // Permission check
    if (isCamera) {
      bool hasPermission = await PermissionManager.handleCameraPermission();
      print('pickImage gallery t0.5 hasPermission: $hasPermission');
      if (!hasPermission) {
        return;
      }
      print('pickImage gallery t0.5 source: $hasPermission');
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        requestFullMetadata: true,
        imageQuality: 10,
        preferredCameraDevice: CameraDevice.front,
      );
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
      }
      // Get.back();
      if (directApiCall) {
        updateProfilePictureOnly();
      }
    } catch (e) {
      debugPrint("Error:::$e");
    }
  }

  void getProfileDetail({bool showloader = false}) async {
    var response = await profileRepository.fetchProfile(showloader: showloader);
    if (response != null) {
      ProfileResponseModel profileResponse = ProfileResponseModel.fromJson(
        response,
      );
      if (profileResponse.data != null) {
        name.value = profileResponse.data?.name ?? '';
        email.value = profileResponse.data?.email ?? '';
        nameController.text = profileResponse.data?.name ?? '';
        emailController.text = profileResponse.data?.email ?? '';
        originalEmail.value = profileResponse.data?.email ?? '';
        isEmailVerified.value = true;
        showVerifyButton.value = false;
        phoneNoController.text = profileResponse.data?.contactNumber ?? "";
        if (profileResponse.data?.profileImage != null) {
          profileImage.value = profileResponse.data!.profileImage!;
        }
      }
    }
    name.refresh();
    email.refresh();
    print('refreshing ui please');
    profileImage.refresh();
    screenType.refresh();
  }

  void getProfessionalProfileDetail() async {
    var response = await profileRepository.fetchProfessionalProfile();
    if (response != null) {
      debugPrint("response $response");
      ProfessionalProfileModel profileResponse =
          ProfessionalProfileModel.fromJson(response);
      professionalProfileData.value = profileResponse;
      if (profileResponse.data != null) {
        name.value = profileResponse.data!.name ?? '';
        email.value = profileResponse.data!.email ?? "";
        nameController.text = profileResponse.data!.name ?? '';
        emailController.text = profileResponse.data!.email ?? "";
        originalEmail.value = profileResponse.data!.email ?? "";
        isEmailVerified.value = true;
        showVerifyButton.value = false;
        descriptionController.text = profileResponse.data!.description ?? "";
        regionController.text = profileResponse.data!.region ?? "";
        specialtyController.text = profileResponse.data!.category ?? "";
        SharedPrefsService.instance.setString(AppKeys.name, name.value);
        SharedPrefsService.instance.setString(AppKeys.email, email.value);
        SharedPrefsService.instance.setString(
          AppKeys.createdAt,
          profileResponse.data!.startDate ?? "",
        );
        BaseCalculateRemainingDays().calculateRemainingDays(
          profileResponse.data!.startDate ?? "",
        );

        if (profileResponse.data?.imageUrl != null) {
          profileImage.value = profileResponse.data!.imageUrl!;
        }
      }
    }
    screenType.refresh();
  }

  updateProfilePictureOnly() async {
    String? base64String;

    // ✅ Check if image exists
    if (imageFile.value.path.isNotEmpty) {
      List<int> imageBytes = await imageFile.value.readAsBytes();
      base64String = base64Encode(imageBytes);
    }

    UpdateProfilePictureModel? updateProfileResponse =
        UpdateProfilePictureModel()
          ..profileImage = base64String != null
              ? "data:image/png;base64,$base64String"
              : null;

    debugPrint("updateProfileResponse ${updateProfileResponse.toJson()}");

    var response = await profileRepository.updateProfilePicture(
      updateProfileReq: updateProfileResponse,
    );

    if (response != null) {
      // if (base64String != null) {
      //   profileImage.value = updateProfileResponse.profileImage ?? "";
      //   profileImage.refresh();
      // }
      getProfileDetail();
      // Get.back();
    } else {
      // profileImage.value = '';
      imageFile.value = File('');
    }
  }

  updateProfile() async {
    if (!isEmailVerified.value) {
      BaseSnackBar.show(
        title: "Verification Required",
        message: "Please verify your new email address before saving changes.",
      );
      return;
    }
    String? base64String;

    // ✅ Check if image exists
    if (imageFile.value.path.isNotEmpty) {
      List<int> imageBytes = await imageFile.value.readAsBytes();
      base64String = base64Encode(imageBytes);
    }

    UpdateProfileModel? updateProfileResponse = UpdateProfileModel()
      ..profileImage = base64String != null
          ? "data:image/png;base64,$base64String"
          : profileImage.value.isNotEmpty
          ? profileImage.value
          : ''
      ..dateOfBirth = ""
      ..gender = ""
      ..bio = ""
      ..occupation = ""
      ..company = ""
      ..name = nameController.text
      ..email = emailController.text
      ..phoneNo = phoneNoController.text;

    log("updateProfileResponse ${updateProfileResponse.toJson()}");

    var response = await profileRepository.updateProfile(
      updateProfileReq: updateProfileResponse,
    );

    if (response != null) {
      // if (base64String != null) {
      //   profileImage.value = updateProfileResponse.profileImage ?? "";
      //   profileImage.refresh();
      // }
      getProfileDetail();
      Get.back();
    } else {
      profileImage.value = '';
      imageFile.value = File('');
    }
  }

  updateProfessionalProfile() async {
    if (!isEmailVerified.value) {
      BaseSnackBar.show(
        title: "Verification Required",
        message: "Please verify your new email address before saving changes.",
      );
      return;
    }
    Map<String, dynamic> map = {};

    if (nameController.text.isNotEmpty) {
      map["name"] = nameController.text;
    }

    if (emailController.text.isNotEmpty) {
      map["email"] = emailController.text;
    }

    if (descriptionController.text.isNotEmpty) {
      map["description"] = descriptionController.text;
    }

    if (regionController.text.isNotEmpty) {
      map["region"] = regionController.text;
    }

    if (specialtyController.text.isNotEmpty) {
      map["category"] = specialtyController.text;
    }

    if (imageFile.value.path.isNotEmpty) {
      List<int> imageBytes = await imageFile.value.readAsBytes();
      String base64String = base64Encode(imageBytes);
      map["profileImage"] = "data:image/png;base64,$base64String";
    }

    log("map::::$map");
    var response = await profileRepository.updateProfessionalProfile(
      updateProfessionalProfileReq: map,
    );
    if (response != null) {
      Get.back();
    }
  }

  updatePassword() async {
    var response = await profileRepository.changePassword(
      oldPasswordController.text,
      newPasswordController.text,
    );
    if (response != null) {
      oldPasswordController.clear();
      BaseDialog.showFullScreenDialog(
        Get.context!,
        buttonLabel: AppLocalizations.of(Get.context!)!.close.toUpperCase(),
        dialogTitle: AppLocalizations.of(Get.context!)!.passwordChanged,
        dialogDescription: AppLocalizations.of(
          Get.context!,
        )!.passwordChangedSuccessfully,
        onButtonPressed: () {
          Get.back();
          Get.back();
        },
      );
    }
  }

  callDeleteAccountApi() async {
    var response = await profileRepository.deleteAccount();
    if (response != null) {
      SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, false);
      SharedPrefsService.instance.clear();
      // Get.offAllNamed(Routes.chooseAccountType);
      SharedPrefsService.instance.setString(AppKeys.role, AppKeys.user);
      Get.offAllNamed(Routes.login);
    }
  }

  Future<void> sendEmailVerification() async {
    final String mail = emailController.text.trim();
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
          isEmailVerified.value = true;
          showVerifyButton.value = false;
          originalEmail.value = mail;
          BaseSnackBar.show(
            title: "Success",
            message: body['message'] ?? "Email is already verified.",
          );
        } else if (response.statusCode == 201) {
          BaseSnackBar.show(
            title: "Verification Sent",
            message: body['message'] ?? "Verification OTP sent to your email.",
          );
          Get.toNamed(Routes.verifyEmailOtp);
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
          isEmailVerified.value = true;
          showVerifyButton.value = false;
          originalEmail.value = emailController.text.trim();
          otpController.clear();

          Get.back();
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
