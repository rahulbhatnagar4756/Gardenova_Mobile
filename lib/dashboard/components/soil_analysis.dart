import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SoilAnalysis extends StatelessWidget {
  const SoilAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(
        '${AppLocalizations.of(context)!.organic} 70%',
        70,
        AppColors.dullGold23,
      ),
      ChartData(
        '${AppLocalizations.of(context)!.sabd}  75%',
        75,
        AppColors.dullGold24,
      ),
      ChartData(
        '${AppLocalizations.of(context)!.silt}  80% ',
        80,
        AppColors.dullGold24Alt,
      ),
      ChartData(
        '${AppLocalizations.of(context)!.clay}  85%',
        85,
        AppColors.dullGold25,
      ),
    ];
    return BaseBorderedContainer(
      height: spacerSize115,
      padding: EdgeInsets.all(spacerSize10),
      childWidget: Row(
        children: [
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: BaseText(
                textAlign: TextAlign.start,
                text: AppLocalizations.of(context)!.soilAnalysis,
                fontWeight: FontWeight.w400,
                fontSize: fontSize15,
                fontFamily: AppKeys.merriweather,
                textColor: AppColors.offWhite,
              ).marginOnly(bottom: spacerSize10),
            ),
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: SfCircularChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(
                  isVisible: true,
                  alignment: ChartAlignment.center,
                  orientation: LegendItemOrientation.vertical,
                  position: LegendPosition.left,
                  overflowMode: LegendItemOverflowMode.scroll,
                  isResponsive: false,
                  toggleSeriesVisibility: true,
                  itemPadding: spacerSize4,
                  textStyle: TextStyle(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize9,
                    leadingDistribution: TextLeadingDistribution.even,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                series: <CircularSeries>[
                  RadialBarSeries<ChartData, String>(
                    dataSource: chartData,
                    opacity: 1.5,
                    dataLabelMapper: (ChartData data, _) => data.x,
                    trackOpacity: .01,
                    legendIconType: LegendIconType.circle,
                    enableTooltip: true,
                    maximumValue: 100,
                    trackColor: AppColors.darkGreen,
                    gap: '15%',
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    useSeriesColor: true,
                    cornerStyle: CornerStyle.bothCurve,
                    radius: '$spacerSize45',
                    pointColorMapper: (ChartData data, _) => data.color,
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

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}
