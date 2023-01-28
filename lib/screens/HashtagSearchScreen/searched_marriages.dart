import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../general/color_constants.dart';
import '../../general/helper_functions.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../hiveModels/recent_search_model.dart';
import '../../models/marriage_detail_model.dart';
import '../HomeScreen/home_screen.dart';

class SearchedMarriages extends StatefulWidget {
  SearchedMarriages({required this.searchMarriages, Key? key})
      : super(key: key);
  List<MarriageDetail> searchMarriages;
  @override
  State<SearchedMarriages> createState() => _SearchedMarriagesState();
}

class _SearchedMarriagesState extends State<SearchedMarriages> {
  final Box<RecentSearch> dataBox = Hive.box('recent_search');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Text(
                  '${widget.searchMarriages.length} Wedding Found',
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
                  itemCount: widget.searchMarriages.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        sharedPrefs.marriageId = '';
                        sharedPrefs.marriageId =
                            widget.searchMarriages[index].marriageId;
                        RecentSearch recentSearch = RecentSearch(
                            hashtag:
                                widget.searchMarriages[index].weddingHashtag,
                            marriageId:
                                widget.searchMarriages[index].marriageId,
                            weddingName:
                                widget.searchMarriages[index].marriageName,
                            weddingDate:
                                widget.searchMarriages[index].weddingDate,
                            searchTime: DateTime.now());
                        dataBox.put(widget.searchMarriages[index].marriageId,
                            recentSearch);

                        nextScreenReplace(context, HomeScreen());
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
                              Container(
                                width: 70,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: lightBlack,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget
                                        .searchMarriages[index].weddingHashtag,
                                    style: poppinsBold.copyWith(
                                        color: white, fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Text(
                                    widget.searchMarriages[index].marriageName,
                                    style: poppinsNormal.copyWith(
                                        color: grey, fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Text(
                                    format(
                                      DateTime.parse(widget
                                          .searchMarriages[index].weddingDate),
                                    ),
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
