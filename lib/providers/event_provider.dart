import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/shared_preferences.dart';
import '../general/string_constants.dart';
import '../models/events_model.dart';
import '../models/response_model.dart';
import 'user_provider.dart';

class EventProvider with ChangeNotifier {
  bool isLoaded = false;
  bool isLoading = false;
  bool isaddLoading = false;
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

  Future<ResponseClass> addNewEdvent({
    required String marriage_id,
    required String event_name,
    required String event_tagline,
    required String event_date,
    required String event_time,
    required bool is_dress_code,
    required String event_venue,
    required String for_men,
    required String for_women,
  }) async {
    String url = '${StringConstants.apiUrl}add_new_event';

    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: {});
    try {
      isaddLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {
          "marriage_id": marriage_id,
          "event_name": event_name,
          "event_tagline": event_tagline,
          "event_date": event_date,
          "event_time": event_time,
          "is_dress_code": is_dress_code,
          "event_venue": event_venue,
          "dress_code": {
            "for_men": for_men,
            "for_women": for_women,
          }
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseClass.success = response.data["is_success"];
        print(response.data['message']);
        isaddLoading = false;
        notifyListeners();
      }

      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isaddLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isaddLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("status change request error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
