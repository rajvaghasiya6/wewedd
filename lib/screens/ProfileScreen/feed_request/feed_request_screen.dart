import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../general/color_constants.dart';
import '../../../general/text_styles.dart';
import '../../../widgets/GradientTabIndicator.dart';
import 'feed_request_approved_tab.dart';
import 'feed_request_new_tab.dart';
import 'feed_request_pending_tab.dart';
import 'feed_request_rejected_tab.dart';

class FeedRequestScreen extends StatelessWidget {
  FeedRequestScreen({required this.marriageId, Key? key}) : super(key: key);
  final String marriageId;
  final List<String> tabs = ["Pending", "Approved", "Rejected", "New"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 4,
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
                        "Feed Request",
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
                child: TabBarView(
                  children: [
                    FeedRequestPendingTab(marriageId: marriageId),
                    FeedRequestApprovedTab(marriageId: marriageId),
                    FeedRequestRejectedTab(marriageId: marriageId),
                    FeedRequestNewTab(marriageId: marriageId),
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
