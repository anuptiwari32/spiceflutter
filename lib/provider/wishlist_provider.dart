import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/wishlist_model.dart';
import 'package:flutter_restaurant/data/repository/product_repo.dart';
import 'package:flutter_restaurant/data/repository/wishlist_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';

class WishListProvider extends ChangeNotifier {
  final WishListRepo wishListRepo;
  final ProductRepo productRepo;
  WishListProvider({@required this.wishListRepo, @required this.productRepo});

  List<Product> _wishList;
  List<int> _wishIdList = [];

  List<Product> get wishList => _wishList;
  List<int> get wishIdList => _wishIdList;

  void addToWishList(Product product, Function feedbackMessage) async {
    ApiResponse apiResponse = await wishListRepo.addWishList(product.id);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      Map map = apiResponse.response.data;
      String message = map['message'];
      feedbackMessage(message);
      _wishList.add(product);
      _wishIdList.add(product.id);
    } else {
      feedbackMessage('${apiResponse.error.toString()}');
      print('${apiResponse.error.toString()}');
    }
    notifyListeners();
  }

  void removeFromWishList(Product product, Function feedbackMessage) async {
    ApiResponse apiResponse = await wishListRepo.removeWishList(product.id);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      Map map = apiResponse.response.data;
      String message = map['message'];
      feedbackMessage(message);
      int _idIndex = _wishIdList.indexOf(product.id);
      _wishIdList.removeAt(_idIndex);
      _wishList.removeAt(_idIndex);
    } else {
      print('${apiResponse.error.toString()}');
      feedbackMessage('${apiResponse.error.toString()}');
    }
    notifyListeners();
  }

  Future<void> initWishList(BuildContext context, String languageCode) async {
    _wishList = [];
    _wishIdList = [];
    ApiResponse apiResponse = await wishListRepo.getWishList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      notifyListeners();
      apiResponse.response.data.forEach((wishList) async {
        ApiResponse productResponse = await productRepo.searchProduct(WishListModel.fromJson(wishList).productId.toString(), languageCode);
        if (productResponse.response != null && productResponse.response.statusCode == 200) {
          Product _product = Product.fromJson(productResponse.response.data);
          _wishList.add(_product);
          _wishIdList.add(_product.id);
          notifyListeners();
        } else {
          ApiChecker.checkApi(context, apiResponse);
        }
      });
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }
}
