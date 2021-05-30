import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/screens/ProductType.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Container(
          //  color: Theme.of(context).primaryColor,
          color: Color(0xff222831),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [Text('')],
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.shop,
                                color: Theme.of(context).primaryColor),
                            title: Text(
                              'Shop',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed('/');
                            },
                          ),
                          Divider(color: Theme.of(context).primaryColor),
                          ListTile(
                            leading: Icon(Icons.payment,
                                color: Theme.of(context).primaryColor),
                            title: Text(
                              'Orders',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(OrdersScreen.routeName);
                            },
                          ),
                          Divider(color: Theme.of(context).primaryColor),
                          ListTile(
                            leading: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image(
                                fit: BoxFit.contain,
                                image: AssetImage('assets/images/mug.png'),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            title: Text(
                              'Cups',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  ProductType.routeName,
                                  arguments: 'cups');
                            },
                          ),
                          Divider(color: Theme.of(context).primaryColor),
                          ListTile(
                            leading: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image(
                                image: AssetImage('assets/images/plate.png'),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            title: Text(
                              'Dishes',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                ProductType.routeName,
                                arguments: 'dishes',
                              );
                            },
                          ),
                          Divider(color: Theme.of(context).primaryColor),
                          ListTile(
                            leading: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image(
                                image: AssetImage('assets/images/cutlery.png'),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            title: Text(
                              'Spoons',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  ProductType.routeName,
                                  arguments: 'spoons');
                            },
                          ),
                          Divider(color: Theme.of(context).primaryColor),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: ListTile(
                        leading: Icon(Icons.exit_to_app,
                            color: Theme.of(context).primaryColor),
                        title: Text(
                          'Logout',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Provider.of<Auth>(context, listen: false).logout();
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
