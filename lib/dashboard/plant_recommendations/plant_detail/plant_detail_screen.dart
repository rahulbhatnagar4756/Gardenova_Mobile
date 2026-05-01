import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plant_detail/plant_detail_view_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';

class PlantDetailScreen extends GetWidget<PlantDetailViewModel> {
  const PlantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: controller.plantDetail.value.imageSearchUrl ?? "",
            height: Get.height * .45,
            placeholder: (context, url) =>
                BaseShimmer(height: Get.height * .45),
            errorWidget: (context, url, error) {
              return BaseBorderedContainer(
                height: Get.height * .335,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(spacerSize10),
                childWidget: Icon(
                  Icons.broken_image_rounded,
                  size: spacerSize40,
                  color: AppColors.offWhite10,
                ),
              );
            },
            useOldImageOnUrlChange: true,
            width: Get.width,
            fit: BoxFit.fill,
          ),
          CircularBottomAppBar(
            backgroundColor: AppColors.darkGreen,
            onSettingPressed: () {
              Get.toNamed(Routes.settings);
            },
          ),
        ],
      ),
      bottomSheet: BottomSheet(
        backgroundColor: AppColors.appColor,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacerSize20,
              children: [
                BaseText(
                  text: controller.plantDetail.value.commonName ?? "",
                  fontFamily: AppKeys.poppins,
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.burntGold,
                  textAlign: TextAlign.left,
                  fontSize: fontSize20,
                ),

                titleAndDescriptionLayout(
                  title: AppLocalizations.of(context)!.scientificName,
                  description:
                      controller.plantDetail.value.scientificName ?? "",
                ),
                titleAndDescriptionLayout(
                  title: AppLocalizations.of(context)!.description,
                  description: controller.plantDetail.value.description ?? "",
                ),
                titleAndDescriptionLayout(
                  title: AppLocalizations.of(context)!.careNotes,
                  description: controller.plantDetail.value.careNotes?.join(
                    "\n",
                  ),
                ),
                titleAndDescriptionLayout(
                  title: AppLocalizations.of(context)!.spaceTypes,
                  description: controller.plantDetail.value.spaceTypes!.join(
                    "\n",
                  ),
                ),
                titleAndDescriptionLayout(
                  title: AppLocalizations.of(context)!.areaSize,
                  description: controller.plantDetail.value.areaSizes!.join(
                    "\n",
                  ),
                ),
              ],
            ),
          ).marginAll(spacerSize20),
        ),
        enableDrag: false,
        onClosing: () {},
      ),
    );
  }

  titleAndDescriptionLayout({String? title, String? description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacerSize10,
      children: [
        BaseText(
          text: title!,
          fontFamily: AppKeys.poppins,
          fontWeight: FontWeight.bold,
          textColor: AppColors.burntGoldLight,
          textAlign: TextAlign.left,
          fontSize: fontSize18,
        ),
        BaseText(
          text: description!,
          textColor: AppColors.offWhite50,
          textAlign: TextAlign.left,
          fontSize: fontSize16,
        ),
      ],
    );
  }
}
