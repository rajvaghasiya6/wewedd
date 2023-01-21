import 'package:flutter/material.dart';

import '../../general/color_constants.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../AuthenticationScreens/login_screen.dart';
import '../HomeScreen/home_screen.dart';

class HashtagSearchScreen extends StatelessWidget {
  HashtagSearchScreen({Key? key}) : super(key: key);
  TextEditingController searchController = TextEditingController();
  bool isRecentSearch = true;
  checkLoginStatus(BuildContext context) async {
    sharedPrefs.isLogin().then((value) {
      if (value) {
        nextScreen(context, HomeScreen());
      } else {
        nextScreen(context, const LoginScreen());
      }
    });
  }

  searchHashtag(BuildContext context) {
    sharedPrefs.marriageId = '30202250030_9785223311';
    nextScreen(context, const LoginScreen());
    //  checkLoginStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                                onPressed: () {},
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
                          searchHashtag(context);
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
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
                              searchHashtag(context);
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
                    isRecentSearch
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Recently viewd wedding",
                                  style: poppinsBold.copyWith(
                                      color: white, fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
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
                                              "#Hashtag",
                                              style: poppinsBold.copyWith(
                                                  color: white, fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            Text(
                                              "Bride weds groom",
                                              style: poppinsNormal.copyWith(
                                                  color: grey, fontSize: 12),
                                            ),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            Text(
                                              "wedding date",
                                              style: poppinsNormal.copyWith(
                                                  color: grey, fontSize: 10),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
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
