import 'package:flutter/material.dart';

import '../../general/color_constants.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../widgets/user_button.dart';
import '../ProfileScreen/profile_screen.dart';

class EventSearchScreen extends StatelessWidget {
  EventSearchScreen({Key? key}) : super(key: key);
  TextEditingController searchController = TextEditingController();

  searchHashtag() {}

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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UserButton(
                          url: sharedPrefs.guestProfileImage,
                          size: 45,
                          pushScreen: () {
                            nextScreen(context, const ProfileScreen());
                          },
                        ),
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 8.0),
                              child: Text(
                                "+ Add New Wedding",
                                style: poppinsNormal.copyWith(
                                    color: white, fontSize: 16),
                              ),
                            ))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 250),
                  child: Container(
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
                      onFieldSubmitted: (value) {},
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
                        suffixIcon: Image.asset(
                          'assets/search.png',
                          scale: 3,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
