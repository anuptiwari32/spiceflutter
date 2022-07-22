import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';

String getTranslated(String key, BuildContext context) {
  return AppLocalization.of(context).translate(key);
}