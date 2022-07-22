import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    if(apiResponse.error is! String && apiResponse.error.errors[0].message == 'Unauthenticated.') {
      Provider.of<SplashProvider>(context, listen: false).removeSharedData();
      Navigator.pushNamedAndRemoveUntil(context, Routes.getLoginRoute(), (route) => false);
    }else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      showCustomSnackBar(_errorMessage, context);
    }
  }
}