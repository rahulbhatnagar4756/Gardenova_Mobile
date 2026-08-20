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
                color: AppColors.offWhite,
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: widget.isProfessional
                          ? _buildProfessionalMenu()
                          : _buildUserMenu(),
                    ),
                  ],
                ),
              ),
            ),
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

  Widget _buildHeader() {
    final bool isProfessional =
        SharedPrefsService.instance.getString(AppKeys.role) == AppKeys.professional;
    final String userName = SharedPrefsService.instance.getString(AppKeys.name) ?? "";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.linearGradientForBtn,
        color: AppColors.greenColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => widget.onTap(isProfessional ? 3 : 5),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 22.h),
            child: Row(
              children: [
                Obx(() {
                  final imageUrl = Get.isRegistered<SettingsViewModel>()
                      ? Get.find<SettingsViewModel>().profileImage.value
                      : "";

                  return AbsorbPointer(
                    absorbing: true,
                    child: Container(
                      width: 56.w,
                      height: 56.w,
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle,
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
                    ),
                  );
                }),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BaseText(
                        fontWeight: FontWeight.w400,
                        fontFamily: AppKeys.inter,
                        fontSize: fontSize12,
                        textColor: AppColors.whiteColor.withValues(alpha: 0.8),
                        text: getGreeting(),
                      ),
                      SizedBox(height: 2.h),
                      BaseText(
                        fontWeight: FontWeight.w600,
                        fontFamily: AppKeys.poppins,
                        fontSize: fontSize16,
                        textColor: AppColors.whiteColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: '${AppLocalizations.of(Get.context!)!.hi}, $userName!',
                      ),
                      if (isProfessional) ...[
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacerSize10,
                            vertical: spacerSize3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(spacerSize20),
                          ),
                          child: BaseText(
                            text: () {
                              final l10n = AppLocalizations.of(Get.context!)!;
                              final remaining = SharedPrefsService.instance.getString(
                                AppKeys.remainingDays,
                              );
                              if (BaseCalculateRemainingDays.isZeroRemainingDays(remaining)) {
                                return l10n.planExpiringToday;
                              }
                              return "$remaining\t${l10n.days}\t${l10n.left}";
                            }(),
                            fontSize: fontSize10,
                            fontFamily: AppKeys.inter,
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.whiteColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Icon(
                //   Icons.chevron_right_rounded,
                //   color: AppColors.whiteColor.withValues(alpha: 0.8),
                //   size: 22.w,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserMenu() {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
      children: [
        _menuCard(
          children: [
            drawerItem(
              icon: Icons.home_outlined,
              title: AppLocalizations.of(Get.context!)!.home,
              onTap: () => widget.onTap(0),
            ),
            drawerItem(
              icon: Icons.storefront_outlined,
              title: AppLocalizations.of(Get.context!)!.store,
              onTap: () {
                BaseSnackBar.show(
                  title: AppStrings.temporarilyUnavailable,
                  message: AppStrings.storeOnHold,
                );
              },
            ),
            drawerItem(
              icon: Icons.local_florist_outlined,
              title: AppLocalizations.of(Get.context!)!.myPlants,
              showDivider: false,
              onTap: () => widget.onTap(6),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _menuCard(
          children: [
            drawerItem(
              icon: Icons.person_outline,
              title: AppLocalizations.of(Get.context!)!.myProfile,
              onTap: () => widget.onTap(5),
            ),
            drawerItem(
              icon: Icons.settings_outlined,
              title: AppLocalizations.of(Get.context!)!.settings,
              onTap: () => widget.onTap(7),
            ),
            drawerItem(
              icon: Icons.info_outline,
              title: AppLocalizations.of(Get.context!)!.aboutApp,
              showDivider: false,
              onTap: () {
                Get.back();
                Get.toNamed(Routes.aboutApp);
              },
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _menuCard(
          children: [
            drawerItem(
              icon: Icons.logout_outlined,
              title: AppLocalizations.of(Get.context!)!.logout,
              isDestructive: true,
              showDivider: false,
              onTap: logout,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfessionalMenu() {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
      children: [
        _menuCard(
          children: [
            drawerItem(
              icon: Icons.assignment_outlined,
              title: AppLocalizations.of(context)!.myLeads,
              onTap: () => widget.onTap(0),
            ),
            drawerItem(
              icon: Icons.person_search_outlined,
              title:
                  "${AppLocalizations.of(context)!.find}\t${AppLocalizations.of(context)!.professionals}",
              onTap: () => widget.onTap(1),
            ),
            drawerItem(
              icon: Icons.local_shipping_outlined,
              title: AppLocalizations.of(context)!.wholesaleSuppliers,
              showDivider: false,
              onTap: () => widget.onTap(2),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _menuCard(
          children: [
            drawerItem(
              icon: Icons.person_outline,
              title: AppLocalizations.of(Get.context!)!.myProfile,
              showDivider: false,
              onTap: () => widget.onTap(3),
            ),
          ],
        ),
      ],
    );
  }

  Widget _menuCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
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

  Widget drawerItem({
    required String title,
    required VoidCallback onTap,
    required IconData icon,
    Color? iconColor,
    bool showDivider = true,
    bool isDestructive = false,
  }) {
    final Color resolvedIconColor = isDestructive
        ? AppColors.red
        : (iconColor ?? AppColors.greenColor);
    final Color resolvedIconBg = isDestructive
        ? AppColors.red.withValues(alpha: 0.1)
        : AppColors.greenColor.withValues(alpha: 0.1);
    final Color resolvedTitleColor = isDestructive ? AppColors.red : AppColors.blackColor;
    final Color resolvedChevronColor = isDestructive
        ? AppColors.red.withValues(alpha: 0.5)
        : AppColors.liteGreyColor;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: resolvedIconBg,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(icon, color: resolvedIconColor, size: 20.w),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: BaseText(
                      fontFamily: AppKeys.poppins,
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize15,
                      textColor: resolvedTitleColor,
                      text: title,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: resolvedChevronColor,
                    size: 12.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            color: AppColors.backgroundGrey,
            thickness: 1,
            height: 1,
            indent: 68.w,
            endIndent: 14.w,
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
