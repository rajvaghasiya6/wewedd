import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/helper_functions.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../hiveModels/recent_search_model.dart';
import '../../models/marriage_detail_model.dart';
import '../../providers/hashtag_search_provider.dart';
import '../../widgets/user_button.dart';
import '../AddWedding/add_wedding_screen.dart';
import '../HomeScreen/home_screen.dart';
import '../ProfileScreen/admin_profile.dart';
import 'add_guest_side.dart';
import 'searched_marriages.dart';

class HashtagSearchScreen extends StatefulWidget {
  const HashtagSearchScreen({Key? key}) : super(key: key);

  @override
  State<HashtagSearchScreen> createState() => _HashtagSearchScreenState();
}

class _HashtagSearchScreenState extends State<HashtagSearchScreen>
    with AutomaticKeepAliveClientMixin<HashtagSearchScreen> {
  TextEditingController searchController = TextEditingController();
  final Box<RecentSearch> dataBox = Hive.box('recent_search');
  List<MarriageDetail> searchMarriages = [];
  bool isRecentSearch = true;

  @override
  bool get wantKeepAlive => true;

  searchHashtag(BuildContext context, String hashtag) {
    if (searchController.text.trim() != '') {
      Provider.of<HashtagSearchProvider>(context, listen: false)
          .getHashtagSearchData(hashtag)
          .then((value) {
        if (value.success == true) {
          searchMarriages = [];
          value.data.forEach((val) {
            searchMarriages.add(MarriageDetail.fromJson(val));
          });
          nextScreen(
              context, SearchedMarriages(searchMarriages: searchMarriages));
        }
      });
    } else {
      Fluttertoast.showToast(msg: 'Enter Hashtag ');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: context.watch<HashtagSearchProvider>().isLoading ||
                context.watch<HashtagSearchProvider>().isaccessLoading
            ? const Center(child: CupertinoActivityIndicator())
            : Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 80,
                    child: Image.asset(
                      'assets/background_logo.png',
                      scale: 4.5,
                      opacity: const AlwaysStoppedAnimation(.15),
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  UserButton(
                                    url: sharedPrefs.guestProfileImage,
                                    size: 45,
                                    pushScreen: () {
                                      nextScreen(context, const AdminProfile());
                                    },
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        nextScreen(
                                            context, const AddWeddingScreen());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: timeGrey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        elevation: 15.0,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Text(
                                          "+ Add New Wedding",
                                          style: poppinsNormal.copyWith(
                                              color: grey, fontSize: 14),
                                        ),
                                      ))
                                ]),
                          ),
                          const SizedBox(
                            height: 250,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: scaffoldBlack,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(255, 89, 85, 89),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                    offset: Offset(-2, -2)),
                                BoxShadow(
                                    color: Color(0xff050509),
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                    offset: Offset(3, 3)),
                              ],
                            ),
                            child: TextFormField(
                              controller: searchController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) {
                                searchHashtag(
                                    context, searchController.text.trim());
                              },
                              validator: (val) {
                                if (val == '') {
                                  return 'Please Enter HashTag';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Search by wedding hashtag",
                                hintStyle: poppinsNormal.copyWith(
                                    color: grey, fontSize: 15),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    searchHashtag(
                                        context, searchController.text.trim());
                                  },
                                  child: Image.asset(
                                    'assets/search.png',
                                    scale: 3,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 20),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          dataBox.length > 0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Recently viewed wedding",
                                      style: poppinsBold.copyWith(
                                          color: white, fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 40,
                          ),
                          dataBox.length > 0
                              ? ValueListenableBuilder<Box<RecentSearch>>(
                                  valueListenable: dataBox.listenable(),
                                  builder:
                                      (context, Box<RecentSearch> items, _) {
                                    return ListView.separated(
                                      separatorBuilder: (_, index) =>
                                          const Divider(),
                                      itemCount: dataBox.values.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (_, index) {
                                        var data = dataBox.getAt(index);

                                        return GestureDetector(
                                          onTap: () {
                                            Provider.of<HashtagSearchProvider>(
                                                    context,
                                                    listen: false)
                                                .accessWedding(data!.marriageId,
                                                    sharedPrefs.mobileNo)
                                                .then((value) {
                                              if (value.success == true) {
                                                sharedPrefs.marriageId =
                                                    data.marriageId;
                                                sharedPrefs.guestId =
                                                    value.data['guest_id'];
                                                sharedPrefs.isAdmin =
                                                    value.data['is_admin'];
                                                if (value.data[
                                                        'guest_side_selected'] ==
                                                    true) {
                                                  nextScreen(
                                                      context, HomeScreen());
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AddGuestSideDialog(
                                                            marriageId:
                                                                data.marriageId,
                                                          ));
                                                }
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "you dont have access for this wedding");
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: timeGrey,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: lightBlack,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '#${data!.hashtag}',
                                                        style: poppinsBold
                                                            .copyWith(
                                                                color: white,
                                                                fontSize: 16),
                                                      ),
                                                      const SizedBox(
                                                        height: 14,
                                                      ),
                                                      Text(
                                                        data.weddingName,
                                                        style: poppinsNormal
                                                            .copyWith(
                                                                color: grey,
                                                                fontSize: 12),
                                                      ),
                                                      const SizedBox(
                                                        height: 14,
                                                      ),
                                                      Text(
                                                        format(DateTime.parse(
                                                            data.weddingDate)),
                                                        style: poppinsNormal
                                                            .copyWith(
                                                                color: grey,
                                                                fontSize: 10),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )
                              : Container(),
                          // isRecentSearch
                          //     ?
                          //     : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
