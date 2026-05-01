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
import '../base/widgets/base_calculate_remaining_days.dart';
import '../utils/constants/app_keys.dart';
import '../utils/routes.dart';
import '../utils/shared_prefs_service.dart';

class SettingsViewModel extends GetxController {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController specialtyController = TextEditingController();
  final changePasswordFormKey = GlobalKey<FormState>();
  Rx<File> imageFile = File('').obs;
  RxString email = ''.obs;
  RxString name = ''.obs;
  RxString profileImage = ''.obs;
  RxString screenType = ''.obs;
  RxBool isShareInProgress = false.obs;
  Rxn<ProfessionalProfileModel> professionalProfileData = Rxn();
  SettingsRepository profileRepository = SettingsRepository();

  @override
  onInit() {
    if (Get.arguments != null) {
      screenType.value = Get.arguments;
    }
    if (screenType.value == AppKeys.professional) {
      getProfessionalProfileDetail();
    } else {
      getProfileDetail();
    }
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> pickImage({required bool isCamera}) async {
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
      Get.back();
    } catch (e) {
      debugPrint("Error:::$e");
    }
  }

  void getProfileDetail() async {
    var response = await profileRepository.fetchProfile();
    if (response != null) {
      ProfileResponseModel profileResponse = ProfileResponseModel.fromJson(
        response,
      );
      if (profileResponse.data != null) {
        name.value = profileResponse.data!.name!;
        email.value = profileResponse.data!.email!;
        if (profileResponse.data?.profileImage != null) {
          profileImage.value = profileResponse.data!.profileImage!;
        }
      }
    }
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
  }

  updateProfile() async {
    List<int> imageBytes = await imageFile.value.readAsBytes();
    String base64String = base64Encode(imageBytes);
    UpdateProfileModel? updateProfileResponse = UpdateProfileModel()
      ..profileImage = "data:image/png;base64, $base64String"
      ..dateOfBirth = ""
      ..gender = ""
      ..bio = ""
      ..occupation = ""
      ..company = "";

    debugPrint("updateProfileResponse ${updateProfileResponse.toJson()}");
    var response = await profileRepository.updateProfile(
      updateProfileReq: updateProfileResponse,
    );
    if (response != null) {
      profileImage.value = updateProfileResponse.profileImage ?? "";
      Get.back();
    }
  }

  updateProfessionalProfile() async {
    Map<String, dynamic> map = {};

    if (name.value.isNotEmpty) {
      map["name"] = name.value;
    }

    if (email.value.isNotEmpty) {
      map["email"] = email.value;
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
      Get.offAllNamed(Routes.chooseAccountType);
    }
  }
}
