import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../general/color_constants.dart';
import '../../general/text_styles.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  // This will be used to draw the orange line
  final List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: grey.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            color: Colors.red,
                            size: 14,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            "Bride Side Guests",
                            style: poppinsNormal.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: grey.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            color: Colors.blue,
                            size: 14,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            "Groom Side Guests",
                            style: poppinsNormal.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 400,
                  child: SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      enableAxisAnimation: true,
                      primaryXAxis: NumericAxis(),
                      tooltipBehavior:
                          TooltipBehavior(enable: true), // Enables the tooltip.
                      series: <LineSeries<LeaderBoardData, double>>[
                        LineSeries<LeaderBoardData, double>(
                            width: 3,
                            yAxisName: 'Guests',
                            dataSource: [
                              LeaderBoardData(0, 0),
                              LeaderBoardData(5, 2),
                              LeaderBoardData(10, 8),
                              LeaderBoardData(15, 15),
                              LeaderBoardData(20, 22),
                              LeaderBoardData(25, 30),
                              LeaderBoardData(30, 36),
                              LeaderBoardData(35, 40)
                            ],
                            xValueMapper: (LeaderBoardData point, _) =>
                                point.point,
                            yValueMapper: (LeaderBoardData point, _) =>
                                point.guest,
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: false,
                                textStyle: TextStyle(
                                    color:
                                        Colors.blue)) // Enables the data label.
                            ),
                        LineSeries<LeaderBoardData, double>(
                            width: 3,
                            yAxisName: 'Guests',
                            dataSource: [
                              LeaderBoardData(0, 0),
                              LeaderBoardData(5, 5),
                              LeaderBoardData(10, 12),
                              LeaderBoardData(15, 20),
                              LeaderBoardData(20, 25),
                              LeaderBoardData(25, 31),
                              LeaderBoardData(30, 40),
                              LeaderBoardData(35, 45)
                            ],
                            xValueMapper: (LeaderBoardData point, _) =>
                                point.point,
                            yValueMapper: (LeaderBoardData point, _) =>
                                point.guest,
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: false,
                                textStyle: TextStyle(
                                    color:
                                        Colors.pink)) // Enables the data label.
                            )
                      ])),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: grey.withOpacity(0.3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                color: Colors.red,
                                size: 14,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                "Bride Side Guests earned",
                                style: poppinsNormal.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                "3220 Pts",
                                style: poppinsBold.copyWith(fontSize: 18),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: timeGrey,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  "By 24 guests",
                                  style: poppinsNormal.copyWith(fontSize: 10),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: grey.withOpacity(0.3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                color: Colors.blue,
                                size: 14,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                "Groom Side Guests earned",
                                style: poppinsNormal.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                "3220 Pts",
                                style: poppinsBold.copyWith(fontSize: 18),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: timeGrey,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  "By 24 guests",
                                  style: poppinsNormal.copyWith(fontSize: 10),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LeaderBoardData {
  LeaderBoardData(this.guest, this.point);

  final double guest;
  final double point;
}
