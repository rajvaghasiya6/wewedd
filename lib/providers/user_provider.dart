import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/shared_preferences.dart';
import '../general/string_constants.dart';
import '../models/hosted_marriages.dart';
import '../models/response_model.dart';
import '../models/user_model.dart';

BaseOptions options = BaseOptions(
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

class UserProvider extends ChangeNotifier {
  UserModel? user;
  bool ishostedLoading = false;
  bool isLoading = false;
  List<HostedMarriages> hostedMarriages = [];

  Future<ResponseClass> registerUser({required FormData formData}) async {
    String url = StringConstants.apiUrl + StringConstants.userRegistration;
    //body Data

    //Response
    ResponseClass responseClass = ResponseClass(
      success: false,
      message: "Something went wrong",
    );
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(validateStatus: (status) {
          return status == 409 || status == 201;
        }),
      );

      log(response.statusCode.toString());
      if (response.statusCode == 201) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = response.data["data"];
        isLoading = false;
        notifyListeners();
      }
      if (response.statusCode == 409) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = null;
        Fluttertoast.showToast(msg: responseClass.message);
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
        log("registerUser error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<String>> sendOTP(Map<String, dynamic> data) async {
    String url = StringConstants.apiUrl + StringConstants.sms;

    ResponseClass<String> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: "");
    try {
      Response response = await dio.post(url, data: data, options: Options(
        validateStatus: (status) {
          return status == 200 || status == 400;
        },
      ));
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = response.data["data"];

        notifyListeners();
      }
      if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: response.data["message"]);
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
        log("otp error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass> userLogin({required String mobileNo}) async {
    String loginUrl = StringConstants.apiUrl + StringConstants.userLogin;

    //body Data
    var data = {"mobile_number": mobileNo};

    //Response
    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: '');
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        loginUrl,
        data: data,
        options: Options(validateStatus: (status) {
          return status == 401 || status == 200;
        }),
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = response.data["data"];

        isLoading = false;
        notifyListeners();
      }
      if (response.statusCode == 401) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        Fluttertoast.showToast(msg: responseClass.message);
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
        log("login error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<List<HostedMarriages>>> userHostedMarriages(
      {required String mobileNo}) async {
    String url = StringConstants.apiUrl + StringConstants.userHostedMarriages;

    //body Data
    var data = {"mobile_number": mobileNo};

    //Response
    ResponseClass<List<HostedMarriages>> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: hostedMarriages);
    try {
      ishostedLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: data,
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];

        List weddingList = response.data["data"];
        List<HostedMarriages> list =
            weddingList.map((e) => HostedMarriages.fromJson(e)).toList();
        responseClass.data = list;
        hostedMarriages = list;
        ishostedLoading = false;
        notifyListeners();
      }

      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      ishostedLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      ishostedLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("userHostedMarriages error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<UserModel>> getUserData(
      {required String mobileNo}) async {
    String loginUrl = StringConstants.apiUrl + StringConstants.guestLogin;

    //body Data
    var data = {
      "marriage_id": sharedPrefs.marriageId,
      "guest_mobile_number": mobileNo
    };

    //Response
    ResponseClass<UserModel> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: user);
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.get(
        loginUrl,
        queryParameters: data,
        options: Options(validateStatus: (status) {
          return status == 401 || status == 200;
        }),
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = UserModel.fromJson(response.data["data"]);
        user = responseClass.data;
        if (responseClass.success &&
            responseClass.data?.guestStatus == "Approved") {
          // sharedPrefs.mobileNo = user!.guestMobileNumber;
          // sharedPrefs.guestId = user!.guestId;
          // sharedPrefs.guestProfileImage = user!.guestProfileImage;
          // sharedPrefs.guestIdProof = user!.guestIdProof;
          // sharedPrefs.guestName = user!.guestName;
        }
        isLoading = false;
        notifyListeners();
      }
      if (response.statusCode == 401) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        Fluttertoast.showToast(msg: responseClass.message);
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
        log("login error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<UserModel>> loginUser({required String mobileNo}) async {
    String loginUrl = StringConstants.apiUrl + StringConstants.guestLogin;

    //body Data
    var data = {
      "marriage_id": sharedPrefs.marriageId,
      "guest_mobile_number": mobileNo
    };

    //Response
    ResponseClass<UserModel> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.get(
        loginUrl,
        queryParameters: data,
        options: Options(validateStatus: (status) {
          return status == 401 || status == 200;
        }),
      );
      log("-> ${response.statusCode}");
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = UserModel.fromJson(response.data["data"]);
        isLoading = false;
        notifyListeners();
      }
      if (response.statusCode == 401) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        Fluttertoast.showToast(msg: responseClass.message);
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
        log("login error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<UserModel>> viewGuest({
    required String guestId,
  }) async {
    String url =
        StringConstants.apiUrl + StringConstants.viewGuestDetails + "/$guestId";

    //Response
    ResponseClass<UserModel> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: user);
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = UserModel.fromJson(response.data["data"]);
        user = responseClass.data;
        if (responseClass.success &&
            responseClass.data?.guestStatus == "Approved") {
          sharedPrefs.mobileNo = user!.guestMobileNumber;
          sharedPrefs.guestId = user!.guestId;
          // sharedPrefs.guestProfileImage = user!.guestProfileImage;
          // sharedPrefs.guestIdProof = user!.guestIdProof;
          // sharedPrefs.guestName = user!.guestName;
        }
        isLoading = false;
        notifyListeners();
      }
      if (response.statusCode == 401) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = response.data["data"];
        Fluttertoast.showToast(msg: responseClass.message);
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
        log("loin error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass> updateUser({required String name}) async {
    String url = StringConstants.apiUrl + StringConstants.updateNameForUser;

    //Response
    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: {});
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {
          "mobile_number": sharedPrefs.mobileNo,
          "name": name,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseClass.success = response.data["is_success"];

        isLoading = false;
        notifyListeners();
      }
      if (response.statusCode == 409) {
        responseClass.success = response.data["is_success"];

        Fluttertoast.showToast(msg: responseClass.message);
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
        log("update user error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass> updateFcmToken({required String token}) async {
    String url = StringConstants.apiUrl + StringConstants.updateGuestFcmToken;

    //Response
    ResponseClass responseClass =
        ResponseClass(success: false, message: "Something went wrong", data: 0);
    var data = {
      "marriage_id": sharedPrefs.marriageId,
      "guest_id": sharedPrefs.guestId,
      "fcm_token_guest": token
    };
    try {
      Response response = await dio.patch(url, data: data, options: Options(
        validateStatus: (status) {
          return status == 200;
        },
      ));
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = response.data["data"];
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
        log("fcm update error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
