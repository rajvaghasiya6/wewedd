import 'package:flutter/material.dart';

import '../../general/color_constants.dart';
import '../../general/navigation.dart';
import '../../general/text_styles.dart';
import 'chart.dart';

class LeaderboardAll extends StatelessWidget {
  const LeaderboardAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(children: [
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
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
                        leading: const Text(
                          "#1",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        title: const Text(
                          "Guest name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                              color: lightBlack,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.heart_broken),
                                Text(
                                  "50",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
                })
          ])),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              color: timeGrey,
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
                      color: lightBlack,
                      borderRadius: const BorderRadius.all(Radius.circular(6))),
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
                                horizontal: 12, vertical: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.heart_broken),
                                Text(
                                  "70",
                                  style: TextStyle(
                                    fontSize: 18,
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
                                'Your current rank is 30th',
                                textAlign: TextAlign.center,
                                style: poppinsBold.copyWith(
                                    color: white,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              GestureDetector(
                                onTap: () {
                                  nextScreen(context, const Chart());
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
    );
  }
}
