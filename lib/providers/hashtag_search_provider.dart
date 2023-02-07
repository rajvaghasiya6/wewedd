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
  bool isaccessLoading = false;
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

  Future<ResponseClass> accessWedding(
      String marriageId, String mobileno) async {
    String url = "${StringConstants.apiUrl}check_user_access_for_marriage";
    Map? data;
    //Response
    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: data);
    try {
      isaccessLoading = true;
      notifyListeners();
      Response response = await dio.post(url,
          data: {"mobile_number": mobileno, "marriage_id": marriageId});
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        //  responseClass.message = response.data["message"];
        responseClass.data = response.data["data"];

        isaccessLoading = false;

        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      log(e.toString());

      isaccessLoading = false;
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      notifyListeners();

      return responseClass;
    } on SocketException catch (e) {
      isaccessLoading = false;
      Fluttertoast.showToast(msg: "No internet");
      notifyListeners();
      if (kDebugMode) {
        log("access error->" + e.toString());
      }

      return responseClass;
    } catch (e) {
      isaccessLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("access error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass> addGuestSide(
      {required String marriage_id,
      required String guest_side,
      required String mobile_no}) async {
    String url = '${StringConstants.apiUrl}add_guest_side';

    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: {});
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {
          "marriage_id": marriage_id,
          "guest_side": guest_side,
          "mobile_number": mobile_no
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.data = response.data["data"];
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
        log("guest side request error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
