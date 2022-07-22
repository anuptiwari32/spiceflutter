import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({@required this.sharedPreferences, @required this.dioClient});

  Future<ApiResponse> getConfig() async {
    try {
      final response = await dioClient.get(AppConstants.CONFIG_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if(!sharedPreferences.containsKey(AppConstants.THEME)) {
      return sharedPreferences.setBool(AppConstants.THEME, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.COUNTRY_CODE)) {
      return sharedPreferences.setString(AppConstants.COUNTRY_CODE, AppConstants.languages[0].countryCode);
    }
    if(!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {
      return sharedPreferences.setString(AppConstants.LANGUAGE_CODE, AppConstants.languages[0].languageCode);
    }
    if(!sharedPreferences.containsKey(AppConstants.ON_BOARDING_SKIP)) {
      return sharedPreferences.setBool(AppConstants.ON_BOARDING_SKIP, true);
    }
    // if (!sharedPreferences.containsKey(AppConstants.LANG_SKIP)) {
    //   sharedPreferences.setBool(AppConstants.LANG_SKIP, true);
    // }
    if(!sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      return sharedPreferences.setStringList(AppConstants.CART_LIST, []);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }
  // void disableLang() {
  //   sharedPreferences.setBool(AppConstants.LANG_SKIP, false);
  // }

  // bool showLang() {
  //   return sharedPreferences.getBool(AppConstants.LANG_SKIP)?? true;
  // }
}