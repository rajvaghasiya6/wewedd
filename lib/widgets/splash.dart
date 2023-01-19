import 'package:flutter/material.dart';

import '../general/navigation.dart';
import '../general/shared_preferences.dart';
import '../screens/AuthenticationScreens/login_screen.dart';
import '../screens/EventSearchScreen/event_search_screen.dart';
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
    // context.read<DashboardProvider>().getDashboard().then((value) {
    //   if (value.success == true) {
    //     if (value.data != null) {
    //       context.read<DashboardProvider>().dashboardModel = value.data!;
    //       value.data!.isDark
    //           ? context.read<ThemeProvider>().setDark()
    //           : context.read<ThemeProvider>().setLight();
    //       context.read<ThemeProvider>().gradient = LinearGradient(
    //           begin: Alignment.centerLeft,
    //           end: Alignment.centerRight,
    //           colors: [
    //             Color(int.parse("0xff" + value.data!.secondaryColor.first)),
    //             Color(int.parse("0xff" + value.data!.secondaryColor.last)),
    //           ]);
    //     }
    //     checkLoginStatus();
    //   }
    // });

    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPrefs.isLogin().then((value) {
      if (value) {
        nextScreenReplace(context, EventSearchScreen());
      } else {
        nextScreenReplace(context, const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Loader();
  }
}
