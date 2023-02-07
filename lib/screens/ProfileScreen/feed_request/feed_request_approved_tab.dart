import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../general/string_constants.dart';
import '../../../providers/feed_request_provider.dart';

class FeedRequestApprovedTab extends StatefulWidget {
  const FeedRequestApprovedTab({required this.marriageId, Key? key})
      : super(key: key);
  final String marriageId;
  @override
  State<FeedRequestApprovedTab> createState() => _FeedRequestApprovedTabState();
}

class _FeedRequestApprovedTabState extends State<FeedRequestApprovedTab> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<FeedRequestProvider>().feedRequestsApi(
          feed_status: 'Approved', marriage_id: widget.marriageId);
    });
  }

  GridTile getGridItem(String path) {
    return GridTile(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                path,
                colorBlendMode: BlendMode.color,
                fit: BoxFit.cover,
                height: 150,
                width: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = context.watch<FeedRequestProvider>().isLoading;
    var approvedFeed = context.watch<FeedRequestProvider>().feedRequest;
    return isLoading
        ? const CupertinoActivityIndicator()
        : approvedFeed.isEmpty
            ? const Center(child: Text("No Approved Feed found..."))
            : Scaffold(
                body: GridView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return getGridItem(
                        '${StringConstants.apiUrl}${approvedFeed[index].feedImage}');
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: approvedFeed.length,
                ),
              );
  }
}
