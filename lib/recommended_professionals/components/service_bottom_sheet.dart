import 'package:flutter/material.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import '../../base/widgets/base_text.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class ServiceBottomSheet extends StatelessWidget {
  final Map<String, Map<String, String>> categories;
  final Function(String key, String value) onSelect;
  final String? selectedKey;

  const ServiceBottomSheet({
    super.key,
    required this.categories,
    required this.onSelect,
    this.selectedKey,
  });

  static void show({
    required Map<String, Map<String, String>> categories,
    required Function(String key, String value) onSelect,
    String? selectedKey,
  }) {
    Get.bottomSheet(
      isScrollControlled: true,
      ServiceBottomSheet(
        categories: categories,
        onSelect: onSelect,
        selectedKey: selectedKey,
      ),
    );
  }

  String get currentLang => Get.locale?.languageCode ?? 'en';

  @override
  Widget build(BuildContext context) {
    final entries = categories.entries.toList();

    return Container(
      padding: const EdgeInsets.all(spacerSize20),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        border: Border(
          top: BorderSide(color: AppColors.offWhite10, width: spacerSize2),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(spacerSize28),
          topRight: Radius.circular(spacerSize28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaseText(
                text: AppLocalizations.of(context)!.selectService,
                fontFamily: AppKeys.inter,
                fontWeight: FontWeight.w500,
                textColor: AppColors.darkGold,
                fontSize: fontSize16,
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),

          /// List
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: entries.length,
            separatorBuilder: (_, __) =>
                Divider(color: AppColors.offWhite10),
            itemBuilder: (context, index) {
              final key = entries[index].key;
              final value = entries[index].value[currentLang] ?? "";
              final isSelected = key == selectedKey;

              return InkWell(
                onTap: () {
                  onSelect(key, value);
                  Get.back();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: spacerSize10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BaseText(
                          text: value,
                          fontFamily: AppKeys.inter,
                          fontWeight: FontWeight.w500,
                          textColor: Colors.white,
                          fontSize: fontSize15,
                        ),

                        if (isSelected)
                          const Icon(Icons.check, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}