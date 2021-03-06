import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/cups.dart';
import 'package:flutter_complete_guide/screens/cupsOverView.dart';
import 'package:flutter_complete_guide/screens/splash_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';

import './screens/edit_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.uerId),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(auth.token,
              previousOrders == null ? [] : previousOrders.orders, auth.uerId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: HexColor('#f1d2c5'),
            accentColor: HexColor('#d4dee2'),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreeen()
                          : AuthScreen(),
                ),
          routes: {
            ProductsOverviewScreen.routName: (ctx) => ProductsOverviewScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            Cups.routeName: (ctx) => Cups(),
            CupsOverView.routeName: (ctx) => CupsOverView(),
          },
        ),
      ),
    );
  }
}
