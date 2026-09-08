import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasagardem/authentication/login/professional_profile_model.dart';
import 'package:kasagardem/authentication/login/profile_response_model.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
// Razorpay subscription cancel (disabled — Google Play Billing only)
// import 'package:kasagardem/professional/payment/model/razorpay_order_model.dart';
// import 'package:kasagardem/professional/payment/razorpay_payment_repository.dart';
import 'package:kasagardem/services/notification_service.dart';
import 'package:kasagardem/services/reminder_push_notification_service.dart';
import 'package:kasagardem/settings/model/subscription_local_status_ui_model.dart';
import 'package:kasagardem/settings/model/user_subscription_me_model.dart';
import 'package:kasagardem/settings/profile/update_profile_model.dart';
import 'package:kasagardem/settings/profile/verified_email_otp_view/verified_email_local_parsing_model.dart';
import 'package:kasagardem/settings/settings_repository.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';
import 'package:kasagardem/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../base/widgets/base_calculate_remaining_days.dart';
import '../utils/constants/api_keys.dart';
import '../utils/constants/app_keys.dart';
import '../utils/constants/app_strings.dart';
import '../utils/device_info_helper.dart';
import '../utils/permission_manager.dart';
import '../utils/routes.dart';
import '../utils/shared_prefs_service.dart';
import '../utils/validation_healper.dart';

class SettingsViewModel extends GetxController with WidgetsBindingObserver {
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
  RxBool notificationsEnabled = false.obs;
  String apiImage = '';
  Rxn<ProfessionalProfileModel> professionalProfileData = Rxn();
  SettingsRepository profileRepository = SettingsRepository();
  // Razorpay subscription cancel repository (disabled — Google Play Billing only)
  // final RazorpayPaymentRepository _subscriptionRepository = RazorpayPaymentRepository();
  RxString appVersion = '1.0.0'.obs;
  RxInt countdownTimer = 0.obs;
  Timer? _timer;
  RxBool isCancellingSubscription = false.obs;
  /// True after opening Play Store for cancel — refresh /me on resume.
  bool _awaitingPlayCancelReturn = false;

  late final FocusNode focusNode;
  var isEmailLogedInUser = true.obs;
  var isNewUserOtpLogin = false.obs;
  String otpLoginResponseId = '';
  var currentSubscriptionStatusModel = Rxn<SubscriptionStatusUiModel>();

  @override
  onInit() {
    WidgetsBinding.instance.addObserver(this);
    isEmailLogedInUser.value =
        SharedPrefsService.instance.getBool(AppKeys.emailLogedInUser) ?? true;
    unawaited(syncNotificationsFromSystem());
    fetchAppVersion();
    emailController.addListener(onEmailChanged);
    name.value = SharedPrefsService.instance.getString(AppKeys.name) ?? '';
    email.value = SharedPrefsService.instance.getString(AppKeys.email) ?? '';
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

  void onEmailChanged([String? value]) {
    final mail = emailController.text.trim();
    final isValidEmail = ValidationHelper.validateEmail(mail) == null;
    if (mail.isNotEmpty && mail != originalEmail.value) {
      isEmailVerified.value = false;
      showVerifyButton.value = isValidEmail;
    } else {
      isEmailVerified.value = true;
      showVerifyButton.value = false;
    }
  }

  Future<void> initFunctions() async {
    bool isUserLoggedIn = SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false;
    if (isUserLoggedIn) {
      await getProfileDetail();
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

  Future<void> syncNotificationsFromSystem() async {
    final granted = await NotificationService.instance.isNotificationGranted();
    notificationsEnabled.value = granted;
    await SharedPrefsService.instance.setBool(AppKeys.notificationsEnabled, granted);
  }

  void toggleNotifications(bool value) async {
    if (value) {
      final granted = await NotificationService.instance.requestNotificationPermission();
      notificationsEnabled.value = granted;
      await SharedPrefsService.instance.setBool(AppKeys.notificationsEnabled, granted);
      if (granted) {
        await ReminderPushNotificationService.instance.registerDeviceTokenIfNeeded();
      }
      return;
    }

    notificationsEnabled.value = false;
    await SharedPrefsService.instance.setBool(AppKeys.notificationsEnabled, false);
    await ReminderPushNotificationService.instance.unregisterDeviceToken();
  }

  void fetchAppVersion() async {
    appVersion.value = await DeviceInfoHelper.getAppVersion();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    emailController.dispose();
    focusNode.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    unawaited(syncNotificationsFromSystem());
    if (!_awaitingPlayCancelReturn) return;
    _awaitingPlayCancelReturn = false;
    unawaited(_refreshSubscriptionAfterPlayReturn());
  }

  Future<void> _refreshSubscriptionAfterPlayReturn() async {
    try {
      await getSubscriptionDetail();
      final model = currentSubscriptionStatusModel.value;
      final cancelled =
          model?.cancelAtPeriodEnd == true ||
          (model?.status ?? '').toLowerCase() == 'cancelled' ||
          (model?.status ?? '').toLowerCase() == 'canceled';
      if (cancelled) {
        BaseSnackBar.show(
          title: AppStrings.subscriptionCancelled,
          message: AppStrings.subscriptionCancelledNote,
        );
      }
    } catch (e) {
      log('Refresh subscription after Play return error: $e');
    }
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
        imageQuality: 70,
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
      }
    }
    name.refresh();
    email.refresh();
    profileImage.refresh();
    screenType.refresh();

    // Always refresh subscription from /plans/subscriptions/me with profile.
    await getSubscriptionDetail();
  }

  Future<void> getProfessionalProfileDetail({bool showloader = true}) async {
    var response = await profileRepository.fetchProfessionalProfile(showloader: showloader);
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
    // Professionals also need /me for plan status, remaining days, and Play SKU.
    await getSubscriptionDetail();
  }

  /// GET api/v1/plans/subscriptions/me — current subscription status.
  Future<void> getSubscriptionDetail() async {
    final meResponse = await profileRepository.fetchUserSubscriptionMe();
    if (meResponse != null) {
      final parsed = UserSubscriptionMeResponse.fromJson(meResponse);
      if (parsed.data != null) {
        applySubscriptionFromMeApi(parsed.data!);
        return;
      }
      // Explicit empty/free response with success flag.
      if (parsed.success == true) {
        applySubscriptionFromMeApi(UserSubscriptionMeData(status: 'inactive'));
        return;
      }
    }

    // Fallback only if /me is unavailable.
    final response = await profileRepository.fetchProfile();
    if (response != null) {
      final profileResponse = ProfileResponseModel.fromJson(response);
      final subscription = profileResponse.data?.subscription;
      if (subscription != null) {
        applySubscriptionFromProfile(subscription);
        return;
      }
    }

    if (currentSubscriptionStatusModel.value != null) {
      final model = currentSubscriptionStatusModel.value!;
      if (model.updatedAt != null) {
        BaseCalculateRemainingDays.persistFromEndDate(model.updatedAt);
      }
    }
    currentSubscriptionStatusModel.refresh();
  }

  void applySubscriptionFromMeApi(UserSubscriptionMeData data) {
    final uiModel = SubscriptionStatusUiModel.fromMeApi(data);
    _persistSubscriptionUiModel(uiModel);
  }

  void applySubscriptionFromProfile(Subscription subscription) {
    final uiModel = SubscriptionStatusUiModel.fromProfileSubscription(subscription);
    _persistSubscriptionUiModel(uiModel);
  }

  void _persistSubscriptionUiModel(SubscriptionStatusUiModel uiModel) {
    currentSubscriptionStatusModel.value = uiModel;

    if (uiModel.updatedAt != null && uiModel.updatedAt!.isNotEmpty) {
      BaseCalculateRemainingDays.persistFromEndDate(uiModel.updatedAt);
    } else {
      SharedPrefsService.instance.setString(AppKeys.remainingDays, '0');
    }

    if (uiModel.name != null && uiModel.name!.isNotEmpty) {
      SharedPrefsService.instance.setString(AppKeys.subscriptionPlan, uiModel.name!);
    }
    if (uiModel.status != null && uiModel.status!.isNotEmpty) {
      SharedPrefsService.instance.setString(AppKeys.accountStatus, uiModel.status!);
    }
    if (uiModel.createdAt != null && uiModel.createdAt!.isNotEmpty) {
      SharedPrefsService.instance.setString(AppKeys.createdAt, uiModel.createdAt!);
    }

    currentSubscriptionStatusModel.refresh();
  }

  bool get canCancelSubscription {
    final model = currentSubscriptionStatusModel.value;
    if (model == null || model.isActive != true) return false;
    if (model.cancelAtPeriodEnd == true) return false;
    // Downgrade / plan change already scheduled — hide cancel.
    if (model.hasPendingPlan) return false;

    final plan = (model.name ?? '').trim().toLowerCase();
    if (plan.isEmpty || plan == 'free' || plan == 'trial') return false;

    final status = (model.status ?? '').trim().toLowerCase();
    if (status == 'cancelled' ||
        status == 'canceled' ||
        status == 'expired' ||
        status == 'inactive') {
      return false;
    }

    return true;
  }

  void showCancelSubscriptionDialog() {
    if (!canCancelSubscription || isCancellingSubscription.value) return;

    BaseDialog.showAlertDialog(
      context: Get.context!,
      title: AppStrings.cancelSubscription,
      description: AppStrings.cancelPlaySubscriptionDesc,
      buttonLabel: AppStrings.manageInPlayStore,
      onButtonPressed: () {
        Get.back();
        cancelSubscription();
      },
    );
  }

  /// Open Google Play to cancel auto-renew. Do not mark cancelled locally until
  /// /me confirms after the user returns (they may abandon Play without cancelling).
  Future<void> cancelSubscription() async {
    if (!canCancelSubscription || isCancellingSubscription.value) return;

    isCancellingSubscription.value = true;
    try {
      final opened = await _openGooglePlaySubscriptions();
      _awaitingPlayCancelReturn = opened;
      if (!opened) {
        BaseSnackBar.show(
          title: AppLocalizations.of(Get.context!)!.error,
          message: AppStrings.subscriptionCancelFailed,
        );
      }
    } catch (e) {
      _awaitingPlayCancelReturn = false;
      log('Cancel subscription error: $e');
      BaseSnackBar.show(
        title: AppLocalizations.of(Get.context!)!.error,
        message: AppStrings.subscriptionCancelFailed,
      );
    } finally {
      isCancellingSubscription.value = false;
    }
  }

  Future<bool> _openGooglePlaySubscriptions() async {
    try {
      const packageName = 'com.gardenova.digisoft';
      final current = currentSubscriptionStatusModel.value;
      // Prefer Google Play product id for the subscriptions deep link.
      final playSku = (current?.productId ?? current?.planCode ?? current?.id ?? '')
          .trim()
          .toLowerCase()
          .replaceFirst('_yearly', '_annual');
      final uri = playSku.isNotEmpty
          ? Uri.parse(
              'https://play.google.com/store/account/subscriptions?sku=$playSku&package=$packageName',
            )
          : Uri.parse('https://play.google.com/store/account/subscriptions?package=$packageName');

      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        BaseSnackBar.show(
          title: AppLocalizations.of(Get.context!)!.error,
          message: 'Unable to open Google Play subscriptions.',
        );
        return false;
      }
      return true;
    } catch (e) {
      log('Open Play subscriptions error: $e');
      BaseSnackBar.show(
        title: AppLocalizations.of(Get.context!)!.error,
        message: 'Unable to open Google Play subscriptions.',
      );
      return false;
    }
  }

  // Razorpay persist helper kept for legacy data, but purchase flow is disabled.
  void persistRazorpaySubscriptionId(String? subscriptionId) {
    if (subscriptionId == null || subscriptionId.trim().isEmpty) return;

    SharedPrefsService.instance.setString(AppKeys.razorpaySubscriptionId, subscriptionId.trim());

    final current = currentSubscriptionStatusModel.value;
    if (current == null) return;

    currentSubscriptionStatusModel.value = SubscriptionStatusUiModel(
      id: subscriptionId.trim(),
      name: current.name,
      price: current.price,
      currency: current.currency,
      description: current.description,
      status: current.status,
      createdAt: current.createdAt,
      updatedAt: current.updatedAt,
      trialDays: current.trialDays,
      isAutoRenew: current.isAutoRenew,
      isTrialActive: current.isTrialActive,
      isActive: current.isActive,
      billingCycle: current.billingCycle,
      cancelAtPeriodEnd: current.cancelAtPeriodEnd,
      planCode: current.planCode,
      pendingPlanCode: current.pendingPlanCode,
      pendingPlanName: current.pendingPlanName,
      pendingBillingCycle: current.pendingBillingCycle,
      pendingEffectiveAt: current.pendingEffectiveAt,
      adFree: current.adFree,
    );
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
    Utils.hideKeyboard();
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

    ApiRepository.instance.showLoader();
    await Future<void>.delayed(Duration.zero);

    dynamic response;
    try {
      response = await profileRepository.updateProfile(
        updateProfileReq: updateProfileResponse,
        showDefaultLoader: false,
      );

      if (response != null) {
        _persistLocalProfile();
        await getProfileDetail();
      } else {
        profileImage.value = '';
        imageFile.value = File('');
        if (apiImage.isNotEmpty) {
          profileImage.value = apiImage;
          profileImage.refresh();
        }
      }
    } finally {
      ApiRepository.instance.hideLoader();
    }

    Utils.hideKeyboard();
    if (response != null) {
      if (isNewUserOtpLogin.value) {
        _completeNewUserOtpLoginNavigation();
        return;
      }
      await _showSuccessThenGoBack(
        (response is Map ? response['message'] : null)?.toString() ?? '',
      );
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
    Utils.hideKeyboard();
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
    ApiRepository.instance.showLoader();
    await Future<void>.delayed(Duration.zero);

    dynamic response;
    try {
      response = await profileRepository.updateProfessionalProfile(
        updateProfessionalProfileReq: map,
        showDefaultLoader: false,
      );
      if (response != null) {
        _persistLocalProfile();
        await getProfessionalProfileDetail(showloader: false);
      }
    } finally {
      ApiRepository.instance.hideLoader();
    }

    Utils.hideKeyboard();
    if (response != null) {
      await _showSuccessThenGoBack(
        (response is Map ? response['message'] : null)?.toString() ?? '',
      );
    }
  }

  void _persistLocalProfile() {
    final updatedName = nameController.text.trim();
    final updatedEmail = emailController.text.trim();
    if (updatedName.isNotEmpty) {
      name.value = updatedName;
      SharedPrefsService.instance.setString(AppKeys.name, updatedName);
    }
    if (updatedEmail.isNotEmpty) {
      email.value = updatedEmail;
      SharedPrefsService.instance.setString(AppKeys.email, updatedEmail);
    }
    name.refresh();
    email.refresh();
  }

  Future<void> _showSuccessThenGoBack(String message) async {
    Utils.hideKeyboard();
    final context = Get.context;
    BaseSnackBar.show(
      title: AppLocalizations.of(Get.context!)!.success,
      message: message,
    );
    await Future.delayed(const Duration(milliseconds: 700));
    if (context != null && context.mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showSuccessThenGoToProfile({
    required String title,
    required String message,
  }) async {
    Utils.hideKeyboard();
    Get.until((route) => route.settings.name == Routes.profile || route.isFirst);
    if (Get.currentRoute != Routes.profile) {
      Get.offNamed(Routes.profile);
    }
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    BaseSnackBar.show(title: title, message: message);
  }

  void updatePassword() async {
    var response = await profileRepository.changePassword(
      oldPasswordController.text,
      newPasswordController.text,
    );
    if (response == null || response is! Map) return;

    final apiMessage = response[ApiKeys.message]?.toString().trim();
    if (response[ApiKeys.success] != true) {
      BaseSnackBar.show(
        title: AppLocalizations.of(Get.context!)!.error,
        message: (apiMessage != null && apiMessage.isNotEmpty)
            ? apiMessage
            : AppStrings.somethingWentWrong,
      );
      return;
    }

    await _showSuccessThenGoToProfile(
      title: AppLocalizations.of(Get.context!)!.passwordChanged,
      message: (apiMessage != null && apiMessage.isNotEmpty)
          ? apiMessage
          : AppLocalizations.of(Get.context!)!.passwordChangedSuccessfully,
    );
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
      await SharedPrefsService.instance.setBool(AppKeys.emailLogedInUser, true);
      await _showSuccessThenGoToProfile(
        title: AppStrings.setPwd,
        message: AppLocalizations.of(Get.context!)!.passwordChangedSuccessfully,
      );
      isEmailLogedInUser.value = true;
    }
  }

  Future<void> callDeleteAccountApi() async {
    try {
      await ReminderPushNotificationService.instance.unregisterDeviceToken();
    } catch (e) {
      log('Failed to deregister FCM token before delete account: $e');
    }

    final response = await profileRepository.deleteAccount();
    if (response == null || response is! Map || response[ApiKeys.success] != true) {
      unawaited(ReminderPushNotificationService.instance.registerDeviceTokenIfNeeded());
      if (response == null || response is! Map) return;

      final apiMessage = response[ApiKeys.message]?.toString().trim();
      BaseSnackBar.show(
        title: AppLocalizations.of(Get.context!)!.error,
        message: (apiMessage != null && apiMessage.isNotEmpty)
            ? apiMessage
            : AppStrings.somethingWentWrong,
      );
      return;
    }

    final apiMessage = response[ApiKeys.message]?.toString().trim();
    final successTitle = AppLocalizations.of(Get.context!)!.success;
    final message = (apiMessage != null && apiMessage.isNotEmpty) ? apiMessage : successTitle;
    await Utils.logoutUser(deregisterRemote: false);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    BaseSnackBar.show(title: successTitle, message: message);
  }

  Future<void> sendEmailVerification() async {
    final String mail = emailController.text.trim();
    if (ValidationHelper.validateEmail(mail) != null) {
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
