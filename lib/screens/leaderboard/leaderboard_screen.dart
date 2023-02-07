import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../general/color_constants.dart';
import '../../../general/text_styles.dart';
import '../../../widgets/GradientTabIndicator.dart';
import 'leaderboard_all.dart';
import 'leaderboard_brideside.dart';
import 'leaderboard_groomside.dart';

class LeaderboardScreen extends StatelessWidget {
  LeaderboardScreen({Key? key}) : super(key: key);
  final List<String> tabs = ["All", "Groom side", "Bride side"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    expandedHeight: 65,
                    flexibleSpace: const SizedBox(),
                    floating: true,
                    snap: true,
                    centerTitle: true,
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.back,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        "Guests Leaderboard",
                        style: gilroyBold.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: SliverPersistentHeaderDelegateImpl(
                      color: scaffoldBlack,
                      tabBar: TabBar(
                        isScrollable: true,
                        indicator: MyCustomIndicator(
                          color: Colors.white,
                          height: 1,
                        ),
                        indicatorSize: TabBarIndicatorSize.label,
                        // indicatorPadding: const EdgeInsets.only(bottom: 5),
                        unselectedLabelColor: Colors.grey[600],
                        labelStyle: gilroyBold.copyWith(fontSize: 13),
                        tabs: tabs.map((e) {
                          return Tab(text: e);
                        }).toList(),
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                decoration: const BoxDecoration(),
                child: const TabBarView(
                  children: [
                    LeaderboardAll(),
                    LeaderboardGroomside(),
                    LeaderboardBrideside()
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class SliverPersistentHeaderDelegateImpl
    extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const SliverPersistentHeaderDelegateImpl({
    Color color = Colors.white,
    required this.tabBar,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    overlapsContent = false;

    return Container(
      decoration: BoxDecoration(color: scaffoldBlack),
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          tabBar,
        ],
      ),
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height - 8;

  @override
  double get minExtent => tabBar.preferredSize.height - 8;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
