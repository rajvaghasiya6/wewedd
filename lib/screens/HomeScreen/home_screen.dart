import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/dashboard_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_provider.dart';
import '../FeedScreen/feed_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  static final GlobalKey<_HomeScreenState> pageControl = GlobalKey();

  HomeScreen({Key? key}) : super(key: pageControl);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static PageController pageController = PageController();
  late FirebaseMessaging messaging;

  jumpToHome() {
    setState(() {
      pageController.animateToPage(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  jumpToFeed() {
    setState(() {
      pageController.animateToPage(1,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      if (value != null) {
        context.read<UserProvider>().updateFcmToken(token: value);
      }
    });

    context.read<DashboardProvider>().getDashboard().then((value) {
      if (value.success == true) {
        if (value.data != null) {
          context.read<DashboardProvider>().dashboardModel = value.data!;
          value.data!.isDark
              ? context.read<ThemeProvider>().setDark()
              : context.read<ThemeProvider>().setLight();
          context.read<ThemeProvider>().gradient = LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(int.parse("0xff" + value.data!.secondaryColor.first)),
                Color(int.parse("0xff" + value.data!.secondaryColor.last)),
              ]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (pageController.page == 1) {
          pageController.animateToPage(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn);
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: PageView(
          controller: pageController,
          children: const [
            DashboardScreen(),
            FeedScreen(),
          ],
        ),
      ),
    );
  }
}
