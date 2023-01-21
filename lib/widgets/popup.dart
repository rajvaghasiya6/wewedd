import 'package:flutter/material.dart';

import '../general/navigation.dart';
import '../general/shared_preferences.dart';
import '../general/text_styles.dart';
import '../screens/HashtagSearchScreen/hashtag_search_screen.dart';

class Popup extends StatelessWidget {
  final String message;

  const Popup({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,
              style: gilroyNormal.copyWith(fontSize: 14, letterSpacing: 0.5))
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            sharedPrefs.logout(context).then((value) {
              if (value == true) {
                nextScreenCloseOthers(context, HashtagSearchScreen());
              }
            });
          },
          child: const Text("Yes"),
        ),
      ],
    );
  }
}

class FeedPopup extends StatelessWidget {
  final String message;

  const FeedPopup({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,
              style: gilroyNormal.copyWith(fontSize: 14, letterSpacing: 0.5))
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Okay"),
        ),
      ],
    );
  }
}
