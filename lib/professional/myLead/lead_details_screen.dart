import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/l10n/app_localizations.dart';

import '../../base/widgets/base_app_bar.dart';
import '../../base/widgets/base_date_format.dart';
import '../../base/widgets/base_text.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_keys.dart';
import 'model/my_lead_model.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen({super.key});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  LeadModel? leadData;

  @override
  void initState() {
    if (Get.arguments != null) {
      leadData = Get.arguments;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(isBackButtonVisible: true),
      backgroundColor: AppColors.appColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: spacerSize20,
          vertical: spacerSize10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseText(
              text: "${AppLocalizations.of(context)!.companyDetails}:",
              textAlign: TextAlign.center,
              fontFamily: AppKeys.merriweather,
              textColor: AppColors.offWhite,
              fontSize: fontSize20,
              fontWeight: FontWeight.w500,
            ).marginOnly(top: spacerSize10, bottom: spacerSize10),

            Container(
              padding: EdgeInsets.symmetric(horizontal: spacerSize10),
              margin: EdgeInsets.only( bottom: spacerSize10),
              decoration: BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(spacerSize12),
                border: Border.all(color: AppColors.offWhite10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildItem(
                    "${AppLocalizations.of(context)!.name}:",
                    leadData!.companyName ?? "",
                  ),
                  buildItem(
                    "${AppLocalizations.of(context)!.email}:",
                    leadData!.email ?? "",
                  ),
                  buildItem(
                    "${AppLocalizations.of(context)!.role}:",
                    leadData!.role ?? "",
                  ),
                  buildItem(
                    "${AppLocalizations.of(context)!.leadStatus}:",
                    leadData!.leadsStatus ?? "",
                  ),
                  buildItem(
                    "${AppLocalizations.of(context)!.date}:",
                    BaseDateTimeFormat.format(
                      dateTime: leadData!.createdAt ?? "",
                      format: "MMM dd, yyyy",
                    ),
                  ),
                ],
              ),
            ),
            if(leadData!.location!.address!=null)
            BaseText(
              text: "${AppLocalizations.of(context)!.location}:",
              textAlign: TextAlign.center,
              fontFamily: AppKeys.merriweather,
              textColor: AppColors.offWhite,
              fontSize: fontSize20,
              fontWeight: FontWeight.w500,
            ).marginOnly(top: spacerSize10, bottom: spacerSize10),

            if(leadData!.location!.address!=null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: spacerSize10),
              decoration: BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(spacerSize12),
                border: Border.all(color: AppColors.offWhite10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildItem(
                    "${AppLocalizations.of(context)!.city}:",
                    leadData!.location?.city ?? "",
                  ),
                  buildItem(
                    "${AppLocalizations.of(context)!.state}:",
                    leadData!.location?.state ?? "",
                  ),
                  buildItem(
                    "${AppLocalizations.of(context)!.address}:",
                    leadData!.location?.address ?? "",
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(spacerSize10),
              margin: EdgeInsets.only(bottom:spacerSize10),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(spacerSize12),
                border: Border.all(color: AppColors.offWhite10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    text: "${AppLocalizations.of(context)!.description}:",
                    fontFamily: AppKeys.merriweather,
                    textColor: AppColors.offWhite,
                    fontSize: fontSize20,
                    fontWeight: FontWeight.w500,
                  ),
                  BaseText(
                    text: leadData!.requestingUser!.description ?? "",
                    fontFamily: AppKeys.inter,
                    textColor: AppColors.offWhite70,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(spacerSize10),
              margin: EdgeInsets.only(bottom:spacerSize10),

              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(spacerSize12),
                border: Border.all(color: AppColors.offWhite10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    text: "${AppLocalizations.of(context)!.serviceRequested}:",
                    fontFamily: AppKeys.merriweather,
                    textColor: AppColors.offWhite,
                    fontSize: fontSize20,
                    fontWeight: FontWeight.w500,
                  ).marginOnly(top: spacerSize10, bottom: spacerSize10),
                  BaseText(
                    text: leadData!.requestingUser!.category ?? "",
                    fontFamily: AppKeys.inter,
                    textColor: AppColors.offWhite70,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(spacerSize10),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(spacerSize12),
                border: Border.all(color: AppColors.offWhite10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    text: "${AppLocalizations.of(context)!.sizeOfTheArea}:",
                    fontFamily: AppKeys.merriweather,
                    textColor: AppColors.offWhite,
                    fontSize: fontSize20,
                    fontWeight: FontWeight.w500,
                  ).marginOnly(top: spacerSize10, bottom: spacerSize10),
                  BaseText(
                    text: leadData!.requestingUser!.size ?? "",
                    fontFamily: AppKeys.inter,
                    textColor: AppColors.offWhite70,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),




          ],
        ),
      ),
    );
  }

  Widget buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: spacerSize10),
      child: Row(
        spacing: spacerSize10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: title,
            textAlign: TextAlign.center,
            fontFamily: AppKeys.inter,
            textColor: AppColors.offWhite,
            fontSize: fontSize14,
            fontWeight: FontWeight.w500,
          ),
          Expanded(
            child: BaseText(
              text: value.isEmpty ? "-" : value,
              fontFamily: AppKeys.inter,
              textColor: AppColors.offWhite70,
              fontSize: fontSize14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
