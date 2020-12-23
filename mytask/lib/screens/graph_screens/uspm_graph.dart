import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mytask/models/graph_model.dart';
import 'package:provider/provider.dart';
import 'package:mytask/utilities/constants.dart';

class UspmGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: Provider.of<GraphModel>(context).maxUspmY > 1
            ? Provider.of<GraphModel>(context).intervalUspmY
            : 0.1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      axisTitleData: FlAxisTitleData(
        show: true,
        leftTitle: AxisTitle(
            showTitle: true,
            titleText: "μS/min",
            textStyle: const TextStyle(color: Colors.white)),
        bottomTitle: AxisTitle(
            showTitle: true,
            titleText: "Time(min)",
            textStyle: const TextStyle(color: Colors.white)),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          textStyle: const TextStyle(
              color: const Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 10),
          interval: 2,
          margin: 8,
          checkToShowTitle:
              (minValue, maxValue, sideTitles, appliedInterval, value) => true,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: const Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          interval: Provider.of<GraphModel>(context).maxUspmY > 1
              ? Provider.of<GraphModel>(context).intervalUspmY
              : 0.1,
          checkToShowTitle:
              (minValue, maxValue, sideTitles, appliedInterval, value) => true,
          reservedSize: 20,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: Provider.of<GraphModel>(context).xUspmLength >= 17
          ? Provider.of<GraphModel>(context).xFirstUspm
          : 0,
      maxX: Provider.of<GraphModel>(context).xUspmLength >= 17
          ? Provider.of<GraphModel>(context).xLastUspm
          : 16,
      minY: 0,
      maxY: Provider.of<GraphModel>(context).maxUspmY > 1
          ? Provider.of<GraphModel>(context).maxUspmY
          : 1,
      lineBarsData: [
        LineChartBarData(
          spots: Provider.of<GraphModel>(context).uspmDataPoint,
          isCurved: true,
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 0.0,
          colors: gradientColors,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    ));
  }
}
