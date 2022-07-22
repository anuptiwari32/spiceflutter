import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/set_menu_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';

class BuffetMenuProvider extends ChangeNotifier {
  final SetMenuRepo setMenuRepo;

  BuffetMenuProvider({@required this.setMenuRepo});

  List<Product> _setBuffetList;

  List<Product> get setBuffetList => _setBuffetList;

  Future<void> getSetMenuList(
      BuildContext context, bool reload, String languageCode) async {
    if (setBuffetList == null || reload) {
      ApiResponse apiResponse =
          await setMenuRepo.getSetMenuList(languageCode, "2");
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _setBuffetList = [];
        apiResponse.response.data.forEach(
            (setMenu) => _setBuffetList.add(Product.fromJson(setMenu)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }
}
