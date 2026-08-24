import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../base/widgets/base_text.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_keys.dart';

class SoilAnalysis extends StatelessWidget {
  final List<ChartData> chartData;
  final bool isLoading;

  const SoilAnalysis({
    super.key,
    required this.chartData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _FitnessScoreSkeleton();
    }

    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7EE),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppAssets.soilAnalysisIc,
                width: 33.w,
                height: 33.w,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      text: l10n.fitnessScore,
                      textColor: AppColors.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    BaseText(
                      text: l10n.fitnessScoreSubtitle,
                      textColor: AppColors.liteGreyColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: chartData.isEmpty
                    ? SizedBox(height: 120.h)
                    : Column(
                        children: [
                          for (int i = 0; i < chartData.length; i++) ...[
                            if (i > 0) _buildDivider(),
                            _buildItem(
                              chartData[i].x,
                              '${chartData[i].y.round()}%',
                              chartData[i].color,
                            ),
                          ],
                        ],
                      ),
              ),
              SizedBox(
                width: 150.w,
                height: 130.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (chartData.isNotEmpty)
                      SfCircularChart(
                        margin: EdgeInsets.zero,
                        series: <CircularSeries>[
                          DoughnutSeries<ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (data, _) => data.x,
                            yValueMapper: (data, _) => data.y,
                            pointColorMapper: (data, _) => data.color,
                            innerRadius: '45%',
                            radius: '100%',
                            explode: true,
                            explodeAll: true,
                            explodeOffset: '3%',
                            cornerStyle: CornerStyle.bothFlat,
                            strokeWidth: 1,
                            strokeColor: AppColors.chartBorderColor,
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: false,
                            ),
                          ),
                        ],
                      ),
                    Image.asset(
                      AppAssets.appLogo,
                      width: 34.w,
                      height: 34.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 8.h,
      color: AppColors.blackColor.withValues(alpha: 0.15),
    );
  }

  Widget _buildItem(String title, String value, Color dividerColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: dividerColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: BaseText(
              text: title,
              fontFamily: AppKeys.poppins,
              textColor: const Color(0xFF364153),
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            height: 14.h,
            width: 1,
            color: AppColors.blackColor.withValues(alpha: 0.15),
          ),
          SizedBox(
            width: 40.w,
            child: BaseText(
              text: value,
              textAlign: TextAlign.end,
              fontFamily: AppKeys.poppins,
              textColor: const Color(0xFF364153),
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FitnessScoreSkeleton extends StatelessWidget {
  const _FitnessScoreSkeleton();

  static const _labelWidths = [0.78, 0.92, 0.7, 0.86, 0.74];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.backgroundGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BaseShimmer(height: 33.w, width: 33.w, borderRadious: 33.r),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseShimmer(height: 14.h, width: 120.w, borderRadious: 4.r),
                    SizedBox(height: 6.h),
                    BaseShimmer(
                      height: 10.h,
                      width: double.infinity,
                      borderRadious: 4.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _labelWidths.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        BaseShimmer(
                          height: 8.w,
                          width: 8.w,
                          borderRadious: 8.r,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _labelWidths[index],
                            child: BaseShimmer(
                              height: 10.h,
                              width: double.infinity,
                              borderRadious: 4.r,
                            ),
                          ),
                        ),
                        BaseShimmer(
                          height: 10.h,
                          width: 28.w,
                          borderRadious: 4.r,
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(width: 8.w),
              BaseShimmer(
                height: 110.w,
                width: 110.w,
                borderRadious: 55.r,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  double y;
  final Color color;
}
