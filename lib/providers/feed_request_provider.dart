import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/string_constants.dart';
import '../models/feed_request.dart';
import '../models/response_model.dart';
import 'user_provider.dart';

class FeedRequestProvider extends ChangeNotifier {
  bool isLoading = false;
  List<FeedRequest> feedRequest = [];
  Future<ResponseClass<List<FeedRequest>>> feedRequestsApi(
      {required String marriage_id, required String feed_status}) async {
    String url =
        '${StringConstants.apiUrl}get_all_feeds_from_a_single_marriage';

    //body Data

    //Response
    ResponseClass<List<FeedRequest>> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: feedRequest);
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {"marriage_id": marriage_id, "feed_status": feed_status},
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];

        List requestList = response.data["data"];
        List<FeedRequest> list =
            requestList.map((e) => FeedRequest.fromJson(e)).toList();
        responseClass.data = list;
        feedRequest = list;
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
        log("feed request error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass> updateFeedStatus(
      {required String feed_status, required List<String> feed_id}) async {
    String url = '${StringConstants.apiUrl}update_feed_status';

    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: {});
    try {
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {"feed_status": feed_status, "feed_id": feed_id},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseClass.success = response.data["is_success"];

        notifyListeners();
      }

      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }

      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      notifyListeners();
      if (kDebugMode) {
        log("status change request error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
