import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/string_constants.dart';
import '../models/response_model.dart';
import 'user_provider.dart';

class AddWeddingProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<ResponseClass> addNewWedding({required FormData formData}) async {
    String url = '${StringConstants.apiUrl}register_marriage_for_user';

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
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } on SocketException catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("add wedding error ->" + e.toString());
      }
      Fluttertoast.showToast(msg: "No internet");
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("add wedding error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
