import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    super.key,
    this.isAppIconVisible = true,
    this.isBackButtonVisible = true,
    this.onBackPressed,
    this.backgroundColor = AppColors.appColor,
    this.title,
    this.toolbarHeightScale = 1.3,
    this.isTrailingButtonVisible = false,
    this.topMargin = spacerSize10,
  });

  final bool? isAppIconVisible;
  final bool? isBackButtonVisible;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final String? title;
  final num? toolbarHeightScale;
  final bool? isTrailingButtonVisible;
  final double? topMargin;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: AppColors.offWhite,
      elevation: 0.0,
      actionsIconTheme: const IconThemeData(color: AppColors.offWhite),
      actions: isTrailingButtonVisible!
          ? [
              PopupMenuButton(
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                popUpAnimationStyle: AnimationStyle.noAnimation,
                offset: const Offset(0, kToolbarHeight * -0.5),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    padding: EdgeInsets.all(spacerSize10),
                    onTap: () {
                      Get.toNamed(Routes.profile);
                    },
                    child: BaseText(
                      text: AppLocalizations.of(context)!.editProfile,
                      fontSize: fontSize13,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.offWhite,
                    ).marginOnly(right: spacerSize10, bottom: spacerSize10),
                  ),
                ],
              ).marginOnly(right: spacerSize10),
            ]
          : [],
      title: title != null
          ? BaseText(
              text: title ?? "",
              overflow: TextOverflow.ellipsis,
              textColor: AppColors.offWhite,
              fontWeight: FontWeight.w500,
              fontFamily: AppKeys.inter,
              fontSize: fontSize16,
            )
          : SizedBox(),
      titleSpacing: spacerSize0,
      centerTitle: false,
      leading: isBackButtonVisible!
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Get.back(result: true),
            )
          : null,
      flexibleSpace: isAppIconVisible!
          ? Image.asset(AppAssets.appLogo, scale: 2.8)
          : const SizedBox(),
      forceMaterialTransparency: true,
      automaticallyImplyLeading: isBackButtonVisible!,
    ).paddingOnly(top: topMargin!);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * toolbarHeightScale!);
}
