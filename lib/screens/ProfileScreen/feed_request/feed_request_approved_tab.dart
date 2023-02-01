import 'package:flutter/material.dart';

class FeedRequestApprovedTab extends StatefulWidget {
  const FeedRequestApprovedTab({Key? key}) : super(key: key);

  @override
  State<FeedRequestApprovedTab> createState() => _FeedRequestApprovedTabState();
}

class _FeedRequestApprovedTabState extends State<FeedRequestApprovedTab>
    with AutomaticKeepAliveClientMixin<FeedRequestApprovedTab> {
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
