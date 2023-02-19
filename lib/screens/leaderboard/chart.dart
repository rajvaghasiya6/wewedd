import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../general/color_constants.dart';
import '../../general/text_styles.dart';
import '../../providers/leaderboard_provider.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key, required this.marriageId}) : super(key: key);
  final String marriageId;
  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<LeaderBoardData> groomData = [];
  bool isLoading = false;
  List<LeaderBoardData> brideData = [];
  int totalbrideside = 0;
  int totalgroomside = 0;
  int totalbridesidepoint = 0;
  int totalgroomsidepoint = 0;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      Provider.of<LeaderboardProvider>(context, listen: false)
          .getChart(
        marriage_id: widget.marriageId,
      )
          .then((value) {
        if (value.success == true) {
          var chart = context.read<LeaderboardProvider>().chart;
          groomData.add(LeaderBoardData(0, 0));
          brideData.add(LeaderBoardData(0, 0));
          totalgroomside = chart!.groomSide.guests.length;

          totalbrideside = chart.brideSide.guests.length;

          for (var i = 0; i < chart.groomSide.guests.length; i++) {
            groomData.add(LeaderBoardData(
                chart.groomSide.guests[i], chart.groomSide.points[i]));
            totalgroomsidepoint += chart.groomSide.points[i];
          }

          for (var i = 0; i < chart.brideSide.guests.length; i++) {
            brideData.add(LeaderBoardData(
                chart.brideSide.guests[i], chart.brideSide.points[i]));
            totalbridesidepoint += chart.brideSide.points[i];
          }
          setState(() {
            isLoading = false;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.back,
            // color: Colors.white,
          ),
        ),
        title: Text(
          "Chart",
          style: poppinsBold.copyWith(
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
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
                                  color: Colors.pink,
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
                        width: MediaQuery.of(context).size.width - 40,
                        child: SfCartesianChart(
                            plotAreaBorderWidth: 0,
                            enableAxisAnimation: true,
                            primaryXAxis: NumericAxis(),
                            primaryYAxis: NumericAxis(),
                            tooltipBehavior: TooltipBehavior(
                                enable: true), // Enables the tooltip.
                            series: <LineSeries<LeaderBoardData, int>>[
                              LineSeries<LeaderBoardData, int>(
                                  name: 'groom side',
                                  width: 3,
                                  yAxisName: 'Guests',
                                  xAxisName: 'Points',
                                  dataSource: groomData,
                                  xValueMapper: (LeaderBoardData point, _) =>
                                      point.point,
                                  yValueMapper: (LeaderBoardData point, _) =>
                                      point.guest,
                                  markerSettings:
                                      const MarkerSettings(isVisible: true),
                                  dataLabelSettings: const DataLabelSettings(
                                      isVisible: false,
                                      textStyle: TextStyle(
                                          color: Colors
                                              .blue)) // Enables the data label.
                                  ),
                              LineSeries<LeaderBoardData, int>(
                                  width: 3,
                                  yAxisName: 'Guests',
                                  name: 'bride side',
                                  xAxisName: 'Points',
                                  dataSource: brideData,
                                  xValueMapper: (LeaderBoardData point, _) =>
                                      point.point,
                                  yValueMapper: (LeaderBoardData point, _) =>
                                      point.guest,
                                  markerSettings:
                                      const MarkerSettings(isVisible: true),
                                  dataLabelSettings: const DataLabelSettings(
                                      isVisible: false,
                                      textStyle: TextStyle(
                                          color: Colors
                                              .pink)) // Enables the data label.
                                  )
                            ])),
                    const SizedBox(
                      height: 35,
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
                                      color: Colors.pink,
                                      size: 14,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      "Bride Side Guests earned",
                                      style:
                                          poppinsNormal.copyWith(fontSize: 12),
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
                                      "$totalbridesidepoint Pts",
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
                                        "By $totalbrideside guests",
                                        style: poppinsNormal.copyWith(
                                            fontSize: 10),
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
                                      style:
                                          poppinsNormal.copyWith(fontSize: 12),
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
                                      "$totalgroomsidepoint Pts",
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
                                        "By $totalgroomside guests",
                                        style: poppinsNormal.copyWith(
                                            fontSize: 10),
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

  final int guest;
  final int point;
}
