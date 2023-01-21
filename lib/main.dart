import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'general/shared_preferences.dart';
import 'models/theme_model.dart';
import 'providers/dashboard_provider.dart';
import 'providers/event_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/galleryProvider.dart';
import 'providers/guest_provider.dart';
import 'providers/network_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_feed_provider.dart';
import 'providers/user_provider.dart';
import 'providers/wardrobe_provider.dart';
import 'widgets/splash.dart';

// /*Marriage Id*/
// late String marriageId;

void mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  runApp(
    const MyApp(),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (_, mode, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => DashboardProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => EventProvider(),
              ),
              StreamProvider(
                  create: (context) =>
                      NetworkStatusService().networkStatusController.stream,
                  initialData: NetworkStatus.online),
              ChangeNotifierProvider(
                create: (context) => UserProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => WardrobeProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => GalleryProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => FeedProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => NotificationProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => UserFeedProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => GuestProvider(),
              ),
            ],
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeModel().light,
                darkTheme: ThemeModel().dark,
                themeMode:
                    mode.darkTheme == true ? ThemeMode.dark : ThemeMode.light,
                home: const Splash()),
          );
        },
      ),
    );
  }
}

Future<void> _messageHandler(RemoteMessage message) async {
  log("--> ${message.data}");
}
