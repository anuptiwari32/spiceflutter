import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/book_table_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/buffet_menu_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';

import 'package:provider/provider.dart';

class CartBookTable extends StatefulWidget {
  @override
  State<CartBookTable> createState() => _CartBookTableState();
}

class _CartBookTableState extends State<CartBookTable> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  List<Branches> _branches = [];
  bool _isLoggedIn;
  List<CartModel> _cartList;
  @override
  void initState() {
    super.initState();
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<OrderProvider>(context, listen: false)
          .initializeTimeSlot(context)
          .then((value) {
        Provider.of<OrderProvider>(context, listen: false).sortTime();
      });
      _branches = Provider.of<SplashProvider>(context, listen: false)
          .configModel
          .branches;
      if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel ==
          null) {
        Provider.of<ProfileProvider>(context, listen: false)
            .getUserInfo(context);
      }
      // Provider.of<BookTableProvider>(context, listen: false)
      //     .addItemsToCart(context)
      //     .then((value) {
      //   _cartList = [];
      //   _cartList
      //       .addAll(Provider.of<CartProvider>(context, listen: false).cartList);
      // });
    }

    Provider.of<BuffetMenuProvider>(context, listen: false)
        .getBuffetMenuList(context, true, 'en')
        .then((value) {
      Provider.of<BookTableProvider>(context, listen: false)
          .addItemsToCart(context);
      _cartList = [];
      _cartList
          .addAll(Provider.of<CartProvider>(context, listen: false).cartList);
    });

    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false).setOrderType(
      'buffet',
      notify: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
        GlobalKey<ScaffoldMessengerState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : CustomAppBar(
              context: context,
              title: getTranslated('my_cart', context),
              isBackButtonExist: !ResponsiveHelper.isMobile(context)),
      body: Consumer<OrderProvider>(builder: (context, order, child) {
        return Consumer<CartProvider>(
          builder: (context, cart, child) {
            double deliveryCharge = 0;
            List<List<AddOns>> _addOnsList = [];
            List<bool> _availableList = [];
            double _itemPrice = 0;
            double _discount = 0;
            double _tax = 0;
            double _addOns = 0;
            cart.cartList.forEach((cartModel) {
              //add on list is not needed here
              List<AddOns> _addOnList = [];
              cartModel.addOnIds.forEach((addOnId) {
                for (AddOns addOns in cartModel.product.addOns) {
                  if (addOns.id == addOnId.id) {
                    _addOnList.add(addOns);
                    break;
                  }
                }
              });
              _addOnsList.add(_addOnList);

              _availableList
                  .add(true); //keep it true for all the buffet products

              for (int index = 0; index < _addOnList.length; index++) {
                _addOns = _addOns +
                    (_addOnList[index].price *
                        cartModel.addOnIds[index].quantity);
              }
              _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
              _discount =
                  _discount + (cartModel.discountAmount * cartModel.quantity);
              _tax = _tax + (cartModel.taxAmount * cartModel.quantity);
            });
            double _subTotal = _itemPrice + _tax + _addOns;
            double _total = _subTotal -
                _discount -
                Provider.of<CouponProvider>(context).discount +
                deliveryCharge;

            double _orderAmount = _itemPrice + _addOns;

            return cart.cartList.length > 0
                ? Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minHeight:
                                              !ResponsiveHelper.isDesktop(
                                                          context) &&
                                                      _height < 600
                                                  ? _height
                                                  : _height - 400),
                                      child: SizedBox(
                                        width: 1170,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (ResponsiveHelper.isDesktop(
                                                context))
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .PADDING_SIZE_LARGE,
                                                    vertical: Dimensions
                                                        .PADDING_SIZE_LARGE),
                                                child: CartListWidget(
                                                    cart: cart,
                                                    addOns: _addOnsList,
                                                    availableList:
                                                        _availableList),
                                              )),
                                            if (ResponsiveHelper.isDesktop(
                                                context))
                                              SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_LARGE),
                                            Expanded(
                                              child: Container(
                                                decoration: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? BoxDecoration(
                                                        color: Theme.of(context)
                                                            .cardColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                            BoxShadow(
                                                              color: ColorResources
                                                                  .CARD_SHADOW_COLOR
                                                                  .withOpacity(
                                                                      0.2),
                                                              blurRadius: 10,
                                                            )
                                                          ])
                                                    : BoxDecoration(),
                                                margin: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .PADDING_SIZE_SMALL,
                                                        vertical: Dimensions
                                                            .PADDING_SIZE_LARGE)
                                                    : EdgeInsets.all(0),
                                                padding: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .PADDING_SIZE_LARGE,
                                                        vertical: Dimensions
                                                            .PADDING_SIZE_LARGE)
                                                    : EdgeInsets.all(0),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Product
                                                      if (!ResponsiveHelper
                                                          .isDesktop(context))
                                                        CartListWidget(
                                                            cart: cart,
                                                            addOns: _addOnsList,
                                                            availableList:
                                                                _availableList),

                                                      // Coupon
                                                      Consumer<CouponProvider>(
                                                        builder: (context,
                                                            coupon, child) {
                                                          return Row(children: [
                                                            Expanded(
                                                              child: TextField(
                                                                controller:
                                                                    _couponController,
                                                                style:
                                                                    rubikRegular,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText: getTranslated(
                                                                      'enter_promo_code',
                                                                      context),
                                                                  hintStyle: rubikRegular
                                                                      .copyWith(
                                                                          color:
                                                                              ColorResources.getHintColor(context)),
                                                                  isDense: true,
                                                                  filled: true,
                                                                  enabled: coupon
                                                                          .discount ==
                                                                      0,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .horizontal(
                                                                      left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false)
                                                                              .isLtr
                                                                          ? 10
                                                                          : 0),
                                                                      right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false)
                                                                              .isLtr
                                                                          ? 0
                                                                          : 10),
                                                                    ),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                if (_couponController
                                                                        .text
                                                                        .isNotEmpty &&
                                                                    !coupon
                                                                        .isLoading) {
                                                                  if (coupon
                                                                          .discount <
                                                                      1) {
                                                                    coupon
                                                                        .applyCoupon(
                                                                            _couponController
                                                                                .text,
                                                                            _total)
                                                                        .then(
                                                                            (discount) {
                                                                      if (discount >
                                                                          0) {
                                                                        showCustomSnackBar(
                                                                            'You got ${PriceConverter.convertPrice(context, discount)} discount',
                                                                            context,
                                                                            isError:
                                                                                false);
                                                                      } else {
                                                                        showCustomSnackBar(
                                                                            getTranslated('invalid_code_or',
                                                                                context),
                                                                            context,
                                                                            isError:
                                                                                true);
                                                                      }
                                                                    });
                                                                  } else {
                                                                    coupon.removeCouponData(
                                                                        true);
                                                                  }
                                                                } else if (_couponController
                                                                    .text
                                                                    .isEmpty) {
                                                                  showCustomSnackBar(
                                                                      getTranslated(
                                                                          'enter_a_Coupon_code',
                                                                          context),
                                                                      context);
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 50,
                                                                width: 100,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .horizontal(
                                                                    left: Radius.circular(
                                                                        Provider.of<LocalizationProvider>(context, listen: false).isLtr
                                                                            ? 0
                                                                            : 10),
                                                                    right: Radius.circular(
                                                                        Provider.of<LocalizationProvider>(context, listen: false).isLtr
                                                                            ? 10
                                                                            : 0),
                                                                  ),
                                                                ),
                                                                child: coupon
                                                                            .discount <=
                                                                        0
                                                                    ? !coupon
                                                                            .isLoading
                                                                        ? Text(
                                                                            getTranslated('apply',
                                                                                context),
                                                                            style:
                                                                                rubikMedium.copyWith(color: Colors.white),
                                                                          )
                                                                        : CircularProgressIndicator(
                                                                            valueColor: AlwaysStoppedAnimation<Color>(Colors
                                                                                .white))
                                                                    : Icon(
                                                                        Icons
                                                                            .clear,
                                                                        color: Colors
                                                                            .white),
                                                              ),
                                                            ),
                                                          ]);
                                                        },
                                                      ),
                                                      SizedBox(
                                                          height: Dimensions
                                                              .PADDING_SIZE_LARGE),

                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                getTranslated(
                                                                    'items_price',
                                                                    context),
                                                                style: rubikRegular
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.FONT_SIZE_LARGE)),
                                                            Text(
                                                                PriceConverter
                                                                    .convertPrice(
                                                                        context,
                                                                        _itemPrice),
                                                                style: rubikRegular
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.FONT_SIZE_LARGE)),
                                                          ]),
                                                      SizedBox(height: 10),

                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                getTranslated(
                                                                    'tax',
                                                                    context),
                                                                style: rubikRegular
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.FONT_SIZE_LARGE)),
                                                            Text(
                                                                '(+) ${PriceConverter.convertPrice(context, _tax)}',
                                                                style: rubikRegular
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.FONT_SIZE_LARGE)),
                                                          ]),
                                                      SizedBox(height: 10),

                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                getTranslated(
                                                                    'discount',
                                                                    context),
                                                                style: rubikRegular
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.FONT_SIZE_LARGE)),
                                                            Text(
                                                                '(-) ${PriceConverter.convertPrice(context, _discount)}',
                                                                style: rubikRegular
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.FONT_SIZE_LARGE)),
                                                          ]),
                                                      SizedBox(height: 10),

                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                getTranslated(
                                                                    'coupon_discount',
                                                                    context),
                                                                style: rubikRegular
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.FONT_SIZE_LARGE)),
                                                            Text(
                                                              '(-) ${PriceConverter.convertPrice(context, Provider.of<CouponProvider>(context).discount)}',
                                                              style: rubikRegular
                                                                  .copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .FONT_SIZE_LARGE),
                                                            ),
                                                          ]),

                                                      Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: Dimensions
                                                                .PADDING_SIZE_SMALL),
                                                        child: CustomDivider(),
                                                      ),

                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                getTranslated(
                                                                    'total_amount',
                                                                    context),
                                                                style: rubikMedium
                                                                    .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .FONT_SIZE_EXTRA_LARGE,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                )),
                                                            Text(
                                                              PriceConverter
                                                                  .convertPrice(
                                                                      context,
                                                                      _total),
                                                              style: rubikMedium.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .FONT_SIZE_EXTRA_LARGE,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                          ]),
                                                      if (ResponsiveHelper
                                                          .isDesktop(context))
                                                        SizedBox(
                                                            height: Dimensions
                                                                .PADDING_SIZE_DEFAULT),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            Dimensions
                                                                .PADDING_SIZE_SMALL),
                                                        child: CustomTextField(
                                                          controller:
                                                              _noteController,
                                                          hintText: getTranslated(
                                                              'additional_note',
                                                              context),
                                                          maxLines: 5,
                                                          inputType:
                                                              TextInputType
                                                                  .multiline,
                                                          inputAction:
                                                              TextInputAction
                                                                  .newline,
                                                          capitalization:
                                                              TextCapitalization
                                                                  .sentences,
                                                        ),
                                                      ),

                                                      if (ResponsiveHelper
                                                          .isDesktop(context))
                                                        Container(
                                                          width: 1170,
                                                          padding: EdgeInsets
                                                              .all(Dimensions
                                                                  .PADDING_SIZE_SMALL),
                                                          child: !order
                                                                  .isLoading
                                                              ? CustomButton(
                                                                  btnTxt: getTranslated(
                                                                      'confirm_booking',
                                                                      context),
                                                                  onTap: () {
                                                                    processOrder(
                                                                        order,
                                                                        _total,
                                                                        context);
                                                                  })
                                                              : Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                  valueColor: new AlwaysStoppedAnimation<
                                                                      Color>(Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                                )),
                                                        ),
                                                    ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (ResponsiveHelper.isDesktop(context))
                                  FooterView(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!ResponsiveHelper.isDesktop(context))
                        Container(
                          width: 1170,
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: !order.isLoading
                              ? CustomButton(
                                  btnTxt:
                                      getTranslated('confirm_booking', context),
                                  onTap: () {
                                    if (_orderAmount <
                                        Provider.of<SplashProvider>(context,
                                                listen: false)
                                            .configModel
                                            .minimumOrderValue) {
                                      showCustomSnackBar(
                                          'Minimum order amount is ${PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue)}, you have ${PriceConverter.convertPrice(context, _orderAmount)} in your cart, please add more item.',
                                          context);
                                    } else {
                                      processOrder(order, _total, context);
                                    }
                                  })
                              : Center(
                                  child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                )),
                        ),
                    ],
                  )
                : NoDataScreen(isCart: true);
          },
        );
      }),
    );
  }

  void processOrder(OrderProvider order, double _total, BuildContext context) {
    bool _isAvailable = true;
    Map<String, dynamic> _tabledata =
        Provider.of<BookTableProvider>(context, listen: false)
            .getTableBookData();
    // DateTime _scheduleStartDate = DateTime.now();
    // DateTime _scheduleEndDate = DateTime.now();
    // if (order.timeSlots == null || order.timeSlots.length == 0) {
    //   _isAvailable = false;
    // } else {
    //   DateTime _date = order.selectDateSlot == 0
    //       ? DateTime.now()
    //       : DateTime.now().add(Duration(days: 1));
    //   DateTime _startTime = order.timeSlots[order.selectTimeSlot].startTime;
    //   DateTime _endTime = order.timeSlots[order.selectTimeSlot].endTime;
    //   _scheduleStartDate = DateTime(_date.year, _date.month, _date.day,
    //       _startTime.hour, _startTime.minute + 1);
    //   _scheduleEndDate = DateTime(_date.year, _date.month, _date.day,
    //       _endTime.hour, _endTime.minute + 1);
    //   _cartList = [];
    //   _cartList
    //       .addAll(Provider.of<CartProvider>(context, listen: false).cartList);
    //   for (CartModel cart in _cartList) {
    //     if (!DateConverter.isAvailable(
    //           cart.product.availableTimeStarts,
    //           cart.product.availableTimeEnds,
    //           context,
    //           time: _scheduleStartDate ?? null,
    //         ) &&
    //         !DateConverter.isAvailable(cart.product.availableTimeStarts,
    //             cart.product.availableTimeEnds, context,
    //             time: _scheduleEndDate ?? null)) {
    //       _isAvailable = false;
    //       break;
    //     }
    //   }
    // }
    if (_total <
        Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .minimumOrderValue) {
      showCustomSnackBar(
          'Minimum order amount is ${Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue}',
          context);
    } else if (order.timeSlots == null || order.timeSlots.length == 0) {
      showCustomSnackBar(getTranslated('select_a_time', context), context);
    } else if (!_isAvailable) {
      showCustomSnackBar(
          getTranslated(
              'one_or_more_products_are_not_available_for_this_selected_time',
              context),
          context);
    } else {
      List<Cart> carts = [];
      for (int index = 0; index < _cartList.length; index++) {
        CartModel cart = _cartList[index];
        List<int> _addOnIdList = [];
        List<int> _addOnQtyList = [];
        cart.addOnIds.forEach((addOn) {
          _addOnIdList.add(addOn.id);
          _addOnQtyList.add(addOn.quantity);
        });
        carts.add(Cart(
          cart.product.id.toString(),
          cart.discountedPrice.toString(),
          '',
          cart.variation,
          cart.discountAmount,
          cart.quantity,
          cart.taxAmount,
          _addOnIdList,
          _addOnQtyList,
        ));
      }
      PlaceOrderBody _placeOrderBody = PlaceOrderBody(
        cart: carts,
        couponDiscountAmount:
            Provider.of<CouponProvider>(context, listen: false).discount,
        couponDiscountTitle:
            _couponController.text.isNotEmpty ? _couponController.text : null,
        deliveryAddressId: 0,
        orderAmount: _total,
        orderNote: _noteController.text ?? '',
        orderType: 'buffet',
        paymentMethod: 'cash_on_delivery',
        couponCode: _couponController.text.toString().isNotEmpty
            ? _couponController.text.toString()
            : null,
        distance: 0,
        branchId: _tabledata.isNotEmpty
            ? _tabledata['branch_id']
            : _branches[order.branchIndex].id,
        deliveryDate: _tabledata['date'],
        deliveryTime: _tabledata['time'],
      );
      order.placeOrder(_placeOrderBody, _callback);
    }
  }

  void _callback(
      bool isSuccess, String message, String orderID, int addressID) async {
    if (isSuccess) {
      Provider.of<CartProvider>(context, listen: false).clearCartList();
      Provider.of<OrderProvider>(context, listen: false).stopLoader();

      Navigator.pushReplacementNamed(
          context, '${Routes.ORDER_SUCCESS_SCREEN}/$orderID/booking-success');
    } else {
      showCustomSnackBar(message, context);
    }
  }
}

class CartListWidget extends StatelessWidget {
  final CartProvider cart;
  final List<List<AddOns>> addOns;
  final List<bool> availableList;
  const CartListWidget(
      {Key key,
      @required this.cart,
      @required this.addOns,
      @required this.availableList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cart.cartList.length,
      itemBuilder: (context, index) {
        return CartProductWidget(
            cart: cart.cartList[index],
            cartIndex: index,
            addOns: addOns[index],
            isAvailable: availableList[index]);
      },
    );
  }
}
