import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/html_type.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/map_widget.dart';
import 'package:flutter_restaurant/view/base/not_found.dart';
import 'package:flutter_restaurant/view/screens/address/add_new_address_screen.dart';
import 'package:flutter_restaurant/view/screens/address/address_screen.dart';
import 'package:flutter_restaurant/view/screens/address/select_location_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/create_account_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/login_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/maintainance_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/signup_screen.dart';
import 'package:flutter_restaurant/view/screens/category/category_screen.dart';
import 'package:flutter_restaurant/view/screens/chat/chat_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/checkout_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/order_successful_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/payment_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/order_web_payment.dart';
import 'package:flutter_restaurant/view/screens/coupon/coupon_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/create_new_password_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/verification_screen.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:flutter_restaurant/view/screens/html/html_viewer_screen.dart';
import 'package:flutter_restaurant/view/screens/language/choose_language_screen.dart';
import 'package:flutter_restaurant/view/screens/menu/web/menu_screen_web.dart';
import 'package:flutter_restaurant/view/screens/notification/notification_screen.dart';
import 'package:flutter_restaurant/view/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_restaurant/view/screens/order/order_details_screen.dart';
import 'package:flutter_restaurant/view/screens/popular_item_screen/popular_item_screen.dart';
import 'package:flutter_restaurant/view/screens/profile/profile_screen.dart';
import 'package:flutter_restaurant/view/screens/rare_review/rate_review_screen.dart';
import 'package:flutter_restaurant/view/screens/search/search_result_screen.dart';
import 'package:flutter_restaurant/view/screens/search/search_screen.dart';
import 'package:flutter_restaurant/view/screens/setmenu/set_menu_screen.dart';
import 'package:flutter_restaurant/view/screens/splash/splash_screen.dart';
import 'package:flutter_restaurant/view/screens/support/support_screen.dart';
import 'package:flutter_restaurant/view/screens/track/order_tracking_screen.dart';
import 'package:flutter_restaurant/view/screens/update/update_screen.dart';
import 'package:flutter_restaurant/view/screens/welcome_screen/welcome_screen.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

//*******Handlers*********
  static Handler _splashHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => SplashScreen());
  static Handler _maintainHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => MaintenanceScreen());
  // ignore: non_constant_identifier_names, missing_required_param
  static Handler _menu_screen_web_hendeler = Handler(handlerFunc: (context, Map<String, dynamic> params) => MenuScreenWeb());

  static Handler _languageHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return ChooseLanguageScreen(fromMenu: params['page'][0] == 'menu');
  });

  static Handler _onbordingHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => OnBoardingScreen());

  static Handler _welcomeHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => WelcomeScreen());

  static Handler _loginHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => LoginScreen());

  static Handler _signUpHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => SignUpScreen());

  static Handler _verificationHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    VerificationScreen _verificationScreen = ModalRoute.of(context).settings.arguments;
    return _verificationScreen != null ? _verificationScreen : VerificationScreen(
      fromSignUp: params['page'][0] == 'sign-up', emailAddress: params['email'][0],
    );
  });

  static Handler _forgotPassHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => ForgotPasswordScreen());

  static Handler _createNewPassHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        CreateNewPasswordScreen _createPassScreen = ModalRoute.of(context).settings.arguments;
        return _createPassScreen != null ? _createPassScreen : CreateNewPasswordScreen(
          email: params['email'][0], resetToken: params['token'][0],
        );
      }
  );

  static Handler _createAccountHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return CreateAccountScreen(email: params['email'][0]);
  });

  static Handler _dashScreenBoardHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return DashboardScreen(pageIndex: params['page'][0] == 'home' ? 0 : params['page'][0] == 'cart' ? 1 : params['page'][0] == 'order' ? 2
        : params['page'][0] == 'favourite' ? 3 : params['page'][0] == 'menu' ? 4 : 0);
  });
  static Handler __homeScreenHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return HomeScreen(params['from'][0] == 'true' ? true : false);
  });

  static Handler _deshboardHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => DashboardScreen(pageIndex: 0));

  static Handler _searchHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => SearchScreen());

  static Handler _searchResultHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    // return SearchResultScreen(searchString: params['text'][0].replaceAll('-', ' '));
    //print('--------------${params['text'][0]}');
    List<int> _decode = base64Decode(params['text'][0]);
    String _data = utf8.decode(_decode);
    return SearchResultScreen(searchString: _data);

  });
  static Handler _updateHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => UpdateScreen());

  static Handler _setMenuHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => SetMenuScreen());

  static Handler _categoryHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    CategoryScreen _categoryScreen = ModalRoute.of(context).settings.arguments;
    return _categoryScreen != null ? _categoryScreen : CategoryScreen(categoryModel: CategoryModel(id: int.parse(params['id'][0])));
  });

  static Handler _notificationHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => NotificationScreen());

  static Handler _checkoutHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    CheckoutScreen _checkoutScreen = ModalRoute.of(context).settings.arguments as CheckoutScreen;
    bool _fromCart = params['page'][0] == 'cart';
    return _checkoutScreen != null ? _checkoutScreen : !_fromCart ? NotFound() : CheckoutScreen(
      amount: double.parse(params['amount'][0]), orderType: params['type'][0], cartList: null,
      fromCart: params['page'][0] == 'cart', couponCode: params['code'][0],
    );
  });

  static Handler _paymentHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        bool _fromCheckOut = params['page'][0] == 'checkout';
        String _decoded = _fromCheckOut ? utf8.decode(base64Url.decode(params['place_order'][0].replaceAll(' ', '+'))) : 'null';

        return PaymentScreen(
            fromCheckout: _fromCheckOut,
            orderModel: _fromCheckOut ? OrderModel() :  OrderModel(userId:  int.parse(params['user'][0]), id: int.parse(params['id'][0])),
            url: _fromCheckOut ?'${utf8.decode(base64Decode(params['address'][0]))}' : '' ,
            placeOrderBody: _decoded != 'null' ?  PlaceOrderBody.fromJson(jsonDecode(_decoded)) : null
        );
      }
  );

  static Handler _orderSuccessHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        print('calling ====>>>>>');
        int _status = (params['status'][0] == 'success' || params['status'][0] == 'payment-success') ? 0 : params['status'][0] == 'fail' ? 1 : 2;
        return OrderSuccessfulScreen(orderID: params['id'][0], status: _status);
      }
  );

  static Handler _orderWebPaymentHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        // String _decoded =  utf8.decode(base64Url.decode(params['place_order'][0].replaceAll(' ', '+')));
        // int _status = (params['status'][0] == 'success' || params['status'][0] == 'payment-success') ? 0 : params['status'][0] == 'fail' ? 1 : 2;
        return OrderWebPayment(token: params['token'][0],);
      }
  );

  static Handler _orderDetailsHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        OrderDetailsScreen _orderDetailsScreen = ModalRoute.of(context).settings.arguments as OrderDetailsScreen;
        return _orderDetailsScreen != null ? _orderDetailsScreen : OrderDetailsScreen(orderId: int.parse(params['id'][0]), orderModel: null);
      }
  );

  static Handler _rateReviewHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    RateReviewScreen _rateReviewScreen =  ModalRoute.of(context).settings.arguments as RateReviewScreen;
    return _rateReviewScreen != null ? _rateReviewScreen : NotFound();
  });

  static Handler _orderTrackingHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        return OrderTrackingScreen(orderID: params['id'][0]);
      }
  );

  static Handler _profileHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => ProfileScreen());

  static Handler _addressHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => AddressScreen());

  static Handler _mapHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    List<int> _decode = base64Decode(params['address'][0].replaceAll(' ', '+'));
    DeliveryAddress _data = DeliveryAddress.fromJson(jsonDecode(utf8.decode(_decode)));
    return MapWidget(address: _data);
  });

  static Handler _newAddressHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    bool _isUpdate = params['action'][0] == 'update';
    AddressModel _addressModel;
    if(_isUpdate) {
      String _decoded = utf8.decode(base64Url.decode(params['address'][0].replaceAll(' ', '+')));
      _addressModel = AddressModel.fromJson(jsonDecode(_decoded));
    }
    return AddNewAddressScreen(fromCheckout: params['page'][0] == 'checkout', isEnableUpdate: _isUpdate, address: _isUpdate ? _addressModel : null);
  });

  static Handler _selectLocationHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    SelectLocationScreen _locationScreen =  ModalRoute.of(context).settings.arguments;
    return _locationScreen != null ? _locationScreen : NotFound();
  });

  static Handler _chatHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    final _orderModel = jsonDecode(utf8.decode(base64Url.decode(params['order'][0].replaceAll(' ', '+'))));
    return ChatScreen(orderModel : _orderModel != null ? OrderModel.fromJson(_orderModel) : null);
  });

  static Handler _couponHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => CouponScreen());

  static Handler _supportHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => SupportScreen());

  static Handler _termsHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => HtmlViewerScreen(htmlType: HtmlType.TERMS_AND_CONDITION));

  static Handler _policyHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => HtmlViewerScreen(htmlType: HtmlType.PRIVACY_POLICY));

  static Handler _aboutUsHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => HtmlViewerScreen(htmlType: HtmlType.ABOUT_US));

  static Handler _notFoundHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => NotFound());

  static Handler _popularItemScreenHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => PopularItemScreen());





//*******Route Define*********
  static void setupRouter() {
    router.notFoundHandler = _notFoundHandler;
    router.define(Routes.SPLASH_SCREEN, handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.LANGUAGE_SCREEN, handler: _languageHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ONBOARDING_SCREEN, handler: _onbordingHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.WELCOME_SCREEN, handler: _welcomeHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.LOGIN_SCREEN, handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SIGNUP_SCREEN, handler: _signUpHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.VERIFY, handler: _verificationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CREATEACCOUNT_SCREEN, handler: _createAccountHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.FORGOTPASS_SCREEN, handler: _forgotPassHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CREATENEWPASS_SCREEN, handler: _createNewPassHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.DASHBOARD_SCREEN, handler: _dashScreenBoardHandler, transitionType: TransitionType.fadeIn); // ?page=home
    router.define(Routes.HOME_SCREEN, handler: __homeScreenHandler, transitionType: TransitionType.fadeIn); // ?page=home
    router.define(Routes.DASHBOARD, handler: _deshboardHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SEARCH_SCREEN, handler: _searchHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SEARCH_RESULT_SCREEN, handler: _searchResultHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CATEGORY_SCREEN, handler: _categoryHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SET_MENU_SCREEN, handler: _setMenuHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.NOTIFICATION_SCREEN, handler: _notificationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CHECKOUT_SCREEN, handler: _checkoutHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PAYMENT_SCREEN, handler: _paymentHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ORDER_SUCCESS_SCREEN +  '/:id/:status', handler: _orderSuccessHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ORDER_WEB_PAYMENT + '/:status?:token', handler: _orderWebPaymentHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ORDER_DETAILS_SCREEN, handler: _orderDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.RATE_SCREEN, handler: _rateReviewHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ORDERTRAKING_SCREEN, handler: _orderTrackingHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PROFILE_SCREEN, handler: _profileHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ADDRESS_SCREEN, handler: _addressHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.MAP_SCREEN, handler: _mapHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ADD_ADDRESS_SCREEN, handler: _newAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SELECTLOCATION_SCREEN, handler: _selectLocationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CHAT_SCREEN, handler: _chatHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.COUPON_SCREEN, handler: _couponHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SUPPORT_SCREEN, handler: _supportHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.TERMS_SCREEN, handler: _termsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.POLICY_SCREEN, handler: _policyHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ABOUT_US_SCREEN, handler: _aboutUsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.MAINTAIN, handler: _maintainHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.MENU_SCREEN_WEB, handler: _menu_screen_web_hendeler, transitionType: TransitionType.fadeIn);
    router.define(Routes.UPDATE, handler: _updateHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.POPULAR_ITEM_ROUTE, handler: _popularItemScreenHandler, transitionType: TransitionType.fadeIn);
  }
}