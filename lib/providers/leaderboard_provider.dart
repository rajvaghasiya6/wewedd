import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/shared_preferences.dart';
import '../general/string_constants.dart';
import '../models/chart_model.dart';
import '../models/response_model.dart';
import 'user_provider.dart';

class LeaderboardProvider extends ChangeNotifier {
  bool isLoading = false;
  List<GuestPoint> points = [];
  ChartModel? chart;
  int currentguestposition = 0;
  int currentguestpoint = 0;
  Future<ResponseClass<List<GuestPoint>>> getLeaderboard(
      {required String marriage_id, required String guest_from}) async {
    String url = '${StringConstants.apiUrl}get_leaderboard';

    //Response
    ResponseClass<List<GuestPoint>> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: points);
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {
          "marriage_id": marriage_id,
          "guest_from": guest_from,
        },
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];

        List pointList = response.data["data"];
        List<GuestPoint> list =
            pointList.map((e) => GuestPoint.fromJson(e)).toList();
        responseClass.data = list;
        points = list;
        isLoading = false;
        notifyListeners();
        currentguestpoint = points
            .firstWhere((element) => element.guestId == sharedPrefs.guestId)
            .points;
        currentguestposition = points.indexWhere(
                (element) => element.guestId == sharedPrefs.guestId) +
            1;
        notifyListeners();
      }

      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("userHostedMarriages error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<ChartModel>> getChart({
    required String marriage_id,
  }) async {
    String url = '${StringConstants.apiUrl}get_chart';

    //Response
    ResponseClass<ChartModel> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: chart);
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {
          "marriage_id": marriage_id,
        },
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];

        responseClass.data = ChartModel.fromJson(response.data['data']);
        chart = ChartModel.fromJson(response.data['data']);
        isLoading = false;
        notifyListeners();
      }

      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("chart error ->" + e.toString());
      }
      return responseClass;
    }
  }
}

class GuestPoint {
  GuestPoint({
    required this.name,
    required this.guestfrom,
    required this.points,
    required this.guestId,
  });

  String name;
  String guestfrom;
  int points;
  String guestId;

  factory GuestPoint.fromJson(Map<String, dynamic> json) => GuestPoint(
      name: json["name"],
      guestfrom: json["guest_from"],
      points: json["points"],
      guestId: json["guest_id"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "guest_from": guestfrom,
        "points": points,
        "guest_id": guestId,
      };
}
