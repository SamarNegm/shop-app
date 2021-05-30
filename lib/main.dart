import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/users.dart';
import 'package:flutter_complete_guide/providers/Users.dart';
import 'package:flutter_complete_guide/screens/CreditCard.dart';
import 'package:flutter_complete_guide/screens/Ordering.dart';
import 'package:flutter_complete_guide/screens/ProductOverView.dart';
import 'package:flutter_complete_guide/screens/ProductType.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/splash_screen.dart';
import 'package:flutter_complete_guide/screens/types.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

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
        ChangeNotifierProxyProvider<Auth, Users>(
          update: (ctx, auth, previousUsers) => Users(
              auth.token,
              previousUsers == null
                  ? users(name: '', email: '')
                  : previousUsers.usres,
              auth.uerId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: Color(0xfff1d2c5),
            accentColor: Color(0xffd4dee2),
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
            Types.routeName: (ctx) => Types(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            ProductType.routeName: (ctx) => ProductType(),
            ProductOverView.routeName: (ctx) => ProductOverView(),
            Ordering.routeName: (ctx) => Ordering(),
            CreditCard.routeName: (ctx) => CreditCard(),
          },
        ),
      ),
    );
  }
}
