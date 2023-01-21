import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/shared_preferences.dart';
import '../general/string_constants.dart';
import '../models/notification_model.dart';
import '../models/response_model.dart';
import 'user_provider.dart';

class NotificationProvider with ChangeNotifier {
  bool isLoaded = false;
  List<NotificationModel> notifications = [];

  Future<ResponseClass<List<NotificationModel>>> getNotifications(
      int page) async {
    String url = StringConstants.apiUrl + StringConstants.getAllNotification;

    var data = {
      "marriage_id": sharedPrefs.marriageId,
      // "guest_id": sharedPrefs.guestId,
      "page": page,
      "limit": 10
    };

    //Response
    ResponseClass<List<NotificationModel>> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: notifications);
    try {
      Response response = await dio.get(
        url,
        queryParameters: data,
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        if (response.data["pagination"] != null) {
          Pagination pagination =
              Pagination.fromJson(response.data["pagination"]);
          responseClass.pagination = pagination;
        }
        List notificationList = response.data["data"];
        List<NotificationModel> list =
            notificationList.map((e) => NotificationModel.fromJson(e)).toList();
        responseClass.data = list;
        if (page == 1) {
          notifications = list;
        } else {
          notifications.addAll(list);
        }
        isLoaded = true;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoaded = true;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isLoaded = true;
      notifyListeners();
      if (kDebugMode) {
        log("Notification error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
