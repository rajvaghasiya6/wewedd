import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wedding/general/shared_preferences.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/models/guest_feed_model.dart';
import 'package:wedding/models/response_model.dart';
import 'package:wedding/providers/user_provider.dart';

import '../main.dart';

class UserFeedProvider with ChangeNotifier {
  bool isLoadedGuestFeed = false;
  bool isLoadedBookMarkedFeed = false;
  List<GuestFeedModel> guestFeed = [];
  List<String> bookMarkedFeed = [];

  Future<ResponseClass<List<GuestFeedModel>>> getGuestFeed(
      {required String type}) async {
    String url = StringConstants.apiUrl +
        StringConstants.getAllFeedsGuest +
        '/${sharedPrefs.guestId}';

    //Response
    ResponseClass<List<GuestFeedModel>> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      Response response =
          await dio.get(url, queryParameters: {"feed_status": type});
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        List tempList = response.data["data"];
        List<GuestFeedModel> galleryList =
            tempList.map((e) => GuestFeedModel.fromJson(e)).toList();

        guestFeed = galleryList;
        responseClass.data = galleryList;
        isLoadedGuestFeed = true;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoadedGuestFeed = true;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isLoadedGuestFeed = true;
      notifyListeners();
      if (kDebugMode) {
        log("guest feed error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<List<String>>> getBookMarkedFeed() async {
    String url = StringConstants.apiUrl + StringConstants.viewBookmarkFeed;

    //Response
    ResponseClass<List<String>> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      Response response = await dio.get(url, queryParameters: {
        "marriage_id": marriageId,
        "guest_id": sharedPrefs.guestId
      });
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        List tempList = response.data["data"];
        List<String> galleryList = tempList.map((e) => e.toString()).toList();
        bookMarkedFeed = galleryList;
        responseClass.data = galleryList;
        isLoadedBookMarkedFeed = true;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoadedBookMarkedFeed = true;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isLoadedGuestFeed = true;
      notifyListeners();
      if (kDebugMode) {
        log("guest feed error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
