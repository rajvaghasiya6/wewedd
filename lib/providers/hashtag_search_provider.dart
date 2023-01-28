import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/string_constants.dart';
import '../models/response_model.dart';
import 'user_provider.dart';

class HashtagSearchProvider extends ChangeNotifier {
  bool isLoaded = false;
  bool isLoading = false;
//  List<MarriageDetail>? searchMarriageDetails = [];

  Future<ResponseClass> getHashtagSearchData(String hashtag) async {
    String url = "${StringConstants.apiUrl}get_all_marriages";

    //Response
    ResponseClass responseClass = ResponseClass(
      success: false,
      message: "Something went wrong",
    );
    try {
      isLoaded = true;
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(url, data: {"hashtag": hashtag});
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = response.data["data"];
        // response.data['data'].forEach((val) {
        //   responseClass.data.add(MarriageDetail.fromJson(val)) ;
        //   //  searchMarriageDetails!.add(MarriageDetail.fromJson(val));
        // });
        // print(responseClass.data);
        // // responseClass.data = response.data['data'].forEach((val) {
        // //   searchMarriageDetails?.add(MarriageDetail.fromJson(val));
        // // });

        // responseClass.data = searchMarriageDetails;
        //notifyListeners();
        isLoading = false;
        isLoaded = false;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      log(e.toString());
      isLoaded = false;
      isLoading = false;
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      notifyListeners();

      return responseClass;
    } on SocketException catch (e) {
      isLoaded = false;
      isLoading = false;
      Fluttertoast.showToast(msg: "No internet");
      notifyListeners();
      if (kDebugMode) {
        log("search error->" + e.toString());
      }

      return responseClass;
    } catch (e) {
      isLoaded = false;
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("search error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
