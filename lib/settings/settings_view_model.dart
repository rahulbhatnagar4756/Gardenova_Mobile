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
      getProfileDetail();
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
        phoneNoController.text = profileResponse.data?.contactNumber ?? "";
        if (profileResponse.data?.profileImage != null) {
          profileImage.value = profileResponse.data?.profileImage ?? '';
          apiImage = profileResponse.data?.profileImage ?? '';
        }
      }
    }
    name.refresh();
    email.refresh();
    profileImage.refresh();
    screenType.refresh();
  }

  void getProfessionalProfileDetail() async {
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
        BaseCalculateRemainingDays().calculateRemainingDays(profileResponse.data!.startDate ?? "");

        if (profileResponse.data?.imageUrl != null) {
          profileImage.value = profileResponse.data?.imageUrl ?? '';
          apiImage = profileResponse.data!.imageUrl ?? '';
        }
      }
    }
    screenType.refresh();
  }

  Future<void> getSubcriptionDetail() async {
    // var realDetialModel = SubscriptionStatusUiModel(
    //   name: profileResponse.data!.subscriptionPlan,
    //   status: profileResponse.data!.accountStatus,
    //   isActive: profileResponse.data!.accountStatus?.toLowerCase() == "active",
    //   isTrialActive: profileResponse.data!.subscriptionPlan?.toLowerCase() == "trial",
    //   createdAt: profileResponse.data!.startDate,
    //   updatedAt: profileResponse.data!.endDate,
    // );
    // Trial Subscription
    // final trialSubscription = SubscriptionStatusUiModel(
    //   name: "Trial",
    //   status: "Active",
    //   isActive: true,
    //   isTrialActive: true,
    //   createdAt: "2026-06-01",
    //   updatedAt: "2026-06-15",
    // );

    // Active Subscription
    final activeSubscription = SubscriptionStatusUiModel(
      name: "Premium",
      status: "Active",
      isActive: true,
      isTrialActive: false,
      createdAt: "2026-05-01",
      updatedAt: "2026-07-01",
    );

    // Cancelled Subscription
    // final cancelledSubscription = SubscriptionStatusUiModel(
    //   name: "Premium",
    //   status: "Cancelled",
    //   isActive: false,
    //   isTrialActive: false,
    //   createdAt: "2026-04-01",
    //   updatedAt: "2026-05-15",
    // );

    // Renewed Subscription
    // final renewedSubscription = SubscriptionStatusUiModel(
    //   name: "Premium",
    //   status: "Renewed",
    //   isActive: true,
    //   isTrialActive: false,
    //   createdAt: "2026-06-01",
    //   updatedAt: "2027-06-01",
    // );
    // need change
    // currentSubscriptionStatusModel.value = trialSubscription;
    currentSubscriptionStatusModel.value = activeSubscription;
    // currentSubscriptionStatusModel.value = cancelledSubscription;
    // currentSubscriptionStatusModel.value = renewedSubscription;
    // currentSubscriptionStatusModel.value = realDetialModel;

    if (currentSubscriptionStatusModel.value != null) {
      final model = currentSubscriptionStatusModel.value!;
      if (model.updatedAt != null) {
        try {
          final expirationDate = DateTime.parse(model.updatedAt!).toLocal();
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final exp = DateTime(expirationDate.year, expirationDate.month, expirationDate.day);
          final remaining = exp.difference(today).inDays;
          SharedPrefsService.instance.setString(
            AppKeys.remainingDays,
            remaining.clamp(0, 365).toString(),
          );
        } catch (_) {
          SharedPrefsService.instance.setString(AppKeys.remainingDays, "0");
        }
      }
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
      await ReminderPushNotificationService.instance.onUserLogout();
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
        BaseSnackBar.show(title: "Error", message: "Could not connect to verification service.");
      }
    } catch (e) {
      ApiRepository.instance.hideLoader();
      debugPrint("sendEmailVerification exception: $e");
      BaseSnackBar.show(title: "Error", message: "An error occurred during verification process.");
    }
  }
}
