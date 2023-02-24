import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../providers/leaderboard_provider.dart';
import '../../providers/theme_provider.dart';
import 'chart.dart';

class LeaderboardAll extends StatefulWidget {
  const LeaderboardAll({Key? key}) : super(key: key);

  @override
  State<LeaderboardAll> createState() => _LeaderboardAllState();
}

class _LeaderboardAllState extends State<LeaderboardAll> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) async {
      await context
          .read<LeaderboardProvider>()
          .getLeaderboard(marriage_id: sharedPrefs.marriageId, guest_from: '');
    });
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = context.watch<LeaderboardProvider>().isLoading;
    var pointsList = context.watch<LeaderboardProvider>().points;
    var currentguestposition =
        context.watch<LeaderboardProvider>().currentguestposition;
    var currentguestpoint =
        context.watch<LeaderboardProvider>().currentguestpoint;
    var theme = context.watch<ThemeProvider>().darkTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: greyToWhite,
      ),
      child: Scaffold(
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
                                color: theme
                                    ? timeGrey
                                    : timeGrey.withOpacity(0.08),
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
                                          color: theme
                                              ? timeGrey
                                              : timeGrey.withOpacity(0.1),
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
                                              pointsList[index]
                                                  .points
                                                  .toString(),
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
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.circle,
                                        color: pointsList[index].guestfrom ==
                                                "bride_side"
                                            ? Colors.red
                                            : Colors.blue,
                                        size: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      })
                ])),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                color: theme ? timeGrey : timeGrey.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                )),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: theme ? timeGrey : timeGrey.withOpacity(0.08),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "you've earned",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 3),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/gold.svg',
                                    color: Colors.red,
                                    width: 28,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    currentguestpoint.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xfff3686d),
                                Color(0xffed2831),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Your current rank is $currentguestposition',
                                  textAlign: TextAlign.center,
                                  style: poppinsBold.copyWith(
                                      color: white,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    nextScreen(
                                        context,
                                        Chart(
                                          marriageId: sharedPrefs.marriageId,
                                        ));
                                  },
                                  child: Text(
                                    'View Report',
                                    textAlign: TextAlign.center,
                                    style: poppinsBold.copyWith(
                                        color: white,
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}