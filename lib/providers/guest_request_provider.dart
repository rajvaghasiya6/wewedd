import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/string_constants.dart';
import '../models/guest_request.dart';
import '../models/response_model.dart';
import 'user_provider.dart';

class GuestRequestProvider extends ChangeNotifier {
  bool isLoading = false;
  List<GuestRequest> guestRequest = [];

  Future<ResponseClass<List<GuestRequest>>> guestRequestsApi(
      {required String marriage_id, required String guest_status}) async {
    String url = '${StringConstants.apiUrl}get_all_guest_details';

    ResponseClass<List<GuestRequest>> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: guestRequest);
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {"marriage_id": marriage_id, "guest_status": guest_status},
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];

        List requestList = response.data["data"];
        List<GuestRequest> list =
            requestList.map((e) => GuestRequest.fromJson(e)).toList();
        responseClass.data = list;
        guestRequest = list;
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
        log("guest request error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass> updateGuestStatus(
      {required String marriage_id,
      required String guest_status,
      required String guest_id}) async {
    String url = '${StringConstants.apiUrl}update_guest_status';

    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: {});
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {
          "marriage_id": marriage_id,
          "guest_status": guest_status,
          "guest_id": guest_id
        },
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];

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
        log("status change request error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass> approveAllGuest({
    required String marriage_id,
  }) async {
    String url = '${StringConstants.apiUrl}approve_all_guest';

    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: {});
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {
          "marriage_id": marriage_id,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseClass.success = response.data["is_success"];

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
        log("approve request error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass> rejectAllGuest({
    required String marriage_id,
  }) async {
    String url = '${StringConstants.apiUrl}reject_all_guest';

    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: {});
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {
          "marriage_id": marriage_id,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseClass.success = response.data["is_success"];

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
        log("approve request error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
