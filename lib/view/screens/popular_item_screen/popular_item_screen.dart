import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';


class PopularItemScreen extends StatefulWidget {
  @override
  State<PopularItemScreen> createState() => _PopularItemScreenState();
}

class _PopularItemScreenState extends State<PopularItemScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).getPopularProductList(context, true,'1',
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          (_productProvider.popularProductList != null) && !_productProvider.isLoading
      ) {
        int pageSize;
        pageSize = (_productProvider.popularPageSize / 10).ceil();
        if (_productProvider.popularOffset < pageSize) {
          _productProvider.popularOffset ++;
          _productProvider.showBottomLoader();

          _productProvider.getPopularProductList(context, false, _productProvider.popularOffset.toString(),
              Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);

        }
      }
    });
    return Scaffold(
      appBar: CustomAppBar(context: context, title: getTranslated('popular_item', context)),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return productProvider.popularProductList != null ? productProvider.popularProductList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<ProductProvider>(context, listen: false).getPopularProductList(context, true, '1',
                  Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: GridView.builder(
                      gridDelegate: ResponsiveHelper.isDesktop(context)
                          ? SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 3.5,
                        crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1,
                      ),
                      itemCount: productProvider.popularProductList.length,
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ResponsiveHelper.isDesktop(context) ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ProductWidgetWeb(product: productProvider.popularProductList[index]),
                        ) : ProductWidget(product: productProvider.popularProductList[index]);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ) : NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
