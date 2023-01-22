import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../hiveModels/recent_search_model.dart';
import '../../providers/hashtag_search_provider.dart';
import '../AddWedding/add_wedding_screen.dart';
import '../AuthenticationScreens/login_screen.dart';
import '../HomeScreen/home_screen.dart';

class HashtagSearchScreen extends StatefulWidget {
  const HashtagSearchScreen({Key? key}) : super(key: key);

  @override
  State<HashtagSearchScreen> createState() => _HashtagSearchScreenState();
}

class _HashtagSearchScreenState extends State<HashtagSearchScreen>
    with AutomaticKeepAliveClientMixin<HashtagSearchScreen> {
  TextEditingController searchController = TextEditingController();
  final Box<RecentSearch> dataBox = Hive.box('recent_search');

  bool isRecentSearch = true;

  @override
  bool get wantKeepAlive => true;

  checkLoginStatus(BuildContext context) async {
    sharedPrefs.isLogin().then((value) {
      if (value) {
        nextScreen(context, HomeScreen());
      } else {
        nextScreen(context, const LoginScreen());
      }
    });
  }

  searchHashtag(BuildContext context, String hashtag) {
    if (searchController.text.trim() != '') {
      Provider.of<HashtagSearchProvider>(context, listen: false)
          .getHashtagSearchData(hashtag)
          .then((value) {
        if (value.success == true) {
          if (value.data != null && value.message != '0 marriage found') {
            sharedPrefs.marriageId = value.data!.marriageId;
            RecentSearch recentSearch = RecentSearch(
                hashtag: value.data!.weddingHashtag,
                marriageId: value.data!.marriageId,
                weddingName: value.data!.marriageName,
                weddingDate: value.data!.weddingDate,
                searchTime: DateTime.now());
            dataBox.put(value.data!.marriageId, recentSearch);

            checkLoginStatus(context);
          } else {
            Fluttertoast.showToast(msg: 'No hashtag');
          }
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
        child:
            //  context.watch<HashtagSearchProvider>().isLoaded
            //     ? const Center(child: Loader())
            //     :
            Stack(
          children: [
            Positioned(
              right: 0,
              top: 150,
              child: Image.asset(
                'assets/background_logo.png',
                scale: 4,
                opacity: const AlwaysStoppedAnimation(.2),
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // sharedPrefs.guestId != ''
                            //     ? UserButton(
                            //         url: sharedPrefs.guestProfileImage,
                            //         size: 45,
                            //         pushScreen: () {
                            //           nextScreen(
                            //               context, const ProfileScreen());
                            //         },
                            //       )
                            //     : Container(),
                            ElevatedButton(
                                onPressed: () {
                                  nextScreen(context, const AddWeddingScreen());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: timeGrey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 15.0,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    "+ Add New Wedding",
                                    style: poppinsNormal.copyWith(
                                        color: white, fontSize: 16),
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
                              color: Color(0xff332e34),
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
                          searchHashtag(context, searchController.text.trim());
                        },
                        validator: (val) {
                          if (val == '') {
                            return 'Please Enter HashTag';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Search by wedding hashtag",
                          hintStyle:
                              poppinsNormal.copyWith(color: grey, fontSize: 15),
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
                                "Recently viewd wedding",
                                style: poppinsBold.copyWith(
                                    color: white, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 30,
                    ),
                    ValueListenableBuilder<Box<RecentSearch>>(
                      valueListenable: dataBox.listenable(),
                      builder: (context, Box<RecentSearch> items, _) {
                        return ListView.separated(
                          separatorBuilder: (_, index) => const Divider(),
                          itemCount: dataBox.values.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            var data = dataBox.getAt(index);

                            return GestureDetector(
                              onTap: () {
                                sharedPrefs.marriageId = data!.marriageId;
                                checkLoginStatus(context);
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
                                            data!.hashtag,
                                            style: poppinsBold.copyWith(
                                                color: white, fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Text(
                                            data.weddingName,
                                            style: poppinsNormal.copyWith(
                                                color: grey, fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Text(
                                            data.weddingDate,
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
                        );
                      },
                    ),
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
