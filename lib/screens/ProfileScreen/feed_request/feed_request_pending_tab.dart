import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../general/string_constants.dart';
import '../../../general/text_styles.dart';
import '../../../providers/feed_request_provider.dart';

class FeedRequestPendingTab extends StatefulWidget {
  const FeedRequestPendingTab({required this.marriageId, Key? key})
      : super(key: key);
  final String marriageId;
  @override
  State<FeedRequestPendingTab> createState() => _FeedRequestPendingTabState();
}

class _FeedRequestPendingTabState extends State<FeedRequestPendingTab> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<FeedRequestProvider>().feedRequestsApi(
          feed_status: 'Pending', marriage_id: widget.marriageId);
    });
  }

  List<String> selectedItems = [];

  bool isMultiSelectionEnabled = false;

  String getSelectedItemCount() {
    return selectedItems.isNotEmpty ? selectedItems.length.toString() : "0";
  }

  void doMultiSelection(String id) {
    if (isMultiSelectionEnabled) {
      setState(() {
        if (selectedItems.contains(id)) {
          selectedItems.remove(id);
        } else {
          selectedItems.add(id);
        }
      });
    } else {
      //
    }
  }

  GridTile getGridItem(String path, String id) {
    return GridTile(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                doMultiSelection(id);
              },
              onLongPress: () {
                isMultiSelectionEnabled = true;
                doMultiSelection(id);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  path,
                  color: Colors.black
                      .withOpacity(selectedItems.contains(id) ? 1 : 0),
                  colorBlendMode: BlendMode.color,
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Visibility(
                visible: selectedItems.contains(id),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.green),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  ),
                )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = context.watch<FeedRequestProvider>().isLoading;
    var pendingFeed = context.watch<FeedRequestProvider>().feedRequest;
    return isLoading
        ? const CupertinoActivityIndicator()
        : pendingFeed.isEmpty
            ? const Center(child: Text("No request found..."))
            : Scaffold(
                body: ListView(
                  children: [
                    isMultiSelectionEnabled
                        ? Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isMultiSelectionEnabled = false;
                                      selectedItems.clear();
                                    });
                                  },
                                  icon: const Icon(Icons.close)),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                isMultiSelectionEnabled
                                    ? getSelectedItemCount()
                                    : '',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    GridView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return getGridItem(
                            '${StringConstants.apiUrl}${pendingFeed[index].feedImage}',
                            pendingFeed[index].feedId);
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: pendingFeed.length,
                    ),
                  ],
                ),
                bottomNavigationBar: isMultiSelectionEnabled
                    ? Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xfff3686d),
                            Color(0xffed2831),
                          ]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<FeedRequestProvider>(context,
                                          listen: false)
                                      .updateFeedStatus(
                                          feed_status: "Rejected",
                                          feed_id: selectedItems)
                                      .then((value) {
                                    if (value.success == true) {
                                      for (var element in selectedItems) {
                                        pendingFeed.removeWhere(
                                            (val) => val.feedId == element);
                                      }
                                      isMultiSelectionEnabled = false;
                                      selectedItems.clear();
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Something Went Wrong");
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Reject",
                                      style:
                                          poppinsNormal.copyWith(fontSize: 20),
                                    ),
                                    const Icon(
                                      Icons.close,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Provider.of<FeedRequestProvider>(context,
                                          listen: false)
                                      .updateFeedStatus(
                                          feed_status: "Approved",
                                          feed_id: selectedItems)
                                      .then((value) {
                                    if (value.success == true) {
                                      for (var element in selectedItems) {
                                        pendingFeed.removeWhere(
                                            (val) => val.feedId == element);
                                      }
                                      isMultiSelectionEnabled = false;
                                      selectedItems.clear();
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Something Went Wrong");
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.done),
                                    Text(
                                      'Accept',
                                      style:
                                          poppinsNormal.copyWith(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              );
  }
}
