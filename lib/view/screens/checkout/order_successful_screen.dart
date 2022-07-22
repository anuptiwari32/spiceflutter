import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  final String orderID;
  final int status;
  OrderSuccessfulScreen({@required this.orderID, @required this.status});

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
           ResponsiveHelper.isDesktop(context)?
           Container(
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
               boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme? 900 : 200],
                   spreadRadius: 2,blurRadius: 5,offset: Offset(0, 5))],
             ),
             child: Padding(
               padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
               child: Center(
                 child: ConstrainedBox(
                   constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                   child: Container(
                     width: 1170,
                     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                       Container(
                         height: 100, width: 100,
                         decoration: BoxDecoration(
                           color: Theme.of(context).primaryColor.withOpacity(0.2),
                           shape: BoxShape.circle,
                         ),
                         child: Icon(
                           status == 0 ? Icons.check_circle : status == 1 ? Icons.sms_failed : Icons.cancel,
                           color: Theme.of(context).primaryColor, size: 80,
                         ),
                       ),
                       SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                       Text(
                         getTranslated(status == 0 ? 'order_placed_successfully' : status == 1 ? 'payment_failed' : 'payment_cancelled', context),
                         style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                       ),
                       SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                       if(status == 0) Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                         Text('${getTranslated('order_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                         SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                         Text(orderID, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                       ]),
                       SizedBox(height: 30),

                       Container(width: ResponsiveHelper.isDesktop(context) ? 400:MediaQuery.of(context).size.width,
                         child: Padding(
                           padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                           child: CustomButton(btnTxt: getTranslated(status == 0 ? 'track_order' : 'back_home', context), onTap: () {
                             if(status == 0) {
                               Navigator.pushReplacementNamed(context, Routes.getOrderTrackingRoute(int.parse(orderID)));
                             }else {
                               Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                             }
                           }),
                         ),
                       ),
                     ]),
                   ),
                 ),
               ),
             ),
           ): Container(
             width: 1170,
             child: Center(
               child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                 SizedBox(height: _height * 0.2),
                 Container(
                   height: 100, width: 100,
                   decoration: BoxDecoration(
                     color: Theme.of(context).primaryColor.withOpacity(0.2),
                     shape: BoxShape.circle,
                   ),
                   child: Icon(
                     status == 0 ? Icons.check_circle : status == 1 ? Icons.sms_failed : Icons.cancel,
                     color: Theme.of(context).primaryColor, size: 80,
                   ),
                 ),
                 SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                 Text(
                   getTranslated(status == 0 ? 'order_placed_successfully' : status == 1 ? 'payment_failed' : 'payment_cancelled', context),
                   style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                 ),
                 SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                if(status == 0)  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                   Text('${getTranslated('order_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                   SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                   Text(orderID, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                 ]),

                 SizedBox(height: 30),

                 Container(width: ResponsiveHelper.isDesktop(context) ? 400:MediaQuery.of(context).size.width,
                   child: Padding(
                     padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                     child: CustomButton(btnTxt: getTranslated(status == 0 ? 'track_order' : 'back_home', context), onTap: () {
                       if(status == 0) {
                         Navigator.pushReplacementNamed(context, Routes.getOrderTrackingRoute(int.parse(orderID)));
                       }else {
                         Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                       }
                     }),
                   ),
                 ),
               ]),
             ),
           ),
            if(ResponsiveHelper.isDesktop(context)) FooterView(),
          ],
        ),
      ),
    );
  }
}
