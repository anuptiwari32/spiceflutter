import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/cart_repo.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo cartRepo;
  CartProvider({@required this.cartRepo});

  List<CartModel> _cartList = [];
  double _amount = 0.0;
  bool _isCartUpdate = false;

  List<CartModel> get cartList => _cartList;
  double get amount => _amount;
  bool get isCartUpdate => _isCartUpdate;

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
    _cartList.forEach((cart) {
      _amount = _amount + (cart.discountedPrice * cart.quantity);
    });
  }

  void addToCart(CartModel cartModel, int index) {
    // if(index != null) {
    //   _amount = _amount - (_cartList[index].discountedPrice * _cartList[index].quantity);
    //   _cartList.replaceRange(index, index+1, [cartModel]);
    // }else {
    //   _cartList.add(cartModel);
    // }
    // _amount = _amount + (cartModel.discountedPrice * cartModel.quantity);
    // cartRepo.addToCartList(_cartList);
    if(index != null && index != -1) {
      _cartList.replaceRange(index, index+1, [cartModel]);
    }else {
      _cartList.add(cartModel);
    }
    cartRepo.addToCartList(_cartList);
    notifyListeners();
  }

  void setQuantity(
      {bool isIncrement,
      CartModel cart,
      int productIndex,
      bool fromProductView}) {
    int index = fromProductView ? productIndex :  _cartList.indexOf(cart);
    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity + 1;
      _amount = _amount + _cartList[index].discountedPrice;
    } else {
      _cartList[index].quantity = _cartList[index].quantity - 1;
      _amount = _amount - _cartList[index].discountedPrice;
    }
    cartRepo.addToCartList(_cartList);

    notifyListeners();
  }

  void removeFromCart(int index) {
    _amount = _amount - (_cartList[index].discountedPrice * _cartList[index].quantity);
    _cartList.removeAt(index);
    cartRepo.addToCartList(_cartList);
    notifyListeners();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index].addOnIds.removeAt(addOnIndex);
    cartRepo.addToCartList(_cartList);
    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo.addToCartList(_cartList);
    notifyListeners();
  }

  int isExistInCart(int productId, String variationType, bool isUpdate, int cartIndex,) {
    for(int index = 0; index<_cartList.length; index++) {
      if(_cartList[index].product.id == productId && (_cartList[index].variation.length > 0 ? _cartList[index].variation[0].type == variationType : true)) {
        if((isUpdate && index == cartIndex)) {
          return -1;
        }else {
          return index;
        }
      }
    }
    return -1;
  }
  int getCartProductIndex (CartModel cartModel) {
    for(int index = 0; index < _cartList.length; index ++) {
      if(_cartList[index].product.id == cartModel.product.id && (_cartList[index].variation.length > 0 ? _cartList[index].variation[0].type == cartModel.variation[0].type : true)) {
        return index;
      }
    }
    return null;
  }
  int getCartIndex (Product product) {
    for(int index = 0; index < _cartList.length; index ++) {
      if(_cartList[index].product.id == product.id ) {
        return index;
      }
    }
    return null;
  }
  setCartUpdate(bool isUpdate) {
    _isCartUpdate = isUpdate;
    if(_isCartUpdate) {
      notifyListeners();
    }

  }

}
