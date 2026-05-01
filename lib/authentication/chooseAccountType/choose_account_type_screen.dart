import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/generated/assets.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

import '../../base/widgets/base_app_bar.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_keys.dart';
import '../../utils/routes.dart';
import '../components/header_logo_layout.dart';

class ChooseAccountTypeScreen extends StatefulWidget {
  const ChooseAccountTypeScreen({super.key});

  @override
  State<ChooseAccountTypeScreen> createState() =>
      _ChooseAccountTypeScreenState();
}

class _ChooseAccountTypeScreenState extends State<ChooseAccountTypeScreen> {
  String selectedType = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: const BaseAppBar(
        isAppIconVisible: false,
        isBackButtonVisible: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: spacerSize12,
            children: [
              HeaderLogoLayout(
                title:
                    "${AppLocalizations.of(context)!.welcome}\t${AppLocalizations.of(context)!.back.capitalizeFirst}!",
                subTitle: AppLocalizations.of(
                  context,
                )!.howWouldYouLikeToContinue,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacerSize60),
                child: accountCard(
                  title: AppLocalizations.of(context)!.client,
                  subtitle: AppLocalizations.of(context)!.userDescription,
                  icon: Assets.imagesUser,
                  value: AppKeys.user,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacerSize60),
                child: accountCard(
                  title: AppLocalizations.of(context)!.professional,
                  subtitle: AppLocalizations.of(
                    context,
                  )!.professionalDescription,
                  icon: Assets.imagesProfessional,
                  value: AppKeys.professional,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget accountCard({
    required String title,
    required String subtitle,
    required String icon,
    required String value,
  }) {
    final bool isSelected = selectedType == value;
    return GestureDetector(
      onTap: () {
        selectedType = value;
        setState(() {});
        SharedPrefsService.instance.setString(AppKeys.role, value);
        Get.toNamed(Routes.login);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.appColor,
          borderRadius: BorderRadius.circular(spacerSize16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.borderGold,
                    blurRadius: 5,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: spacerSize25,
            vertical: spacerSize25,
          ),
          decoration: BoxDecoration(
            color: AppColors.appBarColor,
            borderRadius: BorderRadius.circular(spacerSize16),
            border: Border.all(
              color: isSelected ? AppColors.darkGold : AppColors.borderWhite,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.offWhite10,
                radius: spacerSize24,
                child: Image.asset(
                  icon,
                  height: spacerSize18,
                  width: spacerSize18,
                ),
              ).marginOnly(bottom: spacerSize14),

              BaseText(
                textAlign: TextAlign.center,
                textColor: AppColors.offWhite,
                fontWeight: FontWeight.w500,
                fontFamily: AppKeys.poppins,
                fontSize: fontSize20,
                text: title,
              ).marginOnly(bottom: spacerSize5),

              BaseText(
                textAlign: TextAlign.center,
                textColor: AppColors.offWhite70,
                fontWeight: FontWeight.w400,
                fontFamily: AppKeys.inter,
                fontSize: fontSize15,
                text: subtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
