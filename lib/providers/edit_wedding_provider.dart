import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/string_constants.dart';
import '../models/events_model.dart';
import '../models/response_model.dart';
import '../models/wedding_all_details.dart';
import 'user_provider.dart';

class EditWeddingProvider extends ChangeNotifier {
  bool isLoaded = false;
  bool isLoading = false;
  WeddingAllDetailModel? weddingAllDetailModel;
  List<EventModel>? events = [];

  Future<ResponseClass> updateWedding({required FormData formData}) async {
    String url = '${StringConstants.apiUrl}update_marriage_for_user';

    //Response
    ResponseClass responseClass = ResponseClass(
      success: false,
      message: "Something went wrong",
    );
    try {
      isLoading = true;
      notifyListeners();
      Response response =
          await dio.post(url, data: formData, options: Options());
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = response.data["data"];
        print("done");
        isLoading = false;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      log(e.toString());
      isLoading = false;
      notifyListeners();
      print('error $e');
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } on SocketException catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("update wedding error ->" + e.toString());
      }
      Fluttertoast.showToast(msg: "No internet");
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("update wedding error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<WeddingAllDetailModel>> getWeddingData(
      String marriageId) async {
    String url = StringConstants.apiUrl +
        StringConstants.getMarriagesInformation +
        "/$marriageId";

    //Response
    ResponseClass<WeddingAllDetailModel> responseClass = ResponseClass(
        success: false,
        message: "Something went wrong",
        data: weddingAllDetailModel);
    try {
      Response response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data =
            WeddingAllDetailModel.fromJson(response.data["data"]);
        weddingAllDetailModel = responseClass.data;

        isLoaded = true;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      log(e.toString());
      isLoaded = true;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } on SocketException catch (e) {
      isLoaded = true;
      notifyListeners();
      if (kDebugMode) {
        log("wedding fetch error ->" + e.toString());
      }
      Fluttertoast.showToast(msg: "No internet");
      return responseClass;
    } catch (e) {
      isLoaded = true;
      notifyListeners();
      if (kDebugMode) {
        log("wedding fetch error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<List<EventModel>>> getEvents(String marraigeId) async {
    String url = StringConstants.apiUrl +
        StringConstants.getAllEventForGuest +
        "/$marraigeId";
    ResponseClass<List<EventModel>> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: events);
    try {
      Response response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data['is_success'];
        List eventList = response.data["data"];
        List<EventModel> list =
            eventList.map((e) => EventModel.fromJson(e)).toList();
        responseClass.data = list;
        events = list;
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
        log("event error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
