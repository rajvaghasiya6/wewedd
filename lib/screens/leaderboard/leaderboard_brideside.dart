import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/shared_preferences.dart';
import '../../providers/leaderboard_provider.dart';

class LeaderboardBrideside extends StatefulWidget {
  const LeaderboardBrideside({Key? key}) : super(key: key);

  @override
  State<LeaderboardBrideside> createState() => _LeaderboardBridesideState();
}

class _LeaderboardBridesideState extends State<LeaderboardBrideside> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<LeaderboardProvider>().getLeaderboard(
          marriage_id: sharedPrefs.marriageId, guest_from: 'bride_side');
    });
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = context.watch<LeaderboardProvider>().isLoading;
    var pointsList = context.watch<LeaderboardProvider>().points;
    return Scaffold(
      body: isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(children: [
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pointsList.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 20);
                    },
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                              color: timeGrey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: ListTile(
                            leading: Text(
                              "#${index + 1}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            title: Text(
                              pointsList[index].name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            trailing: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: lightBlack,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(25))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/gold.svg',
                                            color: index == 0
                                                ? const Color(0xffd4af37)
                                                : index == 1
                                                    ? const Color(0xffc0c0c0)
                                                    : index == 2
                                                        ? const Color(
                                                            0xffCD7F32)
                                                        : Colors.red,
                                            width: 20,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            pointsList[index].points.toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.red,
                                      size: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    })
              ])),
    );
  }
}
