import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookTableRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  BookTableRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> checkSlots(
      String branchId, String date, String session) async {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['branch_id'] = branchId;
    data['date'] = date;
    data['session'] = session;
    try {
      final response =
          await dioClient.post(AppConstants.CHECK_SLOTS_URI, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> checkAvailability(
      String branchId, String date, String session) async {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['branch_id'] = branchId;
    data['date'] = date;
    data['session'] = session;
    try {
      final response =
          await dioClient.post(AppConstants.BOOK_SLOTS_URI, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> placeOrder(PlaceOrderBody orderBody) async {
    try {
      final response = await dioClient.post(AppConstants.BOOK_TABLE_URI,
          data: orderBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
