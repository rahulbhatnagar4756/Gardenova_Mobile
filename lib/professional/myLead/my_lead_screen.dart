import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_back_button.dart';
import 'package:kasagardem/professional/myLead/my_lead_controller.dart';

import '../../base/widgets/base_text.dart';
import '../../base/widgets/base_text_field.dart';
import '../../base/widgets/circular_bottom_app_bar.dart';
import '../../dashboard/components/full_drawer.dart';
import '../../generated/assets.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_keys.dart';
import 'components/lead_card_item.dart';
import 'components/lead_matric_card.dart';

class MyLeadScreen extends GetWidget<MyLeadController> {
  const MyLeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
          preferredSize: Size.fromHeight(spacerSize80),
          child : Builder(
            builder: (context) {
              return CircularBottomAppBar(
                showMenuIcon: true,
                onSettingPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          )),
      backgroundColor: AppColors.appColor,
      drawer: FullScreenDrawer(
        isProfessional: true,
        onTap: (index) {
          controller.navigateToNext(index);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.callGetMyLeadListApi();
        },
        child: Column(
          children: [
            titleWithSearch(context),
            Expanded(child: LeadCardItem(controller: controller)),
            BaseBackButton().marginOnly(bottom: spacerSize15),
          ],
        ),
      ),
    );
  }

  Widget titleWithSearch(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacerSize15),
        child: Column(
          spacing: spacerSize10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeadMatricCard(controller: controller),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BaseText(
                  text: AppLocalizations.of(context)!.myLeads,
                  textAlign: TextAlign.center,
                  fontFamily: AppKeys.merriweather,
                  textColor: AppColors.offWhite,
                  fontSize: fontSize20,
                  fontWeight: FontWeight.w500,
                ),
                InkWell(
                  onTap: () => controller.onTabSearch(),
                  child: Container(
                    padding: EdgeInsets.all(spacerSize10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.lightGold, AppColors.burntGold],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(spacerSize8),
                    ),
                    child: Image.asset(
                      Assets.imagesSearch,
                      height: spacerSize18,
                      width: spacerSize18,
                    ),
                  ),
                ),
              ],
            ).marginOnly(top: spacerSize10),
            BaseText(
              text: AppLocalizations.of(context)!.myLeadsDesc,
              fontFamily: AppKeys.inter,
              textColor: AppColors.offWhite70,
              fontSize: fontSize14,
              fontWeight: FontWeight.w400,
            ).marginOnly(bottom: spacerSize10),
            Visibility(
              visible: controller.isTabSearch.value,
              child: BaseTextField(
                textEditingController: controller.searchController,
                hintText: AppLocalizations.of(context)!.search,
                hintColor: AppColors.offWhite70,
                prefixIcon: Icon(Icons.search, color: AppColors.amberGold),
                onChanged: (value) {
                  if (value.isEmpty) {
                    controller.pageNumber.value = 1;
                  }
                  controller.isSearching.value = true;
                  controller.debouncer.call(
                    () => controller.callGetMyLeadListApi(searchName: value),
                  );
                  controller.isSearching.value = false;
                },
              ).marginOnly(bottom: spacerSize16),
            ),
          ],
        ),
      ),
    );
  }
}
