import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/register/register_request_model.dart';
import 'package:kasagardem/authentication/social_sign_in_mixin.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/routes.dart';

import '../../utils/utils.dart';

class RegisterViewModel extends GetxController with SocialSignInMixin {
  RxBool isPasswordObscure = true.obs;
  RxBool isUserAgreedToTerms = false.obs;
  RxBool isShowLoader = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ScrollController scrollController = ScrollController();

  RxString selectedQuestion = "".obs;

  final formKey = GlobalKey<FormState>();

  Future<void> registerUser() async {
    isShowLoader.value = true;
    RegisterRequestModel? requestModel = RegisterRequestModel()
      ..email = emailController.text
      ..name = nameController.text
      ..password = passwordController.text
      //..roleId = '68ac33faca7a643664a24f59'
      ..roleCode = userRoleCode
      ..phoneNumber = phoneNoController.text;

    var registerResponse = await authRepository.registerUser(
      registerReq: requestModel,
    );
    isShowLoader.value = false;
    if (registerResponse != null) {
      registerSuccessDialog();
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    scrollController.dispose();
  }

  registerSuccessDialog() {
    return BaseDialog.showFullScreenDialog(
      Get.context!,
      dialogTitle: AppLocalizations.of(Get.context!)!.success,
      dialogDescription: AppLocalizations.of(
        Get.context!,
      )!.yourAccountHasBeenCreated,
      buttonLabel: AppLocalizations.of(Get.context!)!.backToLogin,
      onButtonPressed: () {
        Navigator.pushNamedAndRemoveUntil(
          Get.context!,
          Routes.login,
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  onCheckTermsAndCondition() {
    isUserAgreedToTerms.value = !isUserAgreedToTerms.value;
  }


}
