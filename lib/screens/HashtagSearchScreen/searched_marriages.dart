import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/helper_functions.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/string_constants.dart';
import '../../general/text_styles.dart';
import '../../hiveModels/recent_search_model.dart';
import '../../providers/hashtag_search_provider.dart';
import '../HomeScreen/home_screen.dart';
import 'add_guest_side.dart';

class SearchedMarriages extends StatefulWidget {
  const SearchedMarriages(
      {required this.hashtag,
      //  required this.searchMarriages,
      Key? key})
      : super(key: key);
  final String hashtag;
//  List<MarriageDetail> searchMarriages;
  @override
  State<SearchedMarriages> createState() => _SearchedMarriagesState();
}

class _SearchedMarriagesState extends State<SearchedMarriages> {
  final Box<RecentSearch> dataBox = Hive.box('recent_search');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<HashtagSearchProvider>(context, listen: false)
          .getHashtagSearchData(widget.hashtag);
    });
  }

  @override
  Widget build(BuildContext context) {
    var searchList =
        context.watch<HashtagSearchProvider>().searchMarriageDetails;
    var isaccessLoading =
        context.watch<HashtagSearchProvider>().isaccessLoading;
    var isLoading = context.watch<HashtagSearchProvider>().isLoading;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: isLoading || isaccessLoading
            ? const Center(child: CupertinoActivityIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        '${searchList.length} Wedding Found',
                        style: poppinsBold.copyWith(color: white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.separated(
                        separatorBuilder: (_, index) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                        itemCount: searchList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onTap: () {
                              Provider.of<HashtagSearchProvider>(context,
                                      listen: false)
                                  .accessWedding(searchList[index].marriageId!,
                                      sharedPrefs.mobileNo)
                                  .then((value) {
                                if (value.success == true) {
                                  sharedPrefs.marriageId =
                                      searchList[index].marriageId!;
                                  sharedPrefs.guestId = value.data['guest_id'];
                                  sharedPrefs.isAdmin = value.data['is_admin'];
                                  if (value.data['guest_side_selected'] ==
                                      true) {
                                    RecentSearch recentSearch = RecentSearch(
                                        hashtag:
                                            searchList[index].weddingHashtag!,
                                        marriageId:
                                            searchList[index].marriageId!,
                                        weddingName:
                                            searchList[index].marriageName!,
                                        weddingDate:
                                            searchList[index].weddingDate ?? '',
                                        weddingLogo:
                                            searchList[index].weddingLogo ?? '',
                                        searchTime: DateTime.now());
                                    dataBox.put(searchList[index].marriageId,
                                        recentSearch);

                                    nextScreenReplace(context, HomeScreen());
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AddGuestSideDialog(
                                                isPrivate: false,
                                                marriageId: searchList[index]
                                                        .marriageId ??
                                                    ''));
                                  }
                                } else {
                                  if (value.data['guest_side_selected'] ==
                                      true) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "you dont have access for this wedding");
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AddGuestSideDialog(
                                                isPrivate: true,
                                                marriageId: searchList[index]
                                                        .marriageId ??
                                                    ''));
                                  }
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: timeGrey,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  children: [
                                    searchList[index].weddingLogo != ''
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: SizedBox(
                                              height: 100,
                                              width: 70,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    StringConstants.apiUrl +
                                                        searchList[index]
                                                            .weddingLogo!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 4.0, left: 4),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: black,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CupertinoActivityIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        grey.withOpacity(0.4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 70,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: lightBlack,
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          searchList[index].weddingHashtag!,
                                          style: poppinsBold.copyWith(
                                              color: white, fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        Text(
                                          searchList[index].marriageName!,
                                          style: poppinsNormal.copyWith(
                                              color: grey, fontSize: 12),
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        Text(
                                          searchList[index].weddingDate != null
                                              ? format(
                                                  DateTime.parse(
                                                      searchList[index]
                                                          .weddingDate!),
                                                )
                                              : '',
                                          style: poppinsNormal.copyWith(
                                              color: grey, fontSize: 10),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
