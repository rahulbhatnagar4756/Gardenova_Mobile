import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/subscription/subscription_navigation.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';

enum SubscriptionDialogType { trialEnded, upgrade, freshPurchase }

class CommonSubscriptionsDialog {
  /// Shows a subscription dialog based on the subscription status
  static void show({
    required BuildContext context,
    required SubscriptionDialogType dialogType,
    VoidCallback? onUpgradeSuccess,
  }) {
    final locale = Get.locale?.languageCode ?? 'en';

    String title;
    String description;
    String buttonLabel;

    switch (dialogType) {
      case SubscriptionDialogType.trialEnded:
        title = locale == 'pt' ? 'Teste Gratuito Expirado' : 'Free Trial Ended';
        description = locale == 'pt'
            ? 'Seu período de teste gratuito terminou. Adquira um plano de assinatura para continuar usando esta funcionalidade premium.'
            : 'Your free trial period has ended. Please purchase a subscription plan to continue using this premium feature.';
        buttonLabel = locale == 'pt' ? 'Ver Planos' : 'Upgrade Now';
        break;
      case SubscriptionDialogType.upgrade:
        title = locale == 'pt' ? 'Assinatura Inativa' : 'Subscription Inactive';
        description = locale == 'pt'
            ? 'Sua assinatura está inativa ou foi cancelada. Adquira ou renove seu plano para continuar usando esta funcionalidade premium.'
            : 'Your subscription is currently inactive or has been cancelled. Please purchase or renew a plan to continue using this premium feature.';
        buttonLabel = locale == 'pt' ? 'Renovar Assinatura' : 'Renew Plan';
        break;
      case SubscriptionDialogType.freshPurchase:
        title = locale == 'pt'
            ? 'Assinatura Necessária'
            : 'Subscription Required';
        description = locale == 'pt'
            ? 'Para acessar esta funcionalidade premium, escolha e adquira um plano de assinatura.'
            : 'To access this premium feature, please choose and purchase a subscription plan.';
        buttonLabel = locale == 'pt' ? 'Ver Planos' : 'Choose Plan';
        break;
    }

    final String cancelLabel = locale == 'pt' ? 'Agora Não' : 'Not Now';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: spacerSize24),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(spacerSize24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Top-right close icon
              Positioned(
                right: 8.w,
                top: 8.h,
                child: CommonClickWidget(
                  onTap: () => Get.back(),
                  child: Padding(
                    padding: EdgeInsets.all(spacerSize8),
                    child: Image.asset(
                      AppAssets.closeIc,
                      color: AppColors.liteGreyColor.withValues(alpha: 0.5),
                      width: 20.w,
                      height: 20.w,
                    ),
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: EdgeInsets.only(
                  left: spacerSize24,
                  right: spacerSize24,
                  top: spacerSize35,
                  bottom: spacerSize24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Premium Crown Icon Container
                    Container(
                      width: 60.w,
                      height: 60.w,
                      padding: EdgeInsets.all(spacerSize12),
                      decoration: BoxDecoration(
                        color: AppColors.greenColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        AppAssets.crownIc,
                        color: AppColors.greenColor,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: spacerSize18),
                    BaseText(
                      text: title,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppKeys.poppins,
                      fontSize: fontSize18,
                      textColor: AppColors.blackColor,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacerSize10),
                    BaseText(
                      text: description,
                      textColor: AppColors.liteGreyColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppKeys.inter,
                      fontSize: fontSize13,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacerSize24),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: BaseButton(
                            onPressed: () {
                              Get.back();
                              Get.toNamed(
                                SubscriptionNavigation.upgradeRoute,
                                arguments: {
                                  AppKeys.screenType: AppKeys.dashboard,
                                },
                              )!.then((val) {
                                if (val == true) {
                                  onUpgradeSuccess?.call();
                                }
                              });
                            },
                            backgroundColor: AppColors.greenColor,
                            buttonLabel: buttonLabel,
                            fontSize: fontSize14,
                            textColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: spacerSize10),
                        CommonClickWidget(
                          onTap: () => Get.back(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: spacerSize6,
                            ),
                            child: BaseText(
                              text: cancelLabel,
                              textColor: AppColors.liteGreyColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppKeys.inter,
                              fontSize: fontSize13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
