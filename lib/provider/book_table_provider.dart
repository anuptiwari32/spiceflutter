import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/error_response.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/delivery_man_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/timeslote_model.dart';
import 'package:flutter_restaurant/data/repository/book_table_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/provider/buffet_menu_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookTableProvider extends ChangeNotifier {
  final BookTableRepo tableRepo;
  final SharedPreferences sharedPreferences;
  BookTableProvider(
      {@required this.sharedPreferences, @required this.tableRepo});

  List<OrderModel> _runningOrderList;
  List<OrderModel> _historyOrderList;
  List<OrderDetailsModel> _orderDetails;
  int _paymentMethodIndex = 0;
  OrderModel _trackModel;
  ResponseModel _responseModel;
  int _addressIndex = -1;
  bool _isLoading = false;
  bool _showCancelled = false;
  DeliveryManModel _deliveryManModel;
  String _orderType = 'buffet';
  int _branchIndex = 0;
  List<String> _slots;

  int _selectDateSlot = 0;
  int _selectTimeSlot = 0;
  double _distance = -1;
  bool _isAvailable = true;

  List<OrderModel> get runningOrderList => _runningOrderList;
  List<OrderModel> get historyOrderList => _historyOrderList;
  List<OrderDetailsModel> get orderDetails => _orderDetails;
  int get paymentMethodIndex => _paymentMethodIndex;
  OrderModel get trackModel => _trackModel;
  ResponseModel get responseModel => _responseModel;
  int get addressIndex => _addressIndex;
  bool get isLoading => _isLoading;
  bool get isAvailable => _isAvailable;

  bool get showCancelled => _showCancelled;
  DeliveryManModel get deliveryManModel => _deliveryManModel;
  String get orderType => _orderType;
  int get branchIndex => _branchIndex;
  List<String> get slots => _slots;
  int get selectDateSlot => _selectDateSlot;
  int get selectTimeSlot => _selectTimeSlot;
  double get distance => _distance;

  Future<List<String>> getSlots(String branchId, String date, String session,
      BuildContext context) async {
    ApiResponse apiResponse =
        await tableRepo.checkSlots(branchId, date, session);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _slots = List<String>.from(apiResponse.response.data);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _slots;
  }

  Future<void> checkAvailability(String branchId, String date, String session,
      BuildContext context) async {
    _isLoading = true;
    ApiResponse apiResponse =
        await tableRepo.checkAvailability(branchId, date, session);
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _isAvailable = apiResponse.response.data;
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }

  void addTableBookData(Map<String, dynamic> tableData) {
    sharedPreferences.setString(
        AppConstants.BOOK_TABLE_DATA, jsonEncode(tableData));
  }

  Map<String, dynamic> getTableBookData() {
    String _tableDataString =
        sharedPreferences.getString(AppConstants.BOOK_TABLE_DATA);
    if (_tableDataString != null && _tableDataString.isNotEmpty)
      return Map<String, dynamic>.from(jsonDecode(_tableDataString));
    return new Map<String, dynamic>();
  }

  void clearTableBookData() {
    sharedPreferences.remove(AppConstants.BOOK_TABLE_DATA);
  }

  Future<void> addItemsToCart(BuildContext context) async {
    //final _cartProvider = ;
    Provider.of<BuffetMenuProvider>(context, listen: false)
        .setBuffetList
        .forEach((element) {
      double priceWithDiscount = PriceConverter.convertWithDiscount(
          context, element.price, element.discount, element.discountType);
      // double priceDiscount = PriceConverter.convertDiscount(
      //     context, element.price, element.discount, element.discountType);

      // DateTime _currentTime =
      //     Provider.of<SplashProvider>(context, listen: false)
      //         .currentTime;
      // DateTime _start =
      //     DateFormat('hh:mm:ss').parse(element.availableTimeStarts);
      // DateTime _end =
      //     DateFormat('hh:mm:ss').parse(element.availableTimeEnds);
      // DateTime _startTime = DateTime(
      //     _currentTime.year,
      //     _currentTime.month,
      //     _currentTime.day,
      //     _start.hour,
      //     _start.minute,
      //     _start.second);
      // DateTime _endTime = DateTime(
      //     _currentTime.year,
      //     _currentTime.month,
      //     _currentTime.day,
      //     _end.hour,
      //     _end.minute,
      //     _end.second);
      // if (_endTime.isBefore(_startTime)) {
      //   _endTime = _endTime.add(Duration(days: 1));
      // }
      // bool _isAvailable = _currentTime.isAfter(_startTime) &&
      //     _currentTime.isBefore(_endTime);

      CartModel _cartModel = CartModel(
        element.price,
        priceWithDiscount,
        [],
        (element.price -
            PriceConverter.convertWithDiscount(context, element.price,
                element.discount, element.discountType)),
        1,
        element.price -
            PriceConverter.convertWithDiscount(
                context, element.price, element.tax, element.taxType),
        [],
        element,
      );

      Provider.of<CartProvider>(context, listen: false).addToCart(
          _cartModel,
          Provider.of<CartProvider>(context, listen: false)
              .getCartProductIndex(_cartModel));
    });
  }

  Future<void> placeOrder(
      PlaceOrderBody placeOrderBody, Function callback) async {
    _isLoading = true;
    notifyListeners();
    print('order body : ${placeOrderBody.toJson()}');
    ApiResponse apiResponse = await tableRepo.placeOrder(placeOrderBody);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      String message = apiResponse.response.data['message'];
      String orderID = apiResponse.response.data['order_id'].toString();
      callback(true, message, orderID, placeOrderBody.deliveryAddressId);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage, '-1', -1);
    }
    notifyListeners();
  }

  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    notifyListeners();
  }

  void clearPrevData() {
    _addressIndex = -1;
    _branchIndex = 0;
    _paymentMethodIndex = 0;
    _distance = -1;
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if (notify) {
      notifyListeners();
    }
  }

  void setBranchIndex(int index) {
    _branchIndex = index;
    _addressIndex = -1;
    _distance = -1;
    notifyListeners();
  }
}
