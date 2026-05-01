import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/professional/myLead/my_lead_controller.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../base/widgets/base_text.dart';
import '../../../utils/constants/app_color.dart';

class LeadMatricCard extends StatelessWidget {
  final MyLeadController controller;

  const LeadMatricCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double total = controller.totalLeads.value.toDouble();

      final List<ChartData> chartData = [
        ChartData(
          "${AppLocalizations.of(context)!.newLead} (${controller.newLeads.value})",
          controller.newLeads.value.toDouble(),
          AppColors.offWhite,
        ),
        ChartData(
          "${AppLocalizations.of(context)!.contactedLead} (${controller.contactedLeads.value})",
          controller.contactedLeads.value.toDouble(),
          AppColors.lightGold,
        ),
        ChartData(
          "${AppLocalizations.of(context)!.closedLead} (${controller.closedLeads.value})",
          controller.closedLeads.value.toDouble(),
          AppColors.burntGoldLight,
        ),
      ];

      return Container(
        margin: EdgeInsets.only(top: spacerSize16),
        padding: EdgeInsets.only(left: spacerSize20),
        decoration: BoxDecoration(
          color: AppColors.darkGreen,
          borderRadius: BorderRadius.circular(spacerSize10),
          border: Border.all(color: AppColors.offWhite10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    text: AppLocalizations.of(context)!.totalLeads,
                    fontSize: fontSize14,
                    fontFamily: AppKeys.inter,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.offWhite70,
                  ),
                  BaseText(
                    text: controller.totalLeads.value.toString(),
                    fontSize: fontSize20,
                    fontFamily: AppKeys.inter,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.offWhite,
                  ),
                ],
              ),
            ),

            /// RIGHT SIDE CHART
            Expanded(
              flex: 2,
              child: SizedBox(
                height: spacerSize100,
                child: IgnorePointer(
                  child: SfCircularChart(
                    legend: const Legend(
                      isVisible: true,
                      position: LegendPosition.left,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: spacerSize10,
                      ),
                    ),

                    series: <CircularSeries>[
                      RadialBarSeries<ChartData, String>(
                        dataSource: chartData,
                        maximumValue: total == 0 ? 1 : total,
                        trackOpacity: 0.3,
                        trackColor: Colors.white,
                        gap: '18%',
                        radius: '90%',
                        innerRadius: '30%',
                        cornerStyle: CornerStyle.bothCurve,
                        useSeriesColor: true,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        pointColorMapper: (ChartData data, _) => data.color,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}
