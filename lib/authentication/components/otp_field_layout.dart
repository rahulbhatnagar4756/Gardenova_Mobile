import 'package:flutter/material.dart';
import 'package:kasagardem/authentication/forgotPassword/forgot_password_view_model.dart';
import 'package:kasagardem/base/widgets/base_form.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:pinput/pinput.dart';

class OtpLayout extends StatelessWidget {
  const OtpLayout({super.key, this.forgotPasswordViewModel});

  final ForgotPasswordViewModel? forgotPasswordViewModel;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: spacerSize75,
      height: spacerSize55,
      textStyle: TextStyle(color: AppColors.offWhite),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(spacerSize10),
        border: Border.all(color: AppColors.offWhite10),
      ),
    );
    return BaseForm(
      formKey: forgotPasswordViewModel!.verifyOtpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              controller: forgotPasswordViewModel!.pinController,
              length: 6,
              focusNode: forgotPasswordViewModel!.focusNode,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: spacerSize8),
              validator: (value) {
                return value != null && value.isNotEmpty
                    ? null
                    : AppLocalizations.of(context)!.incorrectCodePleaseTryAgain;
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {},
              onChanged: (value) {},
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: spacerSize10),
                    width: spacerSize24,
                    height: spacerSize1,
                    color: AppColors.burntGold,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(spacerSize10),
                  color: AppColors.darkGreen,
                  border: Border.all(color: AppColors.burntGold),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: AppColors.darkGreen,
                  borderRadius: BorderRadius.circular(spacerSize10),
                  border: Border.all(color: AppColors.burntGold),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
