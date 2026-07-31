import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base/dialogs/base_dialog.dart';
import '../../base/widgets/base_calculate_remaining_days.dart';
import '../../base/widgets/base_text.dart';
import '../../base/widgets/circular_bottom_app_bar.dart';
import '../../base/widgets/clickable_image.dart';
import '../../generated/assets.dart';
import '../../l10n/app_localizations.dart';
import '../../services/reminder_push_notification_service.dart';
import '../../settings/settings_view_model.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_keys.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/routes.dart';
import '../../utils/shared_prefs_service.dart';
import '../dashboard_repository.dart';

class FullScreenDrawer extends StatefulWidget {
  final bool isProfessional;
  final Function(int) onTap;

  const FullScreenDrawer({super.key, this.isProfessional = false, required this.onTap});

  @override
  State<FullScreenDrawer> createState() => _FullScreenDrawerState();
}

class _FullScreenDrawerState extends State<FullScreenDrawer> {
  DashboardRepository dashboardRepository = DashboardRepository();
  String storeLink = "";
  String courseLink = "";
  String websiteLink = "";
  bool isExternalLinkLoaded = false;

  @override
  void initState() {
    if (SharedPrefsService.instance.getString(AppKeys.role) != AppKeys.professional) {
      if (!isExternalLinkLoaded) {
        //    callGetExternalLinkApi();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: AppColors.appColor,
                child: SafeArea(
                  child: Column(
                    spacing: spacerSize20,
                    children: [
                      Container(
                        height: spacerSize80,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(spacerSize35),
                            bottomRight: Radius.circular(spacerSize35),
                          ),
                          color: AppColors.appColor,
                          // border: Border.all(color: AppColors.backgroundGrey),
                          // border: Border(
                          //   left: BorderSide(color: AppColors.backgroundGrey),
                          //   right: BorderSide(color: AppColors.backgroundGrey),
                          //   bottom: BorderSide(color: AppColors.backgroundGrey),
                          //   // top is intentionally removed
                          // ),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: spacerSize5,
                          children: [
                            SizedBox(width: spacerSize15),
                            // Center(child: Image.asset(AppAssets.appLogo)),
                            Obx(() {
                              final imageUrl = Get.isRegistered<SettingsViewModel>()
                                  ? Get.find<SettingsViewModel>().profileImage.value
                                  : "";

                              return Container(
                                width: 42.w,
                                height: 42.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: AppColors.backgroundGrey),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: ClickableImage(
                                    borderRadius: BorderRadius.circular(100),
                                    imageUrl: imageUrl,
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    heroTag: "profile_image_appbar_drawer",
                                    errorWidget: Image.asset(AppAssets.appLogo, fit: BoxFit.cover),
                                  ),
                                ),
                              );
                            }),
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BaseText(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppKeys.poppins,
                                    fontSize: fontSize14,
                                    // textColor: AppColors.offWhite,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text:
                                        '${AppLocalizations.of(Get.context!)!.hi}, ${SharedPrefsService.instance.getString(AppKeys.name) ?? ""}!',
                                  ),
                                  SharedPrefsService.instance.getString(AppKeys.role) ==
                                          AppKeys.professional
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: spacerSize10,
                                            vertical: spacerSize2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.toLiteGreenColor,
                                            borderRadius: BorderRadius.circular(spacerSize20),
                                          ),
                                          child: BaseText(
                                            text: () {
                                              final l10n =
                                                  AppLocalizations.of(Get.context!)!;
                                              final remaining =
                                                  SharedPrefsService.instance
                                                      .getString(AppKeys.remainingDays);
                                              if (BaseCalculateRemainingDays
                                                  .isZeroRemainingDays(remaining)) {
                                                return l10n.planExpiringToday;
                                              }
                                              return "$remaining\t${l10n.days}\t${l10n.left}";
                                            }(),
                                            fontSize: fontSize10,
                                            fontFamily: AppKeys.inter,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppColors.whiteColor,
                                          ),
                                        )
                                      : BaseText(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: AppKeys.inter,
                                          fontSize: fontSize12,
                                          textColor: AppColors.liteGreyColor,
                                          text: getGreeting(),
                                        ),
                                ],
                              ).marginOnly(left: spacerSize10),
                            ),
                            // Expanded(
                            //   flex: 4,
                            //   child: Align(
                            //     alignment: Alignment.centerRight,
                            //     child: IconButton(
                            //       style: IconButton.styleFrom(
                            //         padding: EdgeInsets.zero,
                            //         minimumSize: Size.zero,
                            //       ),
                            //       onPressed: () {
                            //         Get.back();
                            //       },
                            //       icon: Image.asset(
                            //         color: AppColors.greenColor,
                            //         Assets.imagesClose,
                            //         height: spacerSize20,
                            //         width: spacerSize20,
                            //       ).marginOnly(right: spacerSize30),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ).marginOnly(top: spacerSize20, bottom: spacerSize15),
                      ),

                      widget.isProfessional
                          ? Expanded(
                              child: ListView(
                                children: [
                                  drawerItem(
                                    title: AppLocalizations.of(context)!.myLeads,
                                    onTap: () {
                                      widget.onTap(0);
                                    },
                                  ),
                                  drawerItem(
                                    title:
                                        "${AppLocalizations.of(context)!.find}\t${AppLocalizations.of(context)!.professionals}",
                                    onTap: () {
                                      widget.onTap(1);
                                    },
                                  ),
                                  drawerItem(
                                    title: AppLocalizations.of(context)!.wholesaleSuppliers,
                                    onTap: () {
                                      widget.onTap(2);
                                    },
                                  ),
                                  drawerItem(
                                    showDivider: false,
                                    title: AppLocalizations.of(Get.context!)!.myProfile,
                                    onTap: () {
                                      widget.onTap(3);
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: ListView(
                                children: [
                                  drawerItem(
                                    title: AppLocalizations.of(Get.context!)!.home,
                                    onTap: () {
                                      widget.onTap(0);
                                    },
                                  ),
                                  // drawerItem(
                                  //   title: AppLocalizations.of(Get.context!)!.professionals,
                                  //   onTap: () {
                                  //     widget.onTap(1);
                                  //   },
                                  // ),
                                  drawerItem(
                                    title: AppLocalizations.of(Get.context!)!.store,
                                    onTap: () {
                                      // launchExternalUrl("https://loja.kasagardem.com.br/");
                                      BaseSnackBar.show(
                                        title: AppStrings.temporarilyUnavailable,
                                        message: AppStrings.storeOnHold,
                                      );
                                    },
                                  ),

                                  /* drawerItem(
                                      title: AppLocalizations.of(Get.context!)!.courses,
                                      onTap: () {
                                        launchExternalUrl(courseLink);
                                      },
                                    ),
                                    drawerItem(
                                      title: AppLocalizations.of(
                                        Get.context!,
                                      )!.siteKasagardem,
                                      onTap: () {
                                        launchExternalUrl(websiteLink);
                                      },
                                    ),*/
                                  drawerItem(
                                    title: AppLocalizations.of(Get.context!)!.myPlants,
                                    onTap: () {
                                      widget.onTap(6);
                                    },
                                  ),
                                  drawerItem(
                                    title: AppLocalizations.of(Get.context!)!.myProfile,
                                    onTap: () {
                                      widget.onTap(5);
                                    },
                                  ),
                                  drawerItem(
                                    title: AppLocalizations.of(Get.context!)!.settings,
                                    onTap: () {
                                      widget.onTap(7);
                                    },
                                  ),
                                  drawerItem(
                                    title: AppLocalizations.of(Get.context!)!.aboutApp,
                                    onTap: () {
                                      Get.back();
                                      Get.toNamed(Routes.aboutApp);
                                    },
                                  ),
                                  drawerItem(
                                    showDivider: false,
                                    title: AppLocalizations.of(Get.context!)!.logout,
                                    onTap: () {
                                      logout();
                                    },
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            // SafeArea(
            //   child: Visibility(
            //     child: Image.asset(
            //       Assets.backBtnDraweClose,
            //       height: 42.w,
            //       width:42.w,
            //     ),
            //   ),
            // )
            SizedBox(width: 32.w),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 15.h, right: 15.w),
                child: Image.asset(Assets.backBtnDraweClose, height: 42.w, width: 42.w),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> callGetExternalLinkApi() async {
    final response = await dashboardRepository.fetchExternalLink();

    if (response != null && response['success'] == true) {
      final data = response['data'];

      if (data != null && data['links'] != null) {
        final links = data['links'];
        websiteLink = links['Website']?['url'] ?? "";
        courseLink = links['Courses']?['url'] ?? "";
        storeLink = links['Store']?['url'] ?? "";
        isExternalLinkLoaded = true;
        setState(() {});
      }
      debugPrint("websiteLink:::$websiteLink\n:::$courseLink\n:::$storeLink");
    }
  }

  Widget drawerItem({required String title, required VoidCallback onTap, bool showDivider = true}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: spacerSize25, vertical: spacerSize1),
          title: BaseText(
            fontFamily: AppKeys.poppins,
            fontWeight: FontWeight.w500,
            fontSize: fontSize18,
            // textColor: AppColors.offWhite,
            text: title,
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            color: AppColors.backgroundGrey,
            thickness: 1,
            height: 1,
            indent: spacerSize12,
            endIndent: spacerSize12,
          ),
      ],
    );
  }

  Future<void> launchExternalUrl(String url) async {
    try {
      if (url.trim().isEmpty) {
        debugPrint("URL is empty");
        return;
      }

      final cleanUrl = url.split(':::').first.trim();

      final Uri uri = Uri.parse(cleanUrl.startsWith('http') ? cleanUrl : 'https://$cleanUrl');

      debugPrint("Opening URL ::: $uri");

      final bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!launched) {
        debugPrint("Could not launch $uri");
      }
    } catch (e) {
      debugPrint("Launch URL Error: $e");
    }
  }

  void logout() {
    BaseDialog.showAlertDialog(
      context: Get.context!,
      buttonLabel: AppLocalizations.of(Get.context!)!.confirm,
      title: AppLocalizations.of(Get.context!)!.logout,
      description: AppLocalizations.of(Get.context!)!.areYouSureYouWantToLogout,
      onButtonPressed: () async {
        await ReminderPushNotificationService.instance.onUserLogout();
        SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, false);
        SharedPrefsService.instance.clear();
        SharedPrefsService.instance.setString(AppKeys.role, AppKeys.user);
        Get.offAllNamed(Routes.login);
      },
    );
  }
}
