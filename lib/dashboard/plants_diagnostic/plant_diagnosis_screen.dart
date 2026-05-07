import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/expansion_tile_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/plant_detail_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/plant_health_and_prevention_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/similar_plants_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/title_and_description_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_view_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import '../components/full_drawer.dart';
import '../views/diagnosis_error_view.dart';
import '../views/diagnosis_loading_view.dart';
import '../views/diagnosis_success_view.dart';
import '../views/no_plant_detected_view.dart';

// class PlantDiagnosisScreen extends GetWidget<PlantDiagnosisViewModel> {
//   const PlantDiagnosisScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appColor,
//       drawer: SizedBox(
//         // width: MediaQuery.of(context).size.width * 0.9,
//         child: FullScreenDrawer(
//           onTap: (index) {
//             controller.navigateToNext(index);
//           },
//         ),
//       ),
//       appBar: PreferredSize(
//         // preferredSize: Size.fromHeight(spacerSize80),
//         preferredSize: Size.fromHeight(110.h + 30.h),
//         child: Builder(
//           builder: (context) {
//             return CircularBottomAppBar(
//               isBackButtonVisible: true,
//               showMenuIcon: true,
//               onSettingPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//             );
//           },
//         ),
//       ),
//       body: Obx(
//         () => Stack(
//           children: [
//             SafeArea(
//               child:
//                   controller.plantDiagnosisResponse.value.data != null &&
//                       controller.isCurrentImagePlant.value
//                   ? CachedNetworkImage(
//                       imageUrl:
//                           controller.plantDiagnosisResponse.value.data != null
//                           ? controller
//                                 .plantDiagnosisResponse
//                                 .value
//                                 .data!
//                                 .plantInfo!
//                                 .images![0]
//                           : "",
//                       height: Get.height * .45,
//                       placeholder: (context, url) =>
//                           BaseShimmer(height: Get.height * .45),
//                       errorWidget: (context, url, error) {
//                         return BaseBorderedContainer(
//                           height: Get.height * .335,
//                           alignment: Alignment.center,
//                           padding: const EdgeInsets.all(spacerSize10),
//                           childWidget: Icon(
//                             Icons.broken_image_rounded,
//                             size: spacerSize40,
//                             color: AppColors.liteGreyColor,
//                           ),
//                         );
//                       },
//                       useOldImageOnUrlChange: true,
//                       width: Get.width,
//                       fit: BoxFit.fill,
//                     )
//                   : controller.isLoading.value
//                   ? BaseShimmer(
//                       borderRadious: 20,
//                     ).paddingSymmetric(horizontal: 20.w)
//                   : SizedBox(),
//             ),
//             // CircularBottomAppBar(
//             //   onSettingPressed: () {
//             //     Get.toNamed(Routes.settings);
//             //   },
//             // ),
//           ],
//         ),
//       ),
//       bottomSheet: BottomSheet(
//         backgroundColor: AppColors.appColor,
//         builder: (context) => Obx(
//           () => controller.isLoading.value
//               ? SizedBox()
//               : SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.55,
//                   width: Get.width,
//                   child: SingleChildScrollView(
//                     child:
//                         controller.isLoading.value == false &&
//                             controller.isCurrentImagePlant.value == false
//                         ? Center(
//                             child: BaseText(
//                               text: AppLocalizations.of(
//                                 context,
//                               )!.noPlantDataAvailable,
//                               fontSize: fontSize20,
//                               fontWeight: FontWeight.bold,
//                               textAlign: TextAlign.center,
//                               fontFamily: AppKeys.poppins,
//                             ),
//                           )
//                         : Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             spacing: spacerSize15,
//                             children: [
//                               PlantDetailLayout(
//                                 plantDiagnosisViewModel: controller,
//                               ),
//                               SimilarPlantsLayout(
//                                 plantDiagnosisViewModel: controller,
//                               ),
//
//                               TitleAndDescriptionLayout(
//                                 title: AppLocalizations.of(Get.context!)!.uses,
//                                 description:
//                                     controller
//                                             .plantDiagnosisResponse
//                                             .value
//                                             .data !=
//                                         null
//                                     ? controller
//                                           .plantDiagnosisResponse
//                                           .value
//                                           .data!
//                                           .plantInfo!
//                                           .uses
//                                     : "",
//                               ),
//                               TitleAndDescriptionLayout(
//                                 title: AppLocalizations.of(
//                                   Get.context!,
//                                 )!.toxicity,
//                                 description:
//                                     controller
//                                             .plantDiagnosisResponse
//                                             .value
//                                             .data !=
//                                         null
//                                     ? controller
//                                           .plantDiagnosisResponse
//                                           .value
//                                           .data!
//                                           .plantInfo!
//                                           .toxicity
//                                     : "",
//                               ),
//
//                               if (controller
//                                           .plantDiagnosisResponse
//                                           .value
//                                           .data!
//                                           .healthStatus!
//                                           .isHealthy ==
//                                       false &&
//                                   controller
//                                       .plantDiagnosisResponse
//                                       .value
//                                       .data!
//                                       .healthStatus!
//                                       .issues!
//                                       .isNotEmpty)
//                                 PlantHealthAndPreventionLayout(
//                                   plantDiagnosisViewModel: controller,
//                                 ),
//                               ExpansionTileLayout(
//                                 childWidget: diagnosisLayout(),
//                                 title: AppLocalizations.of(
//                                   Get.context!,
//                                 )!.kasagardemPlantDiagnosis,
//                               ),
//                             ],
//                           ),
//                   ).marginAll(spacerSize20),
//                 ),
//         ),
//         enableDrag: false,
//         onClosing: () {},
//       ),
//     );
//   }
//
//   diagnosisLayout() {
//     return Obx(
//       () => Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           TitleAndDescriptionLayout(
//             title: AppLocalizations.of(Get.context!)!.issue,
//             spacing: spacerSize5,
//             description: controller.issue.value,
//           ),
//           TitleAndDescriptionLayout(
//             title: AppLocalizations.of(Get.context!)!.automationFeature,
//             spacing: spacerSize5,
//             description: controller.automationFeature.value,
//           ),
//           TitleAndDescriptionLayout(
//             title: AppLocalizations.of(Get.context!)!.howItHelps,
//             spacing: spacerSize5,
//             description: controller.howItHelps.value,
//           ),
//           TitleAndDescriptionLayout(
//             title: AppLocalizations.of(Get.context!)!.benefits,
//             spacing: spacerSize5,
//             description: controller.benefits.value,
//           ),
//           TitleAndDescriptionLayout(
//             title: AppLocalizations.of(Get.context!)!.howToSetup,
//             spacing: spacerSize5,
//             description: controller.setup.value,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PlantDiagnosisScreen extends GetWidget<PlantDiagnosisViewModel> {
//   const PlantDiagnosisScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appColor,
//       body: Obx(() {
//         final data = controller.plantDiagnosisResponse.value.data;
//         final plant = data?.plantInfo;
//         final health = data?.healthStatus;
//         final issue = health?.issues?.isNotEmpty == true
//             ? health!.issues!.first
//             : null;
//
//         return CustomScrollView(
//           slivers: [
//             /// HERO IMAGE
//             SliverAppBar(
//               expandedHeight: 320.h,
//               pinned: true,
//               backgroundColor: AppColors.appColor,
//               leading: IconButton(
//                 onPressed: () => Get.back(),
//                 icon: const Icon(Icons.arrow_back_ios_new_rounded),
//               ),
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     CachedNetworkImage(
//                       imageUrl: plant?.images?.first ?? "",
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => BaseShimmer(height: 320.h),
//                       errorWidget: (context, url, error) =>
//                           const Icon(Icons.broken_image),
//                     ),
//
//                     Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.black.withValues(alpha: 0.1),
//                             Colors.black.withValues(alpha: 0.7),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     Positioned(
//                       left: 20,
//                       right: 20,
//                       bottom: 30,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 7,
//                             ),
//                             decoration: BoxDecoration(
//                               color: AppColors.greenColor,
//                               borderRadius: BorderRadius.circular(100),
//                             ),
//                             child: BaseText(
//                               text:
//                                   "${data?.confidence?.toStringAsFixed(0) ?? "0"}% AI Confidence",
//                               fontSize: fontSize12,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//
//                           SizedBox(height: 12.h),
//
//                           BaseText(
//                             text:
//                                 plant?.commonNames?.firstOrNull ??
//                                 "Unknown Plant",
//                             fontSize: fontSize26,
//                             fontWeight: FontWeight.w700,
//                             fontFamily: AppKeys.poppins,
//                           ),
//
//                           SizedBox(height: 4.h),
//
//                           BaseText(
//                             text: plant?.scientificName ?? "",
//                             fontSize: fontSize15,
//                             textColor: AppColors.liteGreyColor,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             /// BODY
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(spacerSize20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// HEALTH CARD
//                     _HealthScoreCard(
//                       health: health?.healthProbability?.toDouble() ?? 0,
//                       isHealthy: health?.isHealthy ?? false,
//                     ),
//
//                     SizedBox(height: 20.h),
//
//                     /// ISSUE CARD
//                     if (issue != null)
//                       _SectionCard(
//                         title: "Plant Diagnosis",
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _InfoRow(title: "Issue", value: issue.name ?? ""),
//                             _InfoRow(
//                               title: "Severity",
//                               value: issue.severity ?? "",
//                             ),
//                             _InfoRow(title: "Type", value: issue.type ?? ""),
//                           ],
//                         ),
//                       ),
//
//                     SizedBox(height: 20.h),
//
//                     /// DESCRIPTION
//                     _SectionCard(
//                       title: "Plant Description",
//                       child: BaseText(
//                         text: plant?.description ?? "",
//                         fontSize: fontSize14,
//                         textColor: AppColors.liteGreyColor,
//                       ),
//                     ),
//
//                     SizedBox(height: 20.h),
//
//                     /// CARE GUIDE
//                     _SectionTitle("Care Guide"),
//
//                     SizedBox(height: 12.h),
//
//                     GridView(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 14,
//                         crossAxisSpacing: 14,
//                         childAspectRatio: 1.5,
//                       ),
//                       children: [
//                         _CareTile(
//                           icon: Icons.water_drop_rounded,
//                           title: "Watering",
//                           value: plant?.careGuide?.watering ?? "",
//                         ),
//
//                         _CareTile(
//                           icon: Icons.sunny,
//                           title: "Light",
//                           value: plant?.careGuide?.lightCondition ?? "",
//                         ),
//
//                         _CareTile(
//                           icon: Icons.grass,
//                           title: "Soil",
//                           value: plant?.careGuide?.soilType ?? "",
//                         ),
//
//                         _CareTile(
//                           icon: Icons.health_and_safety_rounded,
//                           title: "Toxicity",
//                           value: plant?.toxicity ?? "",
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(height: 24.h),
//
//                     /// SYMPTOMS
//                     if (issue?.symptoms?.isNotEmpty == true)
//                       _SectionCard(
//                         title: "Symptoms",
//                         child: Wrap(
//                           spacing: 10,
//                           runSpacing: 10,
//                           children: issue!.symptoms!
//                               .map((e) => _ChipTile(label: e))
//                               .toList(),
//                         ),
//                       ),
//
//                     SizedBox(height: 20.h),
//
//                     /// TREATMENT
//                     if (issue?.treatment != null)
//                       _SectionCard(
//                         title: "Treatment Plan",
//                         child: Column(
//                           children: [
//                             ...issue!.treatment!.immediate!.map(
//                               (e) => _TreatmentStep(text: e),
//                             ),
//
//                             ...issue.treatment!.longTerm!.map(
//                               (e) => _TreatmentStep(text: e),
//                             ),
//
//                             ...issue.treatment!.prevention!.map(
//                               (e) => _TreatmentStep(text: e),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                     SizedBox(height: 30.h),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
//
// class _HealthScoreCard extends StatelessWidget {
//   final double health;
//   final bool isHealthy;
//
//   const _HealthScoreCard({required this.health, required this.isHealthy});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(spacerSize20),
//       decoration: BoxDecoration(
//         color: AppColors.toToLiteGreenColor,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: AppColors.greenColor),
//       ),
//       child: Row(
//         children: [
//           SizedBox(
//             height: 90,
//             width: 90,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   value: health / 100,
//                   strokeWidth: 8,
//                   backgroundColor: Colors.white12,
//                   valueColor: AlwaysStoppedAnimation(
//                     isHealthy ? AppColors.greenColor : Colors.orange,
//                   ),
//                 ),
//                 BaseText(
//                   text: "${health.toStringAsFixed(0)}%",
//                   fontWeight: FontWeight.bold,
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(width: 20.w),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 BaseText(
//                   text: isHealthy
//                       ? "Plant is Healthy"
//                       : "Plant Needs Attention",
//                   fontSize: fontSize18,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: AppKeys.poppins,
//                 ),
//
//                 SizedBox(height: 6.h),
//
//                 BaseText(
//                   text:
//                       "AI analyzed your plant condition and generated recommendations.",
//                   fontSize: fontSize13,
//                   textColor: AppColors.liteGreyColor,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _SectionCard extends StatelessWidget {
//   final String title;
//   final Widget child;
//
//   const _SectionCard({required this.title, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(spacerSize18),
//       decoration: BoxDecoration(
//         color: AppColors.toToLiteGreenColor,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: AppColors.greenColor.withValues(alpha: .4)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _SectionTitle(title),
//           SizedBox(height: 16.h),
//           child,
//         ],
//       ),
//     );
//   }
// }
//
// class _SectionTitle extends StatelessWidget {
//   final String title;
//
//   const _SectionTitle(this.title);
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseText(
//       text: title,
//       fontSize: fontSize18,
//       fontWeight: FontWeight.w700,
//       fontFamily: AppKeys.poppins,
//       textColor: AppColors.greenColor,
//     );
//   }
// }
//
// class _InfoRow extends StatelessWidget {
//   final String title;
//   final String value;
//
//   const _InfoRow({required this.title, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12.h),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: BaseText(text: title, fontWeight: FontWeight.w600),
//           ),
//           Expanded(
//             flex: 5,
//             child: BaseText(text: value, textColor: AppColors.liteGreyColor),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _CareTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;
//
//   const _CareTile({
//     required this.icon,
//     required this.title,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(spacerSize16),
//       decoration: BoxDecoration(
//         color: AppColors.toToLiteGreenColor,
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(color: AppColors.greenColor),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: AppColors.greenColor),
//
//           Spacer(),
//
//           BaseText(text: title, fontWeight: FontWeight.bold),
//
//           SizedBox(height: 6.h),
//
//           BaseText(
//             text: value,
//             fontSize: fontSize12,
//             textColor: AppColors.liteGreyColor,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ChipTile extends StatelessWidget {
//   final String label;
//
//   const _ChipTile({required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: AppColors.greenColor.withValues(alpha: .15),
//         borderRadius: BorderRadius.circular(100),
//       ),
//       child: BaseText(text: label, fontSize: fontSize13),
//     );
//   }
// }
//
// class _TreatmentStep extends StatelessWidget {
//   final String text;
//
//   const _TreatmentStep({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 16.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 10,
//             width: 10,
//             margin: EdgeInsets.only(top: 6.h),
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: AppColors.greenColor,
//             ),
//           ),
//
//           SizedBox(width: 12.w),
//
//           Expanded(
//             child: BaseText(text: text, textColor: AppColors.liteGreyColor),
//           ),
//         ],
//       ),
//     );
//   }
// }

import '../views/diagnosis_error_view.dart';
import '../views/diagnosis_loading_view.dart';
import '../views/diagnosis_success_view.dart';
import '../views/no_plant_detected_view.dart';

class PlantDiagnosisScreen extends GetWidget<PlantDiagnosisViewModel> {
  const PlantDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      drawer: SizedBox(
        // width: MediaQuery.of(context).size.width * 0.9,
        child: FullScreenDrawer(
          onTap: (index) {
            controller.navigateToNext(index);
          },
        ),
      ),
      appBar: PreferredSize(
        // preferredSize: Size.fromHeight(spacerSize80),
        preferredSize: Size.fromHeight(110.h + 30.h),
        child: Builder(
          builder: (context) {
            return CircularBottomAppBar(
              isBackButtonVisible: true,
              showMenuIcon: true,
              onSettingPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const DiagnosisLoadingView();
          }

          final response = controller.plantDiagnosisResponse.value;
          final data = response.data;

          /// API FAILED
          if (data == null) {
            return DiagnosisErrorView(
              message: response.message ?? "Unable to analyze plant",
              // onRetry: controller.callPlantDiagnosisApi,
              onRetry: () {
                controller.diagnosePlant();
              },
            );
          }

          /// NOT A PLANT
          if (controller.isCurrentImagePlant.value == false) {
            return const NoPlantDetectedView();
          }

          /// SUCCESS
          return DiagnosisSuccessView(controller: controller);
        }),
      ),
    );
  }
}
