import 'dart:convert';

import 'package:dio/dio.dart';

class ApiUtils {
  ///dev urls
 /* static const String userAuthApiUrl = "http://192.168.31.43:6001/auth/";
  static const String apiUrl = "http://192.168.31.43:6001/api/";
  static const String webSocketUrl = "ws://192.168.31.43:6001/sd/";*/

  ///prod urls
  static const String userAuthApiUrl = "http://45.32.20.80:6001/auth/";
  static const String apiUrl = "http://45.32.20.80:6001/api/";
  static const String webSocketUrl = "ws://45.32.20.80:6001/sd/";

  static ApiUtilsModel getMessageAndMultiDataFromResponse(Response response) {
    final successMessage = response.data['message'];
    List<Map<String, dynamic>> formattedData = response.data['data'] != null ? response.data['data'].cast<Map<String, dynamic>>() : {};
    return ApiUtilsModel(
      message: successMessage,
      data: formattedData,
    );
  }

  static ApiUtilsModel getMessageAndSingleDataFromResponse(Response response) {
    final successMessage = response.data['message'];
    Map<String, dynamic> formattedData = response.data['data'] != null ? Map<String, dynamic>.from(response.data['data']) : {};
    return ApiUtilsModel(
      message: successMessage,
      data: [formattedData],
    );
  }

  static ApiUtilsModel getMessageTokensAndSingleDataFromResponse(Response response) {
    final successMessage = response.data['message'];
    final responseHeader = response.headers['authorization'];
    //final refreshToken = response.data['refreshToken'];
    Map<String, dynamic> formattedData = response.data['data'] != null ? Map<String, dynamic>.from(response.data['data']) : {};
    return ApiUtilsModel(
      message: successMessage,
      accessToken: responseHeader![0].split('Bearer ')[1],
      //refreshToken: refreshToken,
      data: [formattedData],
    );
  }

  static ApiUtilsModel getMultiDataFromStreamResponse(String streamResponse) {
    final parsed = json.decode(streamResponse);
    List<Map<String, dynamic>> formattedData = parsed != null ? parsed.cast<Map<String, dynamic>>() : {};
    return ApiUtilsModel(
      message: '',
      data: formattedData,
    );
  }

  static handleHttpException(Response response) {
    throw response.data['message'];
  }
}

class ApiUtilsModel {
  String message;
  List<Map<String, dynamic>> data;
  String? refreshToken;
  String? accessToken;

  ApiUtilsModel({required this.message, required this.data, this.accessToken, this.refreshToken});
}
