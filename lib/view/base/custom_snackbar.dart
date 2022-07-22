import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

void showCustomSnackBar(String message, BuildContext context, {bool isError = true, }) {
  final _width = MediaQuery.of(context).size.width;
  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(message),
      margin: ResponsiveHelper.isDesktop(context) ?  EdgeInsets.only(right: _width * 0.7, bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL, left: Dimensions.PADDING_SIZE_EXTRA_SMALL) : EdgeInsets.zero,
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? Colors.red : Colors.green)
  );
}