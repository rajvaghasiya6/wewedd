import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'general/shared_preferences.dart';
import 'hiveModels/recent_search_model.dart';
import 'models/theme_model.dart';
import 'providers/add_wedding_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/edit_wedding_provider.dart';
import 'providers/event_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/feed_request_provider.dart';
import 'providers/galleryProvider.dart';
import 'providers/guest_provider.dart';
import 'providers/guest_request_provider.dart';
import 'providers/hashtag_search_provider.dart';
import 'providers/leaderboard_provider.dart';
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
  await Hive.initFlutter();
  Hive.registerAdapter(RecentSearchAdapter());
  await Hive.openBox<RecentSearch>('recent_search');
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
              ChangeNotifierProvider(
                create: (context) => HashtagSearchProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => FeedRequestProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => GuestRequestProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => LeaderboardProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => EditWeddingProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => GalleryProvider(),
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
              ChangeNotifierProvider(
                create: (context) => AddWeddingProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => FeedProvider(),
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
