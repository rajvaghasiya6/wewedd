import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../general/color_constants.dart';
import '../../general/helper_functions.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/string_constants.dart';
import '../../general/text_styles.dart';
import '../../hiveModels/recent_search_model.dart';
import '../AddWedding/add_wedding_screen.dart';
import '../ProfileScreen/admin/admin_profile.dart';
import 'searched_marriages.dart';

class HashtagSearchScreen extends StatelessWidget {
  HashtagSearchScreen({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();

  final Box<RecentSearch> dataBox = Hive.box('recent_search');

//  List<MarriageDetail> searchMarriages = [];

  bool isRecentSearch = true;

  // searchHashtag(BuildContext context, String hashtag) {
  //   if (searchController.text.trim() != '') {
  //     Provider.of<HashtagSearchProvider>(context, listen: false)
  //         .getHashtagSearchData(hashtag)
  //         .then((value) {
  //       if (value.success == true) {
  //         searchMarriages = [];
  //         value.data.forEach((val) {
  //           searchMarriages.add(MarriageDetail.fromJson(val));
  //         });
  //         nextScreen(
  //             context, SearchedMarriages(searchMarriages: searchMarriages));
  //       }
  //     });
  //   } else {
  //     Fluttertoast.showToast(msg: 'Enter Hashtag ');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // var loading = context.watch<HashtagSearchProvider>().isLoading;
    // var accessLoading = context.watch<HashtagSearchProvider>().isaccessLoading;
    return Scaffold(
      body: SafeArea(
        child:
            // loading || accessLoading
            //     ? const Center(child: CupertinoActivityIndicator())
            //  :
            Stack(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                nextScreen(context, const AdminProfile());
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "icons/user.svg",
                                    height: 45,
                                    width: 45,
                                  ),
                                  Container(
                                    height: 45 * 0.58,
                                    width: 45 * 0.58,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: sharedPrefs.guestProfileImage != ''
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  '${StringConstants.apiUrl}${sharedPrefs.guestProfileImage}',
                                              height: 45 * 0.59,
                                              width: 45 * 0.59,
                                              fit: BoxFit.cover,
                                              errorWidget: (_, __, error) =>
                                                  Padding(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: SvgPicture.asset(
                                                  "icons/user_icon.svg",
                                                  height: 45 * 0.44,
                                                  width: 45 * 0.44,
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              "icons/user_icon.svg",
                                              height: 45 * 0.44,
                                              width: 45 * 0.44,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  nextScreen(context, const AddWeddingScreen());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: timeGrey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 0,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                          //  searchHashtag(context, searchController.text.trim());
                          if (searchController.text.trim() != '') {
                            nextScreen(
                                context,
                                SearchedMarriages(
                                    hashtag: searchController.text.trim()));
                          } else {
                            Fluttertoast.showToast(msg: 'Enter Hashtag ');
                          }
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
                              // searchHashtag(
                              //     context, searchController.text.trim());
                              if (searchController.text.trim() != '') {
                                nextScreen(
                                    context,
                                    SearchedMarriages(
                                        hashtag: searchController.text.trim()));
                              } else {
                                Fluttertoast.showToast(msg: 'Enter Hashtag ');
                              }
                            },
                            child: Image.asset(
                              'assets/search.png',
                              scale: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
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
                                      // Provider.of<HashtagSearchProvider>(
                                      //         context,
                                      //         listen: false)
                                      //     .accessWedding(data!.marriageId,
                                      //         sharedPrefs.mobileNo)
                                      //     .then((value) {
                                      //   if (value.success == true) {
                                      //     sharedPrefs.marriageId =
                                      //         data.marriageId;
                                      //     sharedPrefs.guestId =
                                      //         value.data['guest_id'];
                                      //     sharedPrefs.isAdmin =
                                      //         value.data['is_admin'];
                                      //     if (value.data[
                                      //             'guest_side_selected'] ==
                                      //         true) {
                                      //       nextScreen(context, HomeScreen());
                                      //     } else {
                                      //       showDialog(
                                      //           context: context,
                                      //           builder: (context) =>
                                      //               AddGuestSideDialog(
                                      //                 isPrivate: false,
                                      //                 marriageId:
                                      //                     data.marriageId,
                                      //               ));
                                      //     }
                                      //   } else {
                                      //     if (value.data[
                                      //             'guest_side_selected'] ==
                                      //         true) {
                                      //       Fluttertoast.showToast(
                                      //           msg:
                                      //               "you dont have access for this wedding");
                                      //     } else {
                                      //       showDialog(
                                      //           context: context,
                                      //           builder: (context) =>
                                      //               AddGuestSideDialog(
                                      //                 isPrivate: true,
                                      //                 marriageId:
                                      //                     data.marriageId,
                                      //               ));
                                      //     }
                                      //   }
                                      // });
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
                                            data?.weddingLogo != ''
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: SizedBox(
                                                      height: 100,
                                                      width: 70,
                                                      child: CachedNetworkImage(
                                                        imageUrl: StringConstants
                                                                .apiUrl +
                                                            data!.weddingLogo,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 4.0,
                                                                  left: 4),
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: black,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            const Center(
                                                                child:
                                                                    CupertinoActivityIndicator()),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: grey
                                                                .withOpacity(
                                                                    0.4),
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '#${data!.hashtag}',
                                                  style: poppinsBold.copyWith(
                                                      color: white,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                Text(
                                                  data.weddingName,
                                                  style: poppinsNormal.copyWith(
                                                      color: grey,
                                                      fontSize: 12),
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                Text(
                                                  format(DateTime.parse(
                                                      data.weddingDate)),
                                                  style: poppinsNormal.copyWith(
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
