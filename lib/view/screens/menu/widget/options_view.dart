import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class OptionsView extends StatelessWidget {
  final Function onTap;
  OptionsView({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        child: Center(
          child: SizedBox(
            width: ResponsiveHelper.isTab(context) ? null : 1170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: ResponsiveHelper.isTab(context) ? 50 : 0),

                SwitchListTile(
                  value: Provider.of<ThemeProvider>(context).darkTheme,
                  onChanged: (bool isActive) =>Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                  title: Text(getTranslated('dark_theme', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  activeColor: Theme.of(context).primaryColor,
                ),

                ResponsiveHelper.isTab(context) ? ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('home')),
                  leading: Image.asset(Images.home, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text(getTranslated('home', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ) : SizedBox(),

                ListTile(
                  onTap: () => ResponsiveHelper.isMobilePhone() ? onTap(2) : Navigator.pushNamed(context, Routes.getDashboardRoute('order')),
                  leading: Image.asset(Images.order, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text(getTranslated('my_order', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  onTap: () =>  Navigator.pushNamed(context, Routes.getProfileRoute()),
                  leading: Image.asset(Images.profile, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text(getTranslated('profile', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getAddressRoute()),
                  leading: Image.asset(Images.location, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text(getTranslated('address', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getChatRoute(orderModel: null)),
                  leading: Image.asset(Images.message, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text(getTranslated('message', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getCouponRoute()),
                  leading: Image.asset(Images.coupon, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text(getTranslated('coupon', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ResponsiveHelper.isDesktop(context) ? ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
                  leading: Image.asset(Images.notification, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text(getTranslated('notifications', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ) : SizedBox(),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getLanguageRoute('menu')),
                  leading: Image.asset(Images.language, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text(getTranslated('language', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getSupportRoute()),
                  leading: Container(width:20,height: 20,child: Image.asset(Images.help_support,color: ColorResources.getWhiteAndBlack(context),)),
                  title: Text(getTranslated('help_and_support', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getPolicyRoute()),
                  leading: Container(width:20,height: 20,child: Image.asset(Images.privacy_policy,color: ColorResources.getWhiteAndBlack(context),)),
                  title: Text(getTranslated('privacy_policy', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getTermsRoute()),
                  leading: Container(width:20,height: 20,child: Image.asset(Images.terms_and_condition,color: ColorResources.getWhiteAndBlack(context),)),
                  title: Text(getTranslated('terms_and_condition', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute()),
                  leading: Container(width:20,height: 20,child: Image.asset(Images.about_us,color: ColorResources.getWhiteAndBlack(context),)),
                  title: Text(getTranslated('about_us', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  leading: Image.asset(Images.version, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text('${getTranslated('version', context)}', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  trailing: Text('${Provider.of<SplashProvider>(context, listen: false).configModel.softwareVersion ?? ''}', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  //
                ),

                ListTile(
                  onTap: () {
                    if(_isLoggedIn) {
                      showDialog(context: context, barrierDismissible: false, builder: (context) => SignOutConfirmationDialog());
                    }else {
                      Navigator.pushNamed(context, Routes.getLoginRoute());
                    }
                  },
                  leading: Image.asset(Images.login, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text(getTranslated(_isLoggedIn ? 'logout' : 'login', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
