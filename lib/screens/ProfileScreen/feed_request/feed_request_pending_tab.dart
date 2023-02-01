import 'package:flutter/material.dart';

class FeedRequestPendingTab extends StatefulWidget {
  const FeedRequestPendingTab({Key? key}) : super(key: key);

  @override
  State<FeedRequestPendingTab> createState() => _FeedRequestPendingTabState();
}

class _FeedRequestPendingTabState extends State<FeedRequestPendingTab>
    with AutomaticKeepAliveClientMixin<FeedRequestPendingTab> {
  @override
  bool get wantKeepAlive => true;

  bool isLoaded = false, isLoading = false;
  //List<GuestFeedModel> allRequest = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Center(child: Text("No feed request found..."));
  }
}
