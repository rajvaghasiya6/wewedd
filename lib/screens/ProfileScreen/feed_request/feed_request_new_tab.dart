import 'package:flutter/material.dart';

class FeedRequestNewTab extends StatefulWidget {
  const FeedRequestNewTab({Key? key}) : super(key: key);

  @override
  State<FeedRequestNewTab> createState() => _FeedRequestNewTabState();
}

class _FeedRequestNewTabState extends State<FeedRequestNewTab>
    with AutomaticKeepAliveClientMixin<FeedRequestNewTab> {
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
