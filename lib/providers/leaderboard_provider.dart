import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/string_constants.dart';
import '../models/response_model.dart';
import 'user_provider.dart';

class LeaderboardProvider extends ChangeNotifier {
  bool isLoading = false;
  List<GuestPoint> points = [];
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
}

class GuestPoint {
  GuestPoint({
    required this.name,
    required this.guestfrom,
    required this.points,
  });

  String name;
  String guestfrom;
  int points;

  factory GuestPoint.fromJson(Map<String, dynamic> json) => GuestPoint(
        name: json["name"],
        guestfrom: json["guest_from"],
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "guest_from": guestfrom,
        "points": points,
      };
}
