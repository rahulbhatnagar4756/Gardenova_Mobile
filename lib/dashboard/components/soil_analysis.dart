// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:kasagardem/base/widgets/base_bordered_container.dart';
// import 'package:kasagardem/base/widgets/base_text.dart';
// import 'package:kasagardem/l10n/app_localizations.dart';
// import 'package:kasagardem/utils/constants/app_color.dart';
// import 'package:kasagardem/utils/constants/app_constants.dart';
// import 'package:kasagardem/utils/constants/app_keys.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class SoilAnalysis extends StatelessWidget {
//   const SoilAnalysis({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<ChartData> chartData = [
//       ChartData(
//         '${AppLocalizations.of(context)!.organic} 70%',
//         70,
//         AppColors.dullGold23,
//       ),
//       ChartData(
//         '${AppLocalizations.of(context)!.sabd}  75%',
//         75,
//         AppColors.dullGold24,
//       ),
//       ChartData(
//         '${AppLocalizations.of(context)!.silt}  80% ',
//         80,
//         AppColors.dullGold24Alt,
//       ),
//       ChartData(
//         '${AppLocalizations.of(context)!.clay}  85%',
//         85,
//         AppColors.dullGold25,
//       ),
//     ];
//     return BaseBorderedContainer(
//       // height: spacerSize115,
//       height: spacerSize150,
//       borderRadius: 16.r,
//       padding: EdgeInsets.all(spacerSize10),
//       backgroundColor: AppColors.greenColor,
//       childWidget: Row(
//         children: [
//           Column(children: [
//             BaseText(
//               textAlign: TextAlign.start,
//               text: AppLocalizations.of(context)!.soilAnalysis,
//               fontWeight: FontWeight.w400,
//               fontSize: fontSize13,
//               fontFamily: AppKeys.poppins,
//               textColor: AppColors.offWhite,
//             ).marginOnly(bottom: spacerSize10)
//           ],),
//
//           Expanded(
//             flex: 4,
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: SfCircularChart(
//                 tooltipBehavior: TooltipBehavior(enable: true),
//                 legend: Legend(
//                   isVisible: true,
//                   alignment: ChartAlignment.center,
//                   orientation: LegendItemOrientation.vertical,
//                   position: LegendPosition.left,
//                   overflowMode: LegendItemOverflowMode.scroll,
//                   isResponsive: false,
//                   toggleSeriesVisibility: true,
//                   itemPadding: spacerSize4,
//                   textStyle: TextStyle(
//                     color: AppColors.offWhite,
//                     fontWeight: FontWeight.w400,
//                     fontSize: fontSize9,
//                     leadingDistribution: TextLeadingDistribution.even,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 series: <CircularSeries>[
//                   RadialBarSeries<ChartData, String>(
//                     dataSource: chartData,
//                     opacity: 1.5,
//                     dataLabelMapper: (ChartData data, _) => data.x,
//                     trackOpacity: .01,
//                     legendIconType: LegendIconType.circle,
//                     enableTooltip: true,
//                     maximumValue: 100,
//                     trackColor: AppColors.darkGreen,
//                     gap: '15%',
//                     xValueMapper: (ChartData data, _) => data.x,
//                     yValueMapper: (ChartData data, _) => data.y,
//                     useSeriesColor: true,
//                     cornerStyle: CornerStyle.bothCurve,
//                     radius: '$spacerSize45',
//                     pointColorMapper: (ChartData data, _) => data.color,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChartData {
//   ChartData(this.x, this.y, this.color);
//
//   final String x;
//   final double y;
//   final Color color;
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../base/widgets/base_text.dart';
import '../../utils/constants/app_keys.dart';

class SoilAnalysis extends StatelessWidget {
  const SoilAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Organic', 10, AppColors.liteYellowColor),
      ChartData('Sand', 27, AppColors.darkGreenColor),
      ChartData('Silt', 15, AppColors.liteGreenColor),
      ChartData('Clay', 35, AppColors.toLiteGreenColor),
    ];

    return Container(
      height: 150.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0FA958),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          /// LEFT SIDE TEXT
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Soil Analysis",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Items
                        _buildItem(chartData[0].x, '${chartData[0].y.toInt()}%',chartData[0].color),
                        SizedBox(height: 8.h),
                        _buildItem(chartData[1].x, '${chartData[1].y.toInt()}%',chartData[1].color),
                      ],
                    ),

                    SizedBox(width: 25.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Items
                        _buildItem(chartData[2].x, '${chartData[2].y.toInt()}%',chartData[2].color),

                        SizedBox(height: 8.h),
                        _buildItem(chartData[3].x, '${chartData[3].y.toInt()}%',chartData[3].color),

                      ],
                    ),
                  ],
                ).paddingOnly(left: 8.w),
              ],
            ),
          ),

          /// RIGHT SIDE CHART
          // Expanded(
          //   flex: 2,
          //   child: SfCircularChart(
          //     margin: EdgeInsets.zero,
          //     series: <CircularSeries>[
          //       DoughnutSeries<ChartData, String>(
          //         dataSource: chartData,
          //         xValueMapper: (data, _) => data.x,
          //         yValueMapper: (data, _) => data.y,
          //         pointColorMapper: (data, _) => data.color,
          //         innerRadius: '65%',
          //         radius: '90%',
          //         /// 👇 THIS creates gap effect
          //         strokeWidth: 3.w,
          //         strokeColor: AppColors.greenColor, // same as background
          //
          //         explode: false,
          //         dataLabelSettings: const DataLabelSettings(isVisible: false),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: SfCircularChart(
                margin: EdgeInsets.zero,
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data.x,
                    yValueMapper: (data, _) => data.y,
                    pointColorMapper: (data, _) => data.color,
                    /// 🎯 shape
                    innerRadius: '60%',
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
                    strokeWidth:1,
                    strokeColor: AppColors.chartBorderColor, // dark green/blackish

                    /// ❌ no fake gap
                    dataLabelSettings: const DataLabelSettings(isVisible: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable label widget
  Widget _buildItem(String title, String value,Color dividerColor) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 28.h,
          decoration: BoxDecoration(

            color:dividerColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseText(
              text: title,
              textAlign: TextAlign.center,
              fontFamily: AppKeys.poppins,
              textColor: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
            BaseText(
              text: value,

              textAlign: TextAlign.center,
              fontFamily: AppKeys.poppins,
              textColor: Colors.white,
              fontSize:11.sp,
              fontWeight: FontWeight.w500,
            ),

          ],
        ),
      ],
    );
  }
}

/// MODEL
class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}
