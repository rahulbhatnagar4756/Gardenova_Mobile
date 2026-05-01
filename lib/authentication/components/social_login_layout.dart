import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kasagardem/authentication/login/login_view_model.dart';
import 'package:kasagardem/authentication/register/register_view_model.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class SocialLoginLayout extends StatelessWidget {
  final LoginViewModel? loginController;
  final RegisterViewModel? registerController;
  final String type;

  const SocialLoginLayout({
    super.key,
    this.loginController,
    this.registerController,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Platform.isIOS ? spacerSize4 : spacerSize20,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        socialLoginIcons(
          AppLocalizations.of(context)!.google,
          AppAssets.googleIcon,
        ),
        socialLoginIcons(
          AppLocalizations.of(context)!.facebook,
          AppAssets.facebookIcon,
        ),
        if (Platform.isIOS)
          socialLoginIcons(
            AppLocalizations.of(context)!.apple,
            AppAssets.appleIcon,
          ),
      ],
    );
  }

  socialLoginIcons(String socialLoginText, String appAsset) {
    return InkWell(
      onTap: () {
        if (type == AppStrings.login) {
          if (socialLoginText == AppStrings.google) {
            loginController!.signInWithGoogle(
              loginController!.registerGoogleToken,
            );
          } else if (socialLoginText == AppStrings.apple) {
            loginController!.signInWithApple(
              loginController!.registerAppleToken,
            );
          } else {
            loginController!.signInWithFacebook(
              loginController!.registerFacebookToken,
            );
          }
        }
      },
      child: Container(
        width: spacerSize115,
        padding: EdgeInsets.symmetric(
          vertical: spacerSize10,
          horizontal: spacerSize14,
        ),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(spacerSize10),
          border: Border.all(color: AppColors.offWhite),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: spacerSize2,
          children: [
            Image.asset(appAsset, scale: 3),
            BaseText(
              text: socialLoginText,
              fontSize: fontSize12,
              fontWeight: FontWeight.w400,
              textColor: AppColors.mediumGrey,
            ),
          ],
        ),
      ),
    );
  }
}
