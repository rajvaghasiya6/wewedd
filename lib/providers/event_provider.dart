import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/shared_preferences.dart';
import '../general/string_constants.dart';
import '../models/events_model.dart';
import 'user_provider.dart';

class EventProvider with ChangeNotifier {
  bool isLoaded = false;
  List<EventModel> events = [];
  int currentIndex = 0;

  getEvents() async {
    String url = StringConstants.apiUrl +
        StringConstants.getAllEventForGuest +
        "/${sharedPrefs.marriageId}";

    try {
      Response response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List eventList = response.data["data"];
        List<EventModel> list =
            eventList.map((e) => EventModel.fromJson(e)).toList();
        events = list;
        isLoaded = true;
        notifyListeners();
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoaded = true;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
    } catch (e) {
      isLoaded = true;
      notifyListeners();
      if (kDebugMode) {
        log("event error ->" + e.toString());
      }
    }
  }
}
