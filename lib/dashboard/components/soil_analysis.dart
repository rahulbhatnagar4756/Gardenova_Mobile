import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../base/widgets/base_text.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_keys.dart';

class SoilAnalysis extends StatelessWidget {
  final List<ChartData> chartData;

  const SoilAnalysis({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 190.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7EE),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    AppAssets.soilAnalysisIc,
                    width: 33.w,
                    height: 33.w,
                  ),
                  SizedBox(width: 5.w),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseText(
                          text: "Soil Analysis",
                          textColor: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        BaseText(
                          text:
                              "Understand your soil composition for healthier plants",
                          textColor: AppColors.liteGreyColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ).paddingOnly(right: 120.w),
              SizedBox(height: 28.h),
              Column(
                children: [
                  _buildItem(
                    chartData[0].x,
                    '${chartData[0].y.toInt()}%',
                    chartData[0].color,
                  ),
                  _buildDivider(),
                  _buildItem(
                    chartData[1].x,
                    '${chartData[1].y.toInt()}%',
                    chartData[1].color,
                  ),
                  _buildDivider(),

                  /// Items
                  _buildItem(
                    chartData[2].x,
                    '${chartData[2].y.toInt()}%',
                    chartData[2].color,
                  ),
                  _buildDivider(),
                  _buildItem(
                    chartData[3].x,
                    '${chartData[3].y.toInt()}%',
                    chartData[3].color,
                  ),
                ],
              ).paddingOnly(right: Get.width * .44, left: 10.w),
            ],
          ),

          Positioned(
            right: -25.w,
            top: 30.h,
            child: SizedBox(
              width: 210,
              height: 130,
              child: Stack(
                children: [
                  SfCircularChart(
                    key: UniqueKey(),
                    margin: EdgeInsets.zero,
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (data, _) => data.x,
                        yValueMapper: (data, _) => data.y,
                        pointColorMapper: (data, _) => data.color,

                        /// 🎯 shape
                        innerRadius: '45%',
                        radius: '100%',

                        /// 🔥 THIS creates real spacing
                        explode: true,
                        explodeAll: true,
                        explodeOffset: '4%',

                        /// 🎯 THIS is key for your UI
                        // cornerStyle: CornerStyle.bothCurve,
                        /// ❌ IMPORTANT: no rounded corners
                        cornerStyle: CornerStyle.bothFlat,

                        /// 🎯 dark border on each segment
                        strokeWidth: 1,
                        strokeColor: AppColors.chartBorderColor,
                        // dark green/blackish

                        /// ❌ no fake gap
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: false,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Image.asset(
                      AppAssets.appLogo,
                      width: 38.w,
                      height: 38.w,
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

  Widget _buildDivider() {
    return Divider(height: 8.h, color: AppColors.blackColor.withOpacity(0.15));
  }

  // Reusable label widget
  Widget _buildItem(String title, String value, Color dividerColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Row(
        children: [
          /// Dot
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: dividerColor,
              shape: BoxShape.circle,
            ),
          ),

          SizedBox(width: 8.w),

          /// Title
          Expanded(
            child: BaseText(
              text: title,
              fontFamily: AppKeys.poppins,
              textColor: const Color(0xFF364153),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          /// Divider
          Container(
            height: 14.h,
            width: 1,
            color: AppColors.blackColor.withOpacity(0.15),
          ),

          /// Value
          SizedBox(
            width: 45.w,
            child: BaseText(
              text: value,
              textAlign: TextAlign.end,
              fontFamily: AppKeys.poppins,
              textColor: const Color(0xFF364153),
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  //   Widget _buildItem(String title, String value, Color dividerColor) {
  //     return Row(
  //       children: [
  //         Container(
  //           width: 8.w,
  //           height: 8.w,
  //           decoration: BoxDecoration(
  //             color: dividerColor,
  //             borderRadius: BorderRadius.circular(100),
  //           ),
  //         ),
  //         SizedBox(width: 7.w),
  //         BaseText(
  //           text: title,
  //           textAlign: TextAlign.center,
  //           fontFamily: AppKeys.poppins,
  //           textColor: const Color(0xFF364153),
  //           fontSize: 10.sp,
  //           fontWeight: FontWeight.w500,
  //         ),
  //         SizedBox(width: 40.w),
  //         Container(
  //           height: 15.w,
  //           width: 1.w,
  //           color: AppColors.blackColor.withOpacity(0.5),
  //         ),
  //         SizedBox(width: 25.w),
  //         BaseText(
  //           text: value,

  //           textAlign: TextAlign.center,
  //           fontFamily: AppKeys.poppins,
  //           textColor: const Color(0xFF364153),
  //           fontSize: 10.sp,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ],
  //     );
  //   }
}

/// MODEL
class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  double y;
  final Color color;
}
