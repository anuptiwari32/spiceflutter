import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartBottomSheetWeb extends StatelessWidget {
  final Product product;
  final bool fromSetMenu;
  final Function callback;
  final CartModel cart;
  final int cartIndex;
  final bool fromCart;
  final bool isCart;

  CartBottomSheetWeb({
    @required this.product,
    this.fromSetMenu = false,
    this.callback,
    this.cart,
    this.cartIndex,
    this.fromCart = false,
    this.isCart = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isExistInCart = false;
    // bool fromCar = cart != null;
    Provider.of<ProductProvider>(context, listen: false).initData(product, cart, context);
    Variation _variation = Variation();

    return Stack(
      children: [
        Consumer<CartProvider>(
            builder: (context, _cartProvider, child) {
            return Container(
              width: 550,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              decoration: BoxDecoration(
                borderRadius: ResponsiveHelper.isMobile(context)
                    ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                    : BorderRadius.all(Radius.circular(20)),
              ),
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  double _startingPrice;
                  double _endingPrice;
                  if (product.choiceOptions.length != 0) {
                    List<double> _priceList = [];
                    product.variations.forEach((variation) => _priceList.add(variation.price));
                    _priceList.sort((a, b) => a.compareTo(b));
                    _startingPrice = _priceList[0];
                    if (_priceList[0] < _priceList[_priceList.length - 1]) {
                      _endingPrice = _priceList[_priceList.length - 1];
                    }
                  } else {
                    _startingPrice = product.price;
                  }

                  List<String> _variationList = [];
                  for (int index = 0; index < product.choiceOptions.length; index++) {
                    _variationList.add(product.choiceOptions[index].options[productProvider.variationIndex[index]].replaceAll(' ', ''));
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

                  double price = product.price;
                  for (Variation variation in product.variations) {
                    if (variation.type == variationType) {
                      price = variation.price;
                      _variation = variation;
                      break;
                    }
                  }
                  double priceWithDiscount = PriceConverter.convertWithDiscount(context, price, product.discount, product.discountType);
                  double priceDiscount = PriceConverter.convertDiscount(context, price, product.discount, product.discountType);

                  double addonsCost = 0;
                  List<AddOn> _addOnIdList = [];
                  for (int index = 0; index < product.addOns.length; index++) {
                    if (productProvider.addOnActiveList[index]) {
                      addonsCost = addonsCost + (product.addOns[index].price * productProvider.addOnQtyList[index]);
                      _addOnIdList.add(AddOn(id: product.addOns[index].id, quantity: productProvider.addOnQtyList[index]));
                    }
                  }

                  DateTime _currentTime = Provider.of<SplashProvider>(context, listen: false).currentTime;
                  DateTime _start = DateFormat('hh:mm:ss').parse(product.availableTimeStarts);
                  DateTime _end = DateFormat('hh:mm:ss').parse(product.availableTimeEnds);
                  DateTime _startTime =
                  DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _start.hour, _start.minute, _start.second);
                  DateTime _endTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _end.hour, _end.minute, _end.second);
                  if (_endTime.isBefore(_startTime)) {
                    _endTime = _endTime.add(Duration(days: 1));
                  }
                  bool _isAvailable = _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);

                  CartModel _cartModel = CartModel(
                    price,
                    priceWithDiscount,
                    [_variation],
                    (price - PriceConverter.convertWithDiscount(context, price, product.discount, product.discountType)),
                    productProvider.quantity,
                    price - PriceConverter.convertWithDiscount(context, price, product.tax, product.taxType),
                    _addOnIdList,
                    product,
                  );
                  isExistInCart = _cartProvider.isExistInCart(product.id, variationType ,fromCart, cartIndex) == -1 ? false : true;
                  double priceWithQuantity = priceWithDiscount *  productProvider.quantity;
                  double priceWithAddons = priceWithQuantity + addonsCost;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        //Product
                        Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder_rectangle,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}',
                              width: ResponsiveHelper.isMobile(context)
                                  ? 100
                                  : ResponsiveHelper.isTab(context)
                                  ? 140
                                  : ResponsiveHelper.isDesktop(context)
                                  ? 140
                                  : null,
                              height: ResponsiveHelper.isMobile(context)
                                  ? 100
                                  : ResponsiveHelper.isTab(context)
                                  ? 140
                                  : ResponsiveHelper.isDesktop(context)
                                  ? 140
                                  : null,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (c, o, s) => Image.asset(
                                Images.placeholder_rectangle,
                                width: ResponsiveHelper.isMobile(context)
                                    ? 100
                                    : ResponsiveHelper.isTab(context)
                                    ? 140
                                    : ResponsiveHelper.isDesktop(context)
                                    ? 140
                                    : null,
                                height: ResponsiveHelper.isMobile(context)
                                    ? 100
                                    : ResponsiveHelper.isTab(context)
                                    ? 140
                                    : ResponsiveHelper.isDesktop(context)
                                    ? 140
                                    : null,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                    ),
                                  ),
                                  Consumer<WishListProvider>(builder: (context, wishList, child) {
                                    return InkWell(
                                      onTap: () {
                                        wishList.wishIdList.contains(product.id)
                                            ? wishList.removeFromWishList(product, (message) {})
                                            : wishList.addToWishList(product, (message) {});
                                      },
                                      child: Icon(
                                        wishList.wishIdList.contains(product.id) ? Icons.favorite : Icons.favorite_border,
                                        color: wishList.wishIdList.contains(product.id)
                                            ? Theme.of(context).primaryColor
                                            : ColorResources.COLOR_GREY,
                                      ),
                                    );
                                  })
                                ],
                              ),
                              SizedBox(height: 10),
                              RatingBar(rating: product.rating.length > 0 ? double.parse(product.rating[0].average) : 0.0, size: 15),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType)}'
                                        '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount, discountType: product.discountType)}' : ''}',
                                    style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
                                  ),

                                ],
                              ),
                              SizedBox(height: 5),
                              priceDiscount > 0
                                  ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(
                                  '${PriceConverter.convertPrice(context, _startingPrice)}'
                                      '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                  style: rubikMedium.copyWith(color: ColorResources.COLOR_GREY, decoration: TextDecoration.lineThrough),
                                ),
                              ])
                                  : SizedBox(),
                              // Quantity
                              Row(children: [
                                Text(getTranslated('quantity', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Expanded(child: SizedBox()),
                                _quantityButton(context, isExistInCart, _cartProvider, _cartModel, productProvider),
                              ]),
                            ]),
                          ),
                        ]),
                        
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                       
                       ResponsiveHelper.isDesktop(context) ?
                       Builder(
                         builder: (context) {
                           print('=============des===============>${product.description}');
                           return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                             Text(getTranslated('description', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                             SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                             Text(product.description ?? '', style: rubikRegular),

                             SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                           ]);
                         }
                       ) : SizedBox(),

                        // Variation
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: product.choiceOptions.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(product.choiceOptions[index].title, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: (1 / 0.25),
                                ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: product.choiceOptions[index].options.length,
                                itemBuilder: (context, i) {
                                  return InkWell(
                                    onTap: () {
                                      productProvider.setCartVariationIndex(index, i, product, variationType, context, );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      decoration: BoxDecoration(
                                        color: productProvider.variationIndex[index] != i
                                            ? ColorResources.BACKGROUND_COLOR
                                            : Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        product.choiceOptions[index].options[i].trim(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: rubikRegular.copyWith(
                                          color: productProvider.variationIndex[index] != i
                                              ? ColorResources.COLOR_BLACK
                                              : ColorResources.COLOR_WHITE,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: index != product.choiceOptions.length - 1 ? Dimensions.PADDING_SIZE_LARGE : 0),
                            ]);
                          },
                        ),
                        product.choiceOptions.length > 0 ? SizedBox(height: Dimensions.PADDING_SIZE_LARGE) : SizedBox(),



                        // Addons
                        product.addOns.length > 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(getTranslated('addons', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 10,
                              childAspectRatio: (1 / 1.1),
                            ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: product.addOns.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (!productProvider.addOnActiveList[index]) {
                                    productProvider.addAddOn(true, index);
                                  } else if (productProvider.addOnQtyList[index] == 1) {
                                    productProvider.addAddOn(false, index);
                                  }
                                },

                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(bottom: productProvider.addOnActiveList[index] ? 2 : 20),
                                  decoration: BoxDecoration(
                                    color: productProvider.addOnActiveList[index]
                                        ? Theme.of(context).primaryColor
                                        : ColorResources.BACKGROUND_COLOR,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: productProvider.addOnActiveList[index]
                                    ? [BoxShadow(
                                      color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                                      blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                                      spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                                    )]
                                        : null,
                                  ),
                                  child: Column(children: [
                                    Expanded(
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Text(product.addOns[index].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: rubikMedium.copyWith(
                                                color: productProvider.addOnActiveList[index]
                                                    ? ColorResources.COLOR_WHITE
                                                    : ColorResources.COLOR_BLACK,
                                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                              )),
                                          SizedBox(height: 5),
                                          Text(
                                            PriceConverter.convertPrice(context, product.addOns[index].price),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: rubikRegular.copyWith(
                                                color: productProvider.addOnActiveList[index]
                                                    ? ColorResources.COLOR_WHITE
                                                    : ColorResources.COLOR_BLACK,
                                                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                                          ),
                                        ])),
                                    productProvider.addOnActiveList[index] ? Container(
                                      height: 25,
                                      decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).cardColor),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                             if (productProvider.addOnQtyList[index] > 1) {
                                                productProvider.setAddOnQuantity(false, index);
                                              } else {
                                                productProvider.addAddOn(false, index);
                                              }
                                            },
                                            child: Center(child: Icon(Icons.remove, size: 15)),
                                          ),
                                        ),
                                        Text(productProvider.addOnQtyList[index].toString(),
                                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => productProvider.setAddOnQuantity(true, index),
                                            child: Center(child: Icon(Icons.add, size: 15)),
                                          ),
                                        ),
                                      ]),
                                    )
                                        : SizedBox(),
                                  ]),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        ])
                            : SizedBox(),

                        Row(children: [
                          Text('${getTranslated('total_amount', context)}:', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Text(PriceConverter.convertPrice(context, priceWithAddons),
                              style: rubikBold.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                              )),
                        ]),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        //Add to cart Button
                        ResponsiveHelper.isDesktop(context) ? SizedBox(
                          width: size.width / 2.0,
                          child: _cartButton(_isAvailable, context, isExistInCart, _cartModel),
                        ) : _cartButton(_isAvailable, context, isExistInCart, _cartModel),
                      ]),
                    ),
                  );
                },
              ),
            );
          }
        ),
        ResponsiveHelper.isMobile(context) ? SizedBox() : Positioned(
          right: 10,
          top: 5,
          child: InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.close)),
        ),
      ],
    );
  }



  Column _productDiscription(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(getTranslated('description', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      Text(product.description ?? '', style: rubikRegular),
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
    ]);
  }

  Container _quantityButton(BuildContext context, bool isExistInCart, CartProvider _cartProvider, CartModel _cartModel, ProductProvider productProvider) {
    return Container(
      decoration: BoxDecoration(color: ColorResources.getBackgroundColor(context), borderRadius: BorderRadius.circular(5)),
      child: Row(children: [
        InkWell(
          onTap: () => productProvider.quantity > 1 ?  productProvider.setQuantity(false) : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(Icons.remove, size: 20),
          ),
        ),
        Text(productProvider.quantity.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),

        InkWell(
          onTap: () => productProvider.setQuantity(true),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(Icons.add, size: 20),
          ),
        ),
      ]),
    );
  }

  Column _cartButton(bool _isAvailable, BuildContext context, bool isExistInCart, CartModel _cartModel) {
    return Column(children: [
      _isAvailable ? SizedBox() :
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        child: Column(children: [
          Text(getTranslated('not_available_now', context),
              style: rubikMedium.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.FONT_SIZE_LARGE,
              )),
          Text(
            '${getTranslated('available_will_be', context)} ${DateConverter.convertTimeToTime(product.availableTimeStarts, context)} '
                '- ${DateConverter.convertTimeToTime(product.availableTimeEnds, context)}',
            style: rubikRegular,
          ),
        ]),
      ),

      CustomButton(
          btnTxt: getTranslated(
            isCart
                ? 'update_in_cart'
                : isExistInCart
                ? 'update_in_cart'
                : 'add_to_cart', context,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            Navigator.pop(context);
            if(isExistInCart) {
              Provider.of<CartProvider>(context, listen: false).removeFromCart(
                cartIndex ?? Provider.of<CartProvider>(context, listen: false).getCartProductIndex(_cartModel),
              );
            }
            Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel, cartIndex ?? Provider.of<CartProvider>(context, listen: false).getCartProductIndex(_cartModel));
          }
      ),
    ]);
  }
}
