import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/generated/assets.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

import '../../base/widgets/base_app_bar.dart';
import '../../base/widgets/base_button.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants/app_assets.dart';
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
  String selectedType = AppKeys.user;

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

              accountCard(
                title: AppLocalizations.of(context)!.client,
                subtitle: AppLocalizations.of(context)!.userDescription,
                icon: Assets.imagesUser,
                value: AppKeys.user,
              ),

              accountCard(
                title: AppLocalizations.of(context)!.professional,
                subtitle: AppLocalizations.of(context)!.professionalDescription,
                icon: Assets.imagesProfessional,
                value: AppKeys.professional,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: continueBtn(selectedType: selectedType),
    );
  }

  Widget continueBtn({required String selectedType}) {
    return Container(
      padding: EdgeInsets.only(bottom: 25.h,left:20.w,right: 20.w ),
      width: double.infinity,
      child: BaseButton(
        textColor: AppColors.offWhite,
        buttonLabel: AppLocalizations.of(context)!.continueText,
        onPressed: () {
          SharedPrefsService.instance.setString(AppKeys.role, selectedType);
          Get.toNamed(Routes.login);
        },
      ).marginOnly(top: spacerSize25),
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
      },
      child: Container(
        margin: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 5.h),
        decoration: BoxDecoration(
          color: AppColors.appColor,
          borderRadius: BorderRadius.circular(spacerSize16),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding:  EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical:  15.w,
          ),
          decoration: BoxDecoration(
              color: AppColors.greenColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(spacerSize16),
            border: Border.all(
              color: AppColors.greenColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.greenColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.r))
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.w),
                child: Image.asset(
                  icon,
                  height: 18.w,
                  width: 20.h,
                  color: Colors.white,
                ),
              ),

              SizedBox(width: 10.w,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppKeys.poppins,
                      fontSize: 14.sp,
                      text: title,
                    ).marginOnly(bottom: spacerSize5),

                    BaseText(
                      textColor: AppColors.liteGreyColor,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppKeys.poppins,
                      fontSize: 14.sp,
                      text: subtitle,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w,),
              Image.asset(
                isSelected
                    ? AppAssets.selectedRadioIc
                    : AppAssets.unSelectedRadioIc,
                width: 24.w,
                height: 24.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
