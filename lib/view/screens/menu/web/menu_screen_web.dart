import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/screens/menu/web/menu_item_web.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class MenuScreenWeb extends StatelessWidget {
  final bool isLoggedIn;
  const MenuScreenWeb({Key key, @required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
            children: [
              Center(
                child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    return SizedBox(
                      width: 1170,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                  height: 150,  color:  ColorResources.getProfileMenuHeaderColor(context),
                               alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 240.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                                      '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                      style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.getWhiteAndBlack(context)),
                                    ) : SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT, width: 150) : Text(
                                      getTranslated('guest', context),
                                      style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.getWhiteAndBlack(context)),
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                    isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                                      '${profileProvider.userInfoModel.email ?? ''}',
                                      style: robotoRegular.copyWith(color: ColorResources.getWhiteAndBlack(context)),
                                    ) : SizedBox(height: 15, width: 100) : Text(
                                      'demo@demo.com',
                                      style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.getWhiteAndBlack(context)),
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                    isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                                      '${getTranslated('points', context)}: ${profileProvider.userInfoModel.point ?? ''}',
                                      style: rubikRegular.copyWith(color: ColorResources.getWhiteAndBlack(context)),
                                    ) : Container(height: 15, width: 100, color: Colors.white) : SizedBox(),


                                  ],
                                ),

                              ),
                              SizedBox(height: 100),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      MenuItemWeb(image: Images.order, title: getTranslated('my_order', context), onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('order')),),
                                      MenuItemWeb(image: Images.profile, title: getTranslated('profile', context), onTap: () =>  Navigator.pushNamed(context, Routes.getProfileRoute())),
                                      MenuItemWeb(image: Images.location, title: getTranslated('address', context), onTap: () => Navigator.pushNamed(context, Routes.getAddressRoute())),
                                      MenuItemWeb(image: Images.message, title: getTranslated('message', context), onTap: () => Navigator.pushNamed(context, Routes.getChatRoute(orderModel: null))),
                                      MenuItemWeb(image: Images.coupon, title: getTranslated('coupon', context), onTap: () => Navigator.pushNamed(context, Routes.getCouponRoute())),
                                      MenuItemWeb(image: Images.notification, title: getTranslated('notifications', context), onTap: () => Navigator.pushNamed(context, Routes.getNotificationRoute())),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                     // MenuItemWeb(image: Images.language, title: getTranslated('language', context), onTap: () => Navigator.pushNamed(context, Routes.getLanguageRoute('menu'))),
                                      MenuItemWeb(image: Images.help_support, title: getTranslated('help_and_support', context), onTap: () =>  Navigator.pushNamed(context, Routes.getSupportRoute())),
                                      MenuItemWeb(image: Images.privacy_policy, title: getTranslated('privacy_policy', context), onTap: () => Navigator.pushNamed(context, Routes.getPolicyRoute())),
                                      MenuItemWeb(image: Images.terms_and_condition, title: getTranslated('terms_and_condition', context), onTap: () => Navigator.pushNamed(context, Routes.getTermsRoute())),
                                      MenuItemWeb(image: Images.about_us, title: getTranslated('about_us', context), onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute())),
                                      MenuItemWeb(image: Images.version, title: "${getTranslated('version', context)} ${Provider.of<SplashProvider>(context, listen: false).configModel.softwareVersion ?? ''}", onTap: () {}),
                                      MenuItemWeb(image: Images.login, title: getTranslated(isLoggedIn ? 'logout' : 'login', context),
                                        onTap: () => isLoggedIn ? showDialog(context: context, barrierDismissible: false, builder: (context) => SignOutConfirmationDialog()) :Navigator.pushNamed(context, Routes.getLoginRoute()),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 50.0)
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            left: 30,
                            top: 45,
                            child: Builder(
                              builder: (context) {
                                return Container(
                                  height: 180, width: 180,
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4),
                                      boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 22, offset: Offset(0, 8.8) )]),
                                  child: ClipOval(
                                    child: isLoggedIn ? FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder_user, height: 170, width: 170, fit: BoxFit.cover,
                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                                          '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
                                     // imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_user, height: 170, width: 170, fit: BoxFit.cover),
                                    ) : Image.asset(Images.placeholder_user, height: 170, width: 170, fit: BoxFit.cover),
                                  ),
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
              FooterView(),
            ],
      ),
    );
  }
}
