import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/icons/my_flutter_app_icons.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/cups.dart';
import 'package:flutter_complete_guide/screens/cupsOverView.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        //HexColor('#222831'),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Divider(),
                ListTile(
                  leading: Icon(Icons.shop, color: HexColor('#222831')),
                  title: Text('Shop'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.payment, color: HexColor('#222831')),
                  title: Text(
                    'Orders',
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(OrdersScreen.routeName);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.edit, color: HexColor('#222831')),
                  title: Text('Manage Products'),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(UserProductsScreen.routeName);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    MyFlutterApp.coffee,
                    color: HexColor('#222831'),
                  ),
                  title: Text('Cups'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(Cups.routeName);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: HexColor('#222831')),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Provider.of<Auth>(context, listen: false).logout();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
