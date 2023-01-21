import 'package:flutter/material.dart';

import '../general/navigation.dart';
import '../general/shared_preferences.dart';
import '../screens/HashtagSearchScreen/hashtag_search_screen.dart';
import '../screens/HomeScreen/home_screen.dart';
import 'loader.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
        const Duration(seconds: 3),
        () => nextScreenReplace(
            context,
            sharedPrefs.marriageId == ''
                ? HashtagSearchScreen()
                : HomeScreen()));
  }

  // checkLoginStatus() async {
  //   sharedPrefs.isLogin().then((value) {
  //     if (value) {
  //       nextScreenReplace(context, HashtagSearchScreen());
  //     } else {
  //       nextScreenReplace(context, const LoginScreen());
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return const Loader();
  }
}
