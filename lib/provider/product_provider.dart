
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/repository/product_repo.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

import 'localization_provider.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;

  ProductProvider({@required this.productRepo});

  // Latest products
  List<Product> _popularProductList;
  List<Product> _latestProductList;
  bool _isLoading = false;
  int _popularPageSize;
  int _latestPageSize;
  List<String> _offsetList = [];
  List<int> _variationIndex = [0];
  int _quantity = 1;
  List<bool> _addOnActiveList = [];
  List<int> _addOnQtyList = [];
  bool _seeMoreButtonVisible= true;
  int latestOffset = 1;
  int popularOffset = 1;
  int _cartIndex = -1;

  List<Product> get popularProductList => _popularProductList;
  List<Product> get latestProductList => _latestProductList;
  bool get isLoading => _isLoading;
  int get popularPageSize => _popularPageSize;
  int get latestPageSize => _latestPageSize;
  List<int> get variationIndex => _variationIndex;
  int get quantity => _quantity;
  List<bool> get addOnActiveList => _addOnActiveList;
  List<int> get addOnQtyList => _addOnQtyList;
  bool get seeMoreButtonVisible => _seeMoreButtonVisible;
  int get cartIndex => _cartIndex;


  Future<void> getLatestProductList(BuildContext context , bool reload, String _offset, String languageCode) async {
    if(reload || _offset == '1') {
      latestOffset = 1 ;
      _offsetList = [];
    }
    if (!_offsetList.contains(_offset)) {
      _offsetList = [];
      _offsetList.add(_offset);
      ApiResponse apiResponse = await productRepo.getLatestProductList(_offset, languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        print('${apiResponse.response.data}');
        if (reload || _offset == '1') {
          _latestProductList = [];
        }
        _latestProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _latestPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString(), context);
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> getPopularProductList(BuildContext context , bool reload, String _offset, String languageCode) async {
    bool _apiSuccess = false;
    if(reload || _offset == '1') {
      popularOffset = 1 ;
      _offsetList = [];
    }
    if (!_offsetList.contains(_offset)) {
      _offsetList = [];
      _offsetList.add(_offset);
      ApiResponse apiResponse = await productRepo.getPopularProductList(_offset, languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _apiSuccess = true;
        if (reload || _offset == '1') {
          _popularProductList = [];
        }
        _popularProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _popularPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString(), context);
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
    return _apiSuccess;
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void initData(Product product, CartModel cart, BuildContext context) {
    _variationIndex = [];
    _addOnQtyList = [];
    _addOnActiveList = [];
    if(cart != null) {
      _quantity = cart.quantity;
      List<String> _variationTypes = [];
      if(cart.variation.length != null && cart.variation.length > 0 && cart.variation[0].type != null) {
        _variationTypes.addAll(cart.variation[0].type.split('-'));
      }
      int _varIndex = 0;
      product.choiceOptions.forEach((choiceOption) {
        for(int index=0; index<choiceOption.options.length; index++) {
          if(choiceOption.options[index].trim().replaceAll(' ', '') == _variationTypes[_varIndex].trim()) {
            _variationIndex.add(index);
            break;
          }
        }
        _varIndex++;
      });
      List<int> _addOnIdList = [];
      cart.addOnIds.forEach((addOnId) => _addOnIdList.add(addOnId.id));
      product.addOns.forEach((addOn) {
        if(_addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(cart.addOnIds[_addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    }else {
      _quantity = 1;
      product.choiceOptions.forEach((element) => _variationIndex.add(0));
      product.addOns.forEach((addOn) {
        _addOnActiveList.add(false);
        _addOnQtyList.add(1);
      });
      setExistInCart(product, context, notify: false);
    }
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList[index] = _addOnQtyList[index] + 1;
    } else {
      _addOnQtyList[index] = _addOnQtyList[index] - 1;
    }
    notifyListeners();
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity + 1;
    } else {
      _quantity = _quantity - 1;
    }
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i, Product product, String variationType, BuildContext context) {
    _variationIndex[index] = i;
    _quantity = 1;
    setExistInCart(product, context);
    notifyListeners();
  }

  int setExistInCart(Product product, BuildContext context,{bool notify = true}) {
    List<String> _variationList = [];
    for (int index = 0; index < product.choiceOptions.length; index++) {
      _variationList.add(product.choiceOptions[index].options[_variationIndex[index]].replaceAll(' ', ''));
    }
    String variationType = '';
    bool isFirst = true;
    _variationList.forEach((variation) {
      if (isFirst) {
        variationType = '$variationType$variation';
        isFirst = false;
      } else {
        variationType = '$variationType-$variation';
      }
    });
    final _cartProvider =  Provider.of<CartProvider>(context, listen: false);
    _cartIndex = _cartProvider.isExistInCart(product.id, variationType, false, null);
    if(_cartIndex != -1) {
      _quantity = _cartProvider.cartList[_cartIndex].quantity;
      _addOnActiveList = [];
      _addOnQtyList = [];
      List<int> _addOnIdList = [];
      _cartProvider.cartList[_cartIndex].addOnIds.forEach((addOnId) => _addOnIdList.add(addOnId.id));
      product.addOns.forEach((addOn) {
        if(_addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(_cartProvider.cartList[_cartIndex].addOnIds[_addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    }
    return _cartIndex;
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    notifyListeners();
  }

  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  int _deliveryManRating = 0;

  List<int> get ratingList => _ratingList;
  List<String> get reviewList => _reviewList;
  List<bool> get loadingList => _loadingList;
  List<bool> get submitList => _submitList;
  int get deliveryManRating => _deliveryManRating;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    orderDetailsList.forEach((orderDetails) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    });
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    notifyListeners();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    notifyListeners();
  }

  Future<ResponseModel> submitReview(int index, ReviewBody reviewBody) async {
    _loadingList[index] = true;
    notifyListeners();

    ApiResponse response = await productRepo.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String errorMessage;
      if(response.error is String) {
        errorMessage = response.error.toString();
      }else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _loadingList[index] = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(ReviewBody reviewBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await productRepo.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response.statusCode == 200) {
      _deliveryManRating = 0;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String errorMessage;
      if(response.error is String) {
        errorMessage = response.error.toString();
      }else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  void moreProduct(BuildContext context) {
    int pageSize;
    pageSize =(latestPageSize / 10).ceil();

    if (latestOffset < pageSize) {
      latestOffset++;
      showBottomLoader();
      getLatestProductList(
        context, false, latestOffset.toString(),
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );
    }
  }


  void seeMoreReturn(){
    latestOffset = 1;
    _seeMoreButtonVisible = true;
  }

}
