import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_management/data/api/api_checker.dart';
import 'package:school_management/utils/app_constants.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;

  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    _mainHeaders = {
      'Authorization': '$token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Authorization': '$token',
    };

    sharedPreferences.setString(AppConstants.TOKEN, token);

    if (kDebugMode) {
      print('update header called for $token');
    }
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try {
      Response response = await get(uri, headers: headers ?? _mainHeaders);
      if (kDebugMode) {
        print('getting $appBaseUrl $uri  $_mainHeaders');
        print("response body ${response.body}");
      }
      return response;
    } catch (e) {
      return Response(
        statusCode: 1,
        statusText: e.toString(),
      );
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      if (kDebugMode) {
        print('posting $appBaseUrl $uri $body $_mainHeaders');
        print("response body ${response.body}");
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('from api post client');
        print(e.toString());
      }
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> putData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {

      Response response = await put(uri, body, headers: headers ?? _mainHeaders);
      if (kDebugMode) {
        print("putting ${response.body}");
      }
      ApiChecker.checkApi(response);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('from api put client');
        print(e.toString());
      }
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

}