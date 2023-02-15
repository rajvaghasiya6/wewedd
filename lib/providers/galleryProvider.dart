import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/shared_preferences.dart';
import '../general/string_constants.dart';
import '../models/folder_model.dart';
import '../models/response_model.dart';
import 'user_provider.dart';

class GalleryProvider with ChangeNotifier {
  bool isLoaded = false;
  List galleryData = [];
  bool isUploading = false;
  List<FolderModel> folders = [];

  Future<ResponseClass<List>> getGalleryByEvent(
      {required String eventId, required int page}) async {
    String url = StringConstants.apiUrl + StringConstants.getAllGallery;

    //Response
    ResponseClass<List> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      Response response = await dio.get(url, queryParameters: {
        "marriage_id": sharedPrefs.marriageId,
        "event_id": eventId,
        "page": page,
        "limit": 15
      });
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        if (response.data["pagination"] != null) {
          Pagination pagination =
              Pagination.fromJson(response.data["pagination"]);
          responseClass.pagination = pagination;
        }
        List galleryList = response.data["data"];
        galleryData = galleryList;
        responseClass.data = galleryList;
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
        log("gallery error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<List>> getGalleryByFolder(
      {required String folderId, required int page}) async {
    String url = StringConstants.apiUrl + StringConstants.getAllGallery;

    //Response
    ResponseClass<List> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      Response response = await dio.get(url, queryParameters: {
        "marriage_id": sharedPrefs.marriageId,
        "folder_id": folderId,
        "page": page,
        "limit": 15
      });
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        if (response.data["pagination"] != null) {
          Pagination pagination =
              Pagination.fromJson(response.data["pagination"]);
          responseClass.pagination = pagination;
        }
        List galleryList = response.data["data"];
        galleryData = galleryList;
        responseClass.data = galleryList;
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
        log("gallery error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass> addFolder({
    required String marriage_id,
    required String folder_name,
  }) async {
    String url = '${StringConstants.apiUrl}create_new_folder';

    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: {});
    try {
      //  isLoading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: {
          "marriage_id": marriage_id,
          "folder_name": folder_name,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.data = response.data["data"];
        //  isLoading = false;
        notifyListeners();
      }

      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      //    isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      //  isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("guest side request error ->" + e.toString());
      }
      return responseClass;
    }
  }

  getFolder() async {
    String url = "${StringConstants.apiUrl}get_all_folders";

    try {
      Response response = await dio.post(url, data: {
        'marriage_id': sharedPrefs.marriageId,
      });
      if (response.statusCode == 200) {
        List folderList = response.data["data"];
        List<FolderModel> list =
            folderList.map((e) => FolderModel.fromJson(e)).toList();
        folders = list;
        isLoaded = true;
        notifyListeners();
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoaded = true;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
    } catch (e) {
      isLoaded = true;
      notifyListeners();
      if (kDebugMode) {
        log("folder error ->" + e.toString());
      }
    }
  }

  Future<ResponseClass> addGalleryPhoto({required FormData formData}) async {
    String url = StringConstants.apiUrl + StringConstants.addGallery;

    //Response
    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: {});
    try {
      isUploading = true;
      notifyListeners();
      Response response = await dio.post(
        url,
        data: formData,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = response.data["data"];
        isUploading = false;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isUploading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isUploading = false;
      notifyListeners();
      log("add gallery error ->" + e.toString());
      return responseClass;
    }
  }
}
