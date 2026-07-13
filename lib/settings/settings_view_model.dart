import 'dart:async';
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
import 'package:kasagardem/services/notification_service.dart';
import 'package:kasagardem/services/reminder_push_notification_service.dart';
import 'package:kasagardem/settings/model/subscription_local_status_ui_model.dart';
import 'package:kasagardem/settings/profile/update_profile_model.dart';
import 'package:kasagardem/settings/profile/verified_email_otp_view/verified_email_local_parsing_model.dart';
import 'package:kasagardem/settings/settings_repository.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';
import 'package:kasagardem/utils/utils.dart';

import '../base/widgets/base_calculate_remaining_days.dart';
import '../utils/constants/api_keys.dart';
import '../utils/constants/app_keys.dart';
import '../utils/constants/app_strings.dart';
import '../utils/device_info_helper.dart';
import '../utils/permission_manager.dart';
import '../utils/routes.dart';
import '../utils/shared_prefs_service.dart';

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
  RxBool notificationsEnabled = true.obs;
  String apiImage = '';
  Rxn<ProfessionalProfileModel> professionalProfileData = Rxn();
  SettingsRepository profileRepository = SettingsRepository();
  RxString appVersion = '1.0.0'.obs;
  RxInt countdownTimer = 0.obs;
  Timer? _timer;

  late final FocusNode focusNode;
  var isEmailLogedInUser = true.obs;
  var isNewUserOtpLogin = false.obs;
  String otpLoginResponseId = '';
  var currentSubscriptionStatusModel = Rxn<SubscriptionStatusUiModel>();

  @override
  onInit() {
    isEmailLogedInUser.value =
        SharedPrefsService.instance.getBool(AppKeys.emailLogedInUser) ?? true;
    notificationsEnabled.value =
        SharedPrefsService.instance.getBool(AppKeys.notificationsEnabled) ?? true;
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
    focusNode = FocusNode();
    if (Get.arguments != null) {
      if (Get.arguments is String) {
        screenType.value = Get.arguments as String;
      } else if (Get.arguments is Map) {
        final args = Map<String, dynamic>.from(Get.arguments as Map);
        if (args[AppKeys.isNewUserOtpLogin] == true) {
          isNewUserOtpLogin.value = true;
          otpLoginResponseId = args[ApiKeys.responseId]?.toString() ?? '';
          phoneNoController.text = args[ApiKeys.phoneNumber]?.toString() ?? '';
        }
        if (args.containsKey(AppKeys.screenType)) {
          screenType.value = args[AppKeys.screenType]?.toString() ?? '';
        }
      }
    }
    if (isNewUserOtpLogin.value) {
      print("otpLoginResponseId::::$otpLoginResponseId");
      //  getProfileDetail();
    } else if (screenType.value == AppKeys.professional) {
      getProfessionalProfileDetail();
    } else {
      initFunctions();
    }

    super.onInit();
  }

  Future<void> initFunctions() async {
    bool isUserLoggedIn = SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false;
    if (isUserLoggedIn) {
      await Future.wait([getSubcriptionDetail(), getProfileDetail()]);
    }
  }

  void startTimer() {
    countdownTimer.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownTimer.value > 0) {
        countdownTimer.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    await SharedPrefsService.instance.setBool(AppKeys.notificationsEnabled, value);

    if (value) {
      final granted = await NotificationService.instance.requestNotificationPermission();
      if (granted) {
        await ReminderPushNotificationService.instance.registerDeviceTokenIfNeeded();
      } else {
        notificationsEnabled.value = false;
        await SharedPrefsService.instance.setBool(AppKeys.notificationsEnabled, false);
      }
    } else {
      await ReminderPushNotificationService.instance.unregisterDeviceToken();
    }
  }

  void fetchAppVersion() async {
    appVersion.value = await DeviceInfoHelper.getAppVersion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    emailController.dispose();
    focusNode.dispose();
  }

  Future<void> pickImage({required bool isCamera, required bool directApiCall}) async {
    // Permission check
    if (isCamera) {
      bool hasPermission = await PermissionManager.handleCameraPermission();
      if (!hasPermission) {
        return;
      }
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

  Future<void> getProfileDetail({bool showloader = false}) async {
    var response = await profileRepository.fetchProfile(showloader: showloader);
    if (response != null) {
      ProfileResponseModel profileResponse = ProfileResponseModel.fromJson(response);
      if (profileResponse.data != null) {
        name.value = profileResponse.data?.name ?? '';
        email.value = profileResponse.data?.email ?? '';
        nameController.text = profileResponse.data?.name ?? '';
        emailController.text = profileResponse.data?.email ?? '';
        originalEmail.value = profileResponse.data?.email ?? '';
        isEmailVerified.value = true;
        showVerifyButton.value = false;
        SharedPrefsService.instance.setString(AppKeys.name, name.value);
        SharedPrefsService.instance.setString(AppKeys.email, email.value);
        String phone = profileResponse.data?.contactNumber ?? "";
        if (phone.startsWith("+91")) {
          phone = phone.replaceFirst("+91", "");
        }
        phoneNoController.text = phone;
        if (profileResponse.data?.profileImage != null) {
          profileImage.value = profileResponse.data?.profileImage ?? '';
          apiImage = profileResponse.data?.profileImage ?? '';
        }
        if (profileResponse.data?.endDate != null ||
            profileResponse.data?.subscriptionPlan != null ||
            profileResponse.data?.accountStatus != null) {
          _applySubscriptionFromFields(
            planName: profileResponse.data?.subscriptionPlan,
            accountStatus: profileResponse.data?.accountStatus,
            startDate: profileResponse.data?.startDate,
            endDate: profileResponse.data?.endDate,
          );
        }
      }
    }
    name.refresh();
    email.refresh();
    profileImage.refresh();
    screenType.refresh();
  }

  Future<void> getProfessionalProfileDetail() async {
    var response = await profileRepository.fetchProfessionalProfile();
    if (response != null) {
      ProfessionalProfileModel profileResponse = ProfessionalProfileModel.fromJson(response);
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
        SharedPrefsService.instance.setString(
          AppKeys.accountStatus,
          profileResponse.data!.accountStatus ?? "",
        );
        _applySubscriptionFromFields(
          planName: profileResponse.data!.subscriptionPlan,
          accountStatus: profileResponse.data!.accountStatus,
          startDate: profileResponse.data!.startDate,
          endDate: profileResponse.data!.endDate,
        );

        if (profileResponse.data?.imageUrl != null) {
          profileImage.value = profileResponse.data?.imageUrl ?? '';
          apiImage = profileResponse.data!.imageUrl ?? '';
        }
      }
    }
    screenType.refresh();
  }

  Future<void> getSubcriptionDetail() async {
    final isProfessional = screenType.value == AppKeys.professional;

    if (isProfessional) {
      final response = await profileRepository.fetchProfessionalProfile();
      if (response != null) {
        final profileResponse = ProfessionalProfileModel.fromJson(response);
        professionalProfileData.value = profileResponse;
        final data = profileResponse.data;
        if (data != null &&
            _hasSubscriptionPayload(
              planName: data.subscriptionPlan,
              accountStatus: data.accountStatus,
              endDate: data.endDate,
            )) {
          _applySubscriptionFromFields(
            planName: data.subscriptionPlan,
            accountStatus: data.accountStatus,
            startDate: data.startDate,
            endDate: data.endDate,
          );
          return;
        }
      }
    } else {
      final response = await profileRepository.fetchProfile();
      if (response != null) {
        final profileResponse = ProfileResponseModel.fromJson(response);
        final data = profileResponse.data;
        if (data != null &&
            _hasSubscriptionPayload(
              planName: data.subscriptionPlan,
              accountStatus: data.accountStatus,
              endDate: data.endDate,
            )) {
          _applySubscriptionFromFields(
            planName: data.subscriptionPlan,
            accountStatus: data.accountStatus,
            startDate: data.startDate,
            endDate: data.endDate,
          );
          return;
        }
      }
    }

    // Keep existing status if profile fetch fails / lags; do not overwrite with mocks.
    if (currentSubscriptionStatusModel.value?.updatedAt != null) {
      BaseCalculateRemainingDays.persistFromEndDate(
        currentSubscriptionStatusModel.value!.updatedAt,
      );
    }
    currentSubscriptionStatusModel.refresh();
  }

  bool _hasSubscriptionPayload({
    String? planName,
    String? accountStatus,
    String? endDate,
  }) {
    return (planName != null && planName.trim().isNotEmpty) ||
        (accountStatus != null && accountStatus.trim().isNotEmpty) ||
        (endDate != null && endDate.trim().isNotEmpty);
  }

  void activateSubscriptionLocally({
    required String planName,
    required bool isMonthly,
    String? endDateOverride,
  }) {
    final endDate =
        endDateOverride ??
        DateTime.now()
            .add(Duration(days: isMonthly ? 30 : 365))
            .toIso8601String();
    _applySubscriptionFromFields(
      planName: planName,
      accountStatus: 'Active',
      startDate: DateTime.now().toIso8601String(),
      endDate: endDate,
      force: true,
    );
  }

  /// Rebuilds the profile subscription card from prefs when API data is stale/missing.
  void hydrateSubscriptionFromPrefsIfNeeded() {
    final prefsDays =
        int.tryParse(
          SharedPrefsService.instance.getString(AppKeys.remainingDays) ?? '0',
        ) ??
        0;
    final currentRemaining = BaseCalculateRemainingDays.daysUntilEndDate(
      currentSubscriptionStatusModel.value?.updatedAt,
    );

    if (prefsDays <= 0 || currentRemaining > 0) return;

    final planName =
        SharedPrefsService.instance.getString(AppKeys.subscriptionPlan) ??
        'Premium';
    final endDate = DateTime.now().add(Duration(days: prefsDays)).toIso8601String();
    currentSubscriptionStatusModel.value = SubscriptionStatusUiModel(
      name: planName,
      status: 'Active',
      isActive: true,
      isTrialActive: planName.toLowerCase() == 'trial',
      createdAt: SharedPrefsService.instance.getString(AppKeys.createdAt),
      updatedAt: endDate,
    );
    currentSubscriptionStatusModel.refresh();
  }

  Future<void> refreshProfileSubscription() async {
    hydrateSubscriptionFromPrefsIfNeeded();
    await Future.wait([getProfileDetail(), getSubcriptionDetail()]);
    hydrateSubscriptionFromPrefsIfNeeded();
  }

  void _applySubscriptionFromFields({
    String? planName,
    String? accountStatus,
    String? startDate,
    String? endDate,
    bool force = false,
  }) {
    final normalizedStatus = (accountStatus ?? '').trim();
    final normalizedPlan = (planName ?? '').trim();
    final statusLower = normalizedStatus.toLowerCase();
    final explicitlyInactive =
        statusLower == 'expired' ||
        statusLower == 'cancelled' ||
        statusLower == 'canceled' ||
        statusLower == 'inactive';

    final incomingRemaining = BaseCalculateRemainingDays.daysUntilEndDate(endDate);
    final currentRemaining = BaseCalculateRemainingDays.daysUntilEndDate(
      currentSubscriptionStatusModel.value?.updatedAt,
    );
    final prefsDays =
        int.tryParse(
          SharedPrefsService.instance.getString(AppKeys.remainingDays) ?? '0',
        ) ??
        0;

    // Keep a fresher local/post-payment activation instead of stale API expiry.
    if (!force &&
        !explicitlyInactive &&
        incomingRemaining == 0 &&
        (currentRemaining > 0 || prefsDays > 0)) {
      hydrateSubscriptionFromPrefsIfNeeded();
      return;
    }

    final isTrial = normalizedPlan.toLowerCase() == 'trial';
    final isActive =
        statusLower == 'active' ||
        statusLower == 'renewed' ||
        (normalizedStatus.isEmpty && incomingRemaining > 0);

    currentSubscriptionStatusModel.value = SubscriptionStatusUiModel(
      name: normalizedPlan.isNotEmpty ? normalizedPlan : 'Free',
      status: normalizedStatus.isNotEmpty
          ? normalizedStatus
          : (isActive ? 'Active' : 'Expired'),
      isActive: isActive,
      isTrialActive: isTrial && isActive,
      createdAt: startDate,
      updatedAt: endDate,
    );

    if (endDate != null && endDate.trim().isNotEmpty) {
      BaseCalculateRemainingDays.persistFromEndDate(endDate);
    } else if (isTrial && startDate != null && startDate.trim().isNotEmpty) {
      BaseCalculateRemainingDays().calculateRemainingDays(startDate);
    } else if (!isActive) {
      SharedPrefsService.instance.setString(AppKeys.remainingDays, '0');
    }

    if (normalizedPlan.isNotEmpty) {
      SharedPrefsService.instance.setString(
        AppKeys.subscriptionPlan,
        normalizedPlan,
      );
    }
    if (normalizedStatus.isNotEmpty) {
      SharedPrefsService.instance.setString(
        AppKeys.accountStatus,
        normalizedStatus,
      );
    }
    if (startDate != null && startDate.trim().isNotEmpty) {
      SharedPrefsService.instance.setString(AppKeys.createdAt, startDate);
    }

    currentSubscriptionStatusModel.refresh();
  }

  void updateProfilePictureOnly() async {
    String? base64String;

    if (imageFile.value.path.isNotEmpty) {
      List<int> imageBytes = await imageFile.value.readAsBytes();
      base64String = base64Encode(imageBytes);
    }

    UpdateProfilePictureModel? updateProfileResponse = UpdateProfilePictureModel()
      ..profileImage = base64String != null ? "data:image/png;base64,$base64String" : null;

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
      if (apiImage.isNotEmpty) {
        profileImage.value = apiImage;
        profileImage.refresh();
      }
    }
  }

  void updateProfile() async {
    if (!isEmailVerified.value) {
      BaseSnackBar.show(
        title: "Verification Required",
        message: "Please verify your new email address before saving changes.",
      );
      return;
    }
    String? base64String;

    if (imageFile.value.path.isNotEmpty) {
      List<int> imageBytes = await imageFile.value.readAsBytes();
      base64String = base64Encode(imageBytes);
    }

    UpdateProfileModel? updateProfileResponse = UpdateProfileModel()
      ..profileImage = base64String != null ? "data:image/png;base64,$base64String" : null
      ..dateOfBirth = ""
      ..gender = ""
      ..bio = ""
      ..occupation = ""
      ..company = ""
      ..name = nameController.text
      ..email = emailController.text
      ..phoneNo = "+91${phoneNoController.text}";

    log("updateProfileResponse ${updateProfileResponse.toJson()}");

    var response = await profileRepository.updateProfile(updateProfileReq: updateProfileResponse);

    if (response != null) {
      await getProfileDetail();
      if (isNewUserOtpLogin.value) {
        SharedPrefsService.instance.setString(AppKeys.name, nameController.text);
        SharedPrefsService.instance.setString(AppKeys.email, emailController.text);
        _completeNewUserOtpLoginNavigation();
        return;
      }
      Get.back();
    } else {
      profileImage.value = '';
      imageFile.value = File('');
      if (apiImage.isNotEmpty) {
        profileImage.value = apiImage;
        profileImage.refresh();
      }
    }
  }

  void _completeNewUserOtpLoginNavigation() {
    if (otpLoginResponseId.trim().isEmpty) {
      SharedPrefsService.instance.setBool(AppKeys.isSoftLoggedIn, true);
      Get.offAllNamed(Routes.question);
    } else {
      SharedPrefsService.instance.setString(AppKeys.submissionResponseId, otpLoginResponseId);
      SharedPrefsService.instance.setBool(AppKeys.isSoftLoggedIn, false);
      SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
      ReminderPushNotificationService.instance.registerDeviceTokenIfNeeded();
      Get.offAllNamed(Routes.dashboard);
    }
  }

  void updateProfessionalProfile() async {
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

  void updatePassword() async {
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
        dialogDescription: AppLocalizations.of(Get.context!)!.passwordChangedSuccessfully,
        onButtonPressed: () {
          Get.back();
          Get.back();
        },
      );
    }
  }

  void setPassword() async {
    log("response::${newPasswordController.text}");
    var response = await profileRepository.setPassword(newPasswordController.text);
    log("response::$response");
    if (response != null &&
        response is Map &&
        (response['success'] == true ||
            response['statusCode'] == 200 ||
            response['statusCode'] == 201)) {
      isEmailLogedInUser.value = true;
      isEmailLogedInUser.refresh();
      await SharedPrefsService.instance.setBool(AppKeys.emailLogedInUser, true);
      oldPasswordController.clear();
      BaseDialog.showFullScreenDialog(
        Get.context!,
        buttonLabel: AppLocalizations.of(Get.context!)!.close.toUpperCase(),
        dialogTitle: AppStrings.setPwd,
        dialogDescription: AppLocalizations.of(Get.context!)!.passwordChangedSuccessfully,
        onButtonPressed: () {
          Get.back();
          Get.back();
        },
      );
    }
  }

  void callDeleteAccountApi() async {
    var response = await profileRepository.deleteAccount();
    if (response != null) {
      // await ReminderPushNotificationService.instance.onUserLogout();
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
      BaseSnackBar.show(title: "Error", message: "Please enter a valid email address.");
      return;
    }

    ApiRepository.instance.showLoader();
    try {
      final response = await profileRepository.sentEmailVerification(mail);
      ApiRepository.instance.hideLoader();
      if (response != null) {
        final Map<String, dynamic> body = response is Map
            ? Map<String, dynamic>.from(response)
            : jsonDecode(response.toString());

        if (body['statusCode'] == 201) {
          isEmailVerified.value = true;
          showVerifyButton.value = false;
          originalEmail.value = mail;
          BaseSnackBar.show(
            title: "Success",
            message: body['message'] ?? "Email is already verified.",
          );
        } else if (body['statusCode'] == 200 || body['success'] == true) {
          BaseSnackBar.show(
            title: "Verification Sent",
            message: body['message'] ?? "Verification OTP sent to your email.",
          );
          startTimer();
          var parsingModel = VerifiedEmailLocalParsingModel(
            email: emailController.text.trim(),
            fromLoginFlow: false,
            userType: 'user',
          );
          Get.toNamed(Routes.verifyEmailOtp, arguments: parsingModel)?.then((value) {
            Utils.hideKeyboard();
            if (value is VerifiedEmailLocalParsingModel) {
              if (value.requestSussessFull) {
                isEmailVerified.value = true;
                showVerifyButton.value = false;
                originalEmail.value = mail;
                showVerifyButton.refresh();
              }
            }
          });
        } else {
          BaseSnackBar.show(
            title: "Error",
            message: body['message'] ?? "Failed to send verification email.",
          );
        }
      } else {
        //  BaseSnackBar.show(title: "Error", message: "Could not connect to verification service.");
      }
    } catch (e) {
      ApiRepository.instance.hideLoader();
      debugPrint("sendEmailVerification exception: $e");
      BaseSnackBar.show(title: "Error", message: "An error occurred during verification process.");
    }
  }
}
