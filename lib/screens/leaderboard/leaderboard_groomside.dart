import 'package:flutter/material.dart';

import '../../general/color_constants.dart';

class LeaderboardGroomside extends StatelessWidget {
  const LeaderboardGroomside({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            const BorderRadius.all(Radius.circular(12))),
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
        ]));
  }
}
