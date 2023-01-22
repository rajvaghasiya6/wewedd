import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/string_constants.dart';
import '../models/marriage_detail_model.dart';
import '../models/response_model.dart';
import 'user_provider.dart';

class HashtagSearchProvider extends ChangeNotifier {
  bool isLoaded = false;
  MarriageDetail? marriageDetail;

  Future<ResponseClass<MarriageDetail>> getHashtagSearchData(
      String hashtag) async {
    String url = "${StringConstants.apiUrl}get_all_marriages";

    //Response
    ResponseClass<MarriageDetail> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: marriageDetail);
    try {
      isLoaded = true;
      Response response = await dio.post(url, data: {"text": hashtag});
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = MarriageDetail.fromJson(response.data["data"][0]);
        marriageDetail = responseClass.data;

        isLoaded = false;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      log(e.toString());
      isLoaded = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } on SocketException catch (e) {
      isLoaded = false;
      notifyListeners();
      if (kDebugMode) {
        log("search error->" + e.toString());
      }
      Fluttertoast.showToast(msg: "No internet");
      return responseClass;
    } catch (e) {
      isLoaded = false;
      notifyListeners();
      if (kDebugMode) {
        log("search error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
