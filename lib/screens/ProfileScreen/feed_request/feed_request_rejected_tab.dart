import 'package:flutter/material.dart';

class FeedRequestRejectedTab extends StatefulWidget {
  const FeedRequestRejectedTab({Key? key}) : super(key: key);

  @override
  State<FeedRequestRejectedTab> createState() => _FeedRequestRejectedTabState();
}

class _FeedRequestRejectedTabState extends State<FeedRequestRejectedTab>
    with AutomaticKeepAliveClientMixin<FeedRequestRejectedTab> {
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
