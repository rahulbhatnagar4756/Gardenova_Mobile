import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/base/widgets/full_screen_image_preview.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_response_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/treatment_step_tile.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/plants/plant_analysis/model/plant_scan_compare_model.dart';
import 'package:kasagardem/plants/plant_analysis/plant_analysis_compare_controller.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class PlantScanCompareView extends StatelessWidget {
  final PlantAnalysisCompareController controller;

  const PlantScanCompareView({super.key, required this.controller});

  String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(RegExp(r'\s+|-'))
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  String _percent(double value) {
    if (value <= 0) return '—';
    final pct = value <= 1 ? value * 100 : value;
    return '${pct.toStringAsFixed(pct < 10 ? 1 : 0)}%';
  }

  String _orDash(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? '—' : trimmed;
  }

  int _severityRank(PlantScanCompareItem plant) {
    if (plant.isHealthy) return 0;
    var rank = 1;
    for (final issue in plant.issues) {
      switch ((issue.severity ?? '').toLowerCase()) {
        case 'high':
          rank = rank < 3 ? 3 : rank;
          break;
        case 'medium':
          rank = rank < 2 ? 2 : rank;
          break;
        default:
          break;
      }
    }
    return rank;
  }

  Color _severityColor(String? severity) {
    switch ((severity ?? '').toLowerCase()) {
      case 'high':
        return AppColors.red;
      case 'medium':
        return AppColors.orangeColor;
      case 'low':
        return AppColors.greenColor;
      default:
        return AppColors.liteGreyColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final previous = controller.previousPlant.value!;
    final current = controller.currentPlant.value!;
    final insight = _insight(l10n, previous: previous, current: current);
    final previousName = _toTitleCase(
      previous.displayName.isNotEmpty
          ? previous.displayName
          : AppStrings.unknownPlant,
    );
    final currentName = _toTitleCase(
      current.displayName.isNotEmpty ? current.displayName : previousName,
    );
    final previousRank = _severityRank(previous);
    final currentRank = _severityRank(current);

    return SafeArea(
      child: Column(
        children: [
          _CompareHeader(title: l10n.comparePlantState),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                spacerSize16,
                spacerSize8,
                spacerSize16,
                spacerSize24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PhotoCompare(
                    previous: previous,
                    current: current,
                    previousLabel: l10n.previousScan,
                    currentLabel: l10n.currentScan,
                    currentImageFile: controller.imageFile.value,
                  ),
                  SizedBox(height: spacerSize16),
                  _VerdictBanner(insight: insight),
                  SizedBox(height: spacerSize16),
                  _ComparisonTable(
                    previousLabel: l10n.previousScan,
                    currentLabel: l10n.currentScan,
                    rows: [
                      _MetricRowData(
                        label: AppStrings.plant,
                        previous: previousName,
                        current: currentName,
                      ),
                      _MetricRowData(
                        label: l10n.healthy,
                        previous: previous.isHealthy
                            ? l10n.healthy
                            : l10n.needsAttention,
                        current: current.isHealthy
                            ? l10n.healthy
                            : l10n.needsAttention,
                        previousColor: previous.isHealthy
                            ? AppColors.greenColor
                            : AppColors.orangeColor,
                        currentColor: current.isHealthy
                            ? AppColors.greenColor
                            : AppColors.orangeColor,
                        improved: currentRank < previousRank,
                        declined: currentRank > previousRank,
                      ),
                      _MetricRowData(
                        label: AppStrings.mainIssue,
                        previous: previous.isHealthy
                            ? AppStrings.noDiseaseDetected
                            : _orDash(_toTitleCase(previous.displayDisease)),
                        current: current.isHealthy
                            ? AppStrings.noDiseaseDetected
                            : _orDash(_toTitleCase(current.displayDisease)),
                        improved: currentRank < previousRank,
                        declined: currentRank > previousRank,
                      ),
                      _MetricRowData(
                        label: l10n.severity,
                        previous: previous.isHealthy
                            ? '—'
                            : _orDash(
                                _toTitleCase(
                                  previous.primaryIssue?.severity ?? '',
                                ),
                              ),
                        current: current.isHealthy
                            ? '—'
                            : _orDash(
                                _toTitleCase(
                                  current.primaryIssue?.severity ?? '',
                                ),
                              ),
                        previousColor: previous.isHealthy
                            ? null
                            : _severityColor(previous.primaryIssue?.severity),
                        currentColor: current.isHealthy
                            ? null
                            : _severityColor(current.primaryIssue?.severity),
                        improved: currentRank < previousRank,
                        declined: currentRank > previousRank,
                      ),
                      _MetricRowData(
                        label: AppStrings.family,
                        previous: _orDash(previous.family),
                        current: _orDash(current.family),
                      ),
                      _MetricRowData(
                        label: AppStrings.issue,
                        previous: '${previous.issues.length}',
                        current: '${current.issues.length}',
                        improved: current.issues.length < previous.issues.length,
                        declined: current.issues.length > previous.issues.length,
                      ),
                      _MetricRowData(
                        label: AppStrings.aiConfidence,
                        previous: _percent(previous.confidence),
                        current: _percent(current.confidence),
                      ),
                    ],
                  ),
                  if (previous.issues.isNotEmpty || current.issues.isNotEmpty) ...[
                    SizedBox(height: spacerSize16),
                    _IssueCompareCard(
                      previousLabel: l10n.previousScan,
                      currentLabel: l10n.currentScan,
                      previousIssues: previous.issues,
                      currentIssues: current.issues,
                      severityColor: _severityColor,
                      toTitleCase: _toTitleCase,
                    ),
                  ],
                  if ((previous.primaryIssue?.symptoms?.isNotEmpty ?? false) ||
                      (current.primaryIssue?.symptoms?.isNotEmpty ?? false)) ...[
                    SizedBox(height: spacerSize16),
                    _SideBySideListCard(
                      title: l10n.symptoms,
                      previousLabel: l10n.previousScan,
                      currentLabel: l10n.currentScan,
                      previousItems: previous.primaryIssue?.symptoms ?? const [],
                      currentItems: current.primaryIssue?.symptoms ?? const [],
                    ),
                  ],
                  if (current.primaryIssue?.treatment?.immediate?.isNotEmpty ==
                      true) ...[
                    SizedBox(height: spacerSize16),
                    _CurrentTreatmentCard(
                      title: AppStrings.treatmentGuide,
                      steps: current.primaryIssue!.treatment!.immediate!,
                    ),
                  ],
                  // SizedBox(height: spacerSize24),
                  // _RescanButton(
                  //   label: l10n.rescan,
                  //   onTap: controller.rescanCurrent,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _CompareInsight _insight(
    AppLocalizations l10n, {
    required PlantScanCompareItem previous,
    required PlantScanCompareItem current,
  }) {
    final previousRank = _severityRank(previous);
    final currentRank = _severityRank(current);
    if (currentRank < previousRank) {
      return _CompareInsight(
        text: l10n.healthImproved,
        color: AppColors.greenColor,
        icon: Icons.trending_up_rounded,
      );
    }
    if (currentRank > previousRank) {
      return _CompareInsight(
        text: l10n.healthDeclined,
        color: AppColors.orangeColor,
        icon: Icons.trending_down_rounded,
      );
    }
    return _CompareInsight(
      text: l10n.healthUnchanged,
      color: AppColors.darkGreenColor,
      icon: Icons.horizontal_rule_rounded,
    );
  }
}

class _CompareHeader extends StatelessWidget {
  final String title;

  const _CompareHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(spacerSize4, spacerSize4, spacerSize16, spacerSize8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
            onPressed: Get.back,
          ),
          Expanded(
            child: BaseText(
              text: title,
              fontFamily: AppKeys.poppins,
              fontSize: fontSize18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoCompare extends StatelessWidget {
  final PlantScanCompareItem previous;
  final PlantScanCompareItem current;
  final String previousLabel;
  final String currentLabel;
  final File? currentImageFile;

  const _PhotoCompare({
    required this.previous,
    required this.current,
    required this.previousLabel,
    required this.currentLabel,
    this.currentImageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: _PhotoCard(
                    label: previousLabel,
                    imageUrl: previous.imageUrl,
                    isHealthy: previous.isHealthy,
                  ),
                ),
                Expanded(
                  child: _PhotoCard(
                    label: currentLabel,
                    imageUrl: current.imageUrl,
                    imageFile: currentImageFile,
                    isHealthy: current.isHealthy,
                    isCurrent: true,
                  ),
                ),
              ],
            ),
            Container(
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: AppColors.linearGradientForBtn,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.whiteColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greenColor.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: BaseText(
                text: 'VS',
                fontFamily: AppKeys.poppins,
                fontSize: fontSize11,
                fontWeight: FontWeight.w800,
                textColor: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final String label;
  final String imageUrl;
  final File? imageFile;
  final bool isHealthy;
  final bool isCurrent;

  const _PhotoCard({
    required this.label,
    required this.imageUrl,
    this.imageFile,
    required this.isHealthy,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isHealthy ? AppColors.greenColor : AppColors.orangeColor;

    return Container(
      margin: EdgeInsets.only(
        left: isCurrent ? spacerSize4 : 0,
        right: isCurrent ? 0 : spacerSize4,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(
          color: isCurrent
              ? AppColors.greenColor.withValues(alpha: 0.45)
              : AppColors.borderLiteGreyColor,
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(spacerSize16),
            ),
            child: GestureDetector(
              onTap: _openLargeImage,
              child: _image(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacerSize8,
              vertical: spacerSize10,
            ),
            child: Column(
              children: [
                BaseText(
                  text: label,
                  fontFamily: AppKeys.poppins,
                  fontSize: fontSize13,
                  fontWeight: FontWeight.w700,
                  textColor: isCurrent
                      ? AppColors.greenColor
                      : AppColors.blackColor,
                ),
                SizedBox(height: spacerSize6),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacerSize8,
                    vertical: spacerSize4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(spacerSize20),
                  ),
                  child: BaseText(
                    text: isHealthy
                        ? AppLocalizations.of(context)!.healthy
                        : AppLocalizations.of(context)!.needsAttention,
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize10,
                    fontWeight: FontWeight.w600,
                    textColor: statusColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openLargeImage() {
    final url = imageUrl.trim();
    if (url.isNotEmpty) {
      FullScreenImageView.open(imageUrl: url);
      return;
    }
    final file = imageFile;
    if (file != null && file.existsSync()) {
      FullScreenImageView.open(imageUrl: file.path);
    }
  }

  Widget _image() {
    final url = imageUrl.trim();
    if (url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        height: 168.h,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, _) => BaseShimmer(
          height: 168.h,
          width: double.infinity,
          borderRadious: 0,
        ),
        errorWidget: (_, _, _) => _fileOrFallback(),
      );
    }
    return _fileOrFallback();
  }

  Widget _fileOrFallback() {
    final file = imageFile;
    if (file != null && file.existsSync()) {
      return Image.file(
        file,
        height: 168.h,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return Container(
      height: 168.h,
      width: double.infinity,
      color: AppColors.greenColor.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: Image.asset(
        AppAssets.appLogo,
        height: 42.w,
        width: 42.w,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _CompareInsight {
  final String text;
  final Color color;
  final IconData icon;

  const _CompareInsight({
    required this.text,
    required this.color,
    required this.icon,
  });
}

class _VerdictBanner extends StatelessWidget {
  final _CompareInsight insight;

  const _VerdictBanner({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: spacerSize14,
        vertical: spacerSize12,
      ),
      decoration: BoxDecoration(
        color: insight.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: insight.color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: insight.color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(insight.icon, color: insight.color, size: 20.w),
          ),
          SizedBox(width: spacerSize10),
          Expanded(
            child: BaseText(
              text: insight.text,
              fontFamily: AppKeys.poppins,
              fontSize: fontSize16,
              fontWeight: FontWeight.w700,
              textColor: insight.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRowData {
  final String label;
  final String previous;
  final String current;
  final Color? previousColor;
  final Color? currentColor;
  final bool improved;
  final bool declined;

  const _MetricRowData({
    required this.label,
    required this.previous,
    required this.current,
    this.previousColor,
    this.currentColor,
    this.improved = false,
    this.declined = false,
  });

  bool get changed => previous.trim().toLowerCase() != current.trim().toLowerCase();
}

class _ComparisonTable extends StatelessWidget {
  final String previousLabel;
  final String currentLabel;
  final List<_MetricRowData> rows;

  const _ComparisonTable({
    required this.previousLabel,
    required this.currentLabel,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacerSize10,
              vertical: spacerSize12,
            ),
            decoration: BoxDecoration(
              color: AppColors.toToLiteGreenColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(spacerSize16),
              ),
            ),
            child: Row(
              children: [
                const Expanded(flex: 3, child: SizedBox()),
                Expanded(
                  flex: 4,
                  child: BaseText(
                    text: previousLabel,
                    fontFamily: AppKeys.poppins,
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: BaseText(
                    text: currentLabel,
                    fontFamily: AppKeys.poppins,
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.greenColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(rows.length, (index) {
            final row = rows[index];
            return Column(
              children: [
                if (index > 0)
                  Divider(height: 1, color: AppColors.borderLiteGreyColor),
                _MetricRow(data: row),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final _MetricRowData data;

  const _MetricRow({required this.data});

  @override
  Widget build(BuildContext context) {
    Color? currentFill;
    if (data.changed && data.improved) {
      currentFill = AppColors.greenColor.withValues(alpha: 0.08);
    } else if (data.changed && data.declined) {
      currentFill = AppColors.orangeColor.withValues(alpha: 0.08);
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacerSize10,
        vertical: spacerSize12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: BaseText(
              text: data.label,
              fontFamily: AppKeys.poppins,
              fontSize: fontSize12,
              fontWeight: FontWeight.w600,
              textColor: AppColors.liteGreyColor,
            ),
          ),
          Expanded(
            flex: 4,
            child: _ValueCell(text: data.previous, color: data.previousColor),
          ),
          Expanded(
            flex: 4,
            child: _ValueCell(
              text: data.current,
              color: data.currentColor,
              fill: currentFill,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? fill;

  const _ValueCell({required this.text, this.color, this.fill});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: spacerSize4),
      padding: EdgeInsets.symmetric(
        horizontal: spacerSize6,
        vertical: spacerSize6,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(spacerSize8),
      ),
      child: BaseText(
        text: text,
        fontFamily: AppKeys.inter,
        fontSize: fontSize12,
        fontWeight: FontWeight.w600,
        textColor: color,
        textAlign: TextAlign.center,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _IssueCompareCard extends StatelessWidget {
  final String previousLabel;
  final String currentLabel;
  final List<Issues> previousIssues;
  final List<Issues> currentIssues;
  final Color Function(String?) severityColor;
  final String Function(String) toTitleCase;

  const _IssueCompareCard({
    required this.previousLabel,
    required this.currentLabel,
    required this.previousIssues,
    required this.currentIssues,
    required this.severityColor,
    required this.toTitleCase,
  });

  @override
  Widget build(BuildContext context) {
    final names = <String>{};
    for (final issue in [...previousIssues, ...currentIssues]) {
      final name = (issue.name ?? '').trim();
      if (name.isNotEmpty) names.add(name.toLowerCase());
    }

    Issues? findIssue(List<Issues> issues, String key) {
      for (final issue in issues) {
        if ((issue.name ?? '').trim().toLowerCase() == key) return issue;
      }
      return null;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacerSize16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: AppStrings.issue,
            fontFamily: AppKeys.poppins,
            fontSize: fontSize16,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: spacerSize12),
          Row(
            children: [
              const Expanded(flex: 4, child: SizedBox()),
              Expanded(
                flex: 3,
                child: BaseText(
                  text: previousLabel,
                  fontFamily: AppKeys.poppins,
                  fontSize: fontSize11,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  textColor: AppColors.liteGreyColor,
                ),
              ),
              Expanded(
                flex: 3,
                child: BaseText(
                  text: currentLabel,
                  fontFamily: AppKeys.poppins,
                  fontSize: fontSize11,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  textColor: AppColors.greenColor,
                ),
              ),
            ],
          ),
          SizedBox(height: spacerSize10),
          ...names.map((key) {
            final previous = findIssue(previousIssues, key);
            final current = findIssue(currentIssues, key);
            final title = toTitleCase(current?.name ?? previous?.name ?? key);
            return Padding(
              padding: EdgeInsets.only(bottom: spacerSize10),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: BaseText(
                      text: title,
                      fontFamily: AppKeys.inter,
                      fontSize: fontSize12,
                      fontWeight: FontWeight.w600,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: _PresenceChip(
                      issue: previous,
                      severityColor: severityColor,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: _PresenceChip(
                      issue: current,
                      severityColor: severityColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PresenceChip extends StatelessWidget {
  final Issues? issue;
  final Color Function(String?) severityColor;

  const _PresenceChip({required this.issue, required this.severityColor});

  @override
  Widget build(BuildContext context) {
    if (issue == null) {
      return BaseText(
        text: '—',
        fontFamily: AppKeys.inter,
        fontSize: fontSize12,
        textAlign: TextAlign.center,
        textColor: AppColors.liteGreyColor,
      );
    }

    final severity = (issue!.severity ?? '').trim();
    final color = severityColor(severity);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacerSize4),
      padding: EdgeInsets.symmetric(
        horizontal: spacerSize6,
        vertical: spacerSize4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(spacerSize20),
      ),
      alignment: Alignment.center,
      child: BaseText(
        text: severity.isEmpty ? '•' : severity.toUpperCase(),
        fontFamily: AppKeys.poppins,
        fontSize: fontSize10,
        fontWeight: FontWeight.w700,
        textColor: color,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SideBySideListCard extends StatelessWidget {
  final String title;
  final String previousLabel;
  final String currentLabel;
  final List<String> previousItems;
  final List<String> currentItems;

  const _SideBySideListCard({
    required this.title,
    required this.previousLabel,
    required this.currentLabel,
    required this.previousItems,
    required this.currentItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacerSize16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: title,
            fontFamily: AppKeys.poppins,
            fontSize: fontSize16,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: spacerSize12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _BulletColumn(label: previousLabel, items: previousItems),
              ),
              SizedBox(width: spacerSize10),
              Expanded(
                child: _BulletColumn(
                  label: currentLabel,
                  items: currentItems,
                  isCurrent: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BulletColumn extends StatelessWidget {
  final String label;
  final List<String> items;
  final bool isCurrent;

  const _BulletColumn({
    required this.label,
    required this.items,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacerSize10),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.greenColor.withValues(alpha: 0.05)
            : AppColors.offWhite,
        borderRadius: BorderRadius.circular(spacerSize12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: label,
            fontFamily: AppKeys.poppins,
            fontSize: fontSize12,
            fontWeight: FontWeight.w700,
            textColor: isCurrent ? AppColors.greenColor : AppColors.liteGreyColor,
          ),
          SizedBox(height: spacerSize8),
          if (items.isEmpty)
            BaseText(
              text: '—',
              fontFamily: AppKeys.inter,
              fontSize: fontSize12,
              textColor: AppColors.liteGreyColor,
            )
          else
            ...items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: spacerSize6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: Icon(
                        Icons.circle,
                        size: 6.w,
                        color: isCurrent
                            ? AppColors.greenColor
                            : AppColors.liteGreyColor,
                      ),
                    ),
                    SizedBox(width: spacerSize6),
                    Expanded(
                      child: BaseText(
                        text: item,
                        fontFamily: AppKeys.inter,
                        fontSize: fontSize12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CurrentTreatmentCard extends StatelessWidget {
  final String title;
  final List<String> steps;

  const _CurrentTreatmentCard({required this.title, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacerSize16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: title,
            fontFamily: AppKeys.poppins,
            fontSize: fontSize16,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: spacerSize12),
          ...steps.map((step) => TreatmentStepTile(step: step)),
        ],
      ),
    );
  }
}

class _RescanButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RescanButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CommonClickWidget(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          gradient: AppColors.linearGradientForBtn,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.greenColor.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
