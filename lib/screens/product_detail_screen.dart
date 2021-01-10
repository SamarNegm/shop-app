import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatefulWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail4';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int itemCount = 1;

  bool added = false;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    if (productId == null) {
      print('ok');
      return ProductsOverviewScreen();
    }
    final loadedProduct = Provider.of<Products>(
      context,
      listen: true,
    ).findById(productId);
    double totalPrice = loadedProduct.price;
    final authData = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    void incAndDecrement(int curNum, String operatin) {
      if (operatin == '+') {
        curNum++;
      } else {
        if (curNum > 1) curNum--;
      }
      print(curNum);
      setState(() {
        print('hi');
        itemCount = curNum;
        totalPrice = loadedProduct.price * itemCount;
      });
    }

    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          SizedBox(
              height: deviceSize.height * .7,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: deviceSize.height * .5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50)),
                          child: Card(
                            elevation: 1,
                            shadowColor: Colors.black,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          loadedProduct.title,
                                          style: TextStyle(fontSize: 35),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          icon: Icon(
                                            loadedProduct.isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                          ),
                                          iconSize: deviceSize.height * .05,
                                          onPressed: () {
                                            setState(() {});
                                            loadedProduct.toggleFavoriteStatus(
                                                authData.token, authData.uerId);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, right: 20, bottom: 8, top: 0),
                                  child: SizedBox(
                                    height: deviceSize.height * .2,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: deviceSize.height * .2,
                                          width: deviceSize.height * .2,
                                          child: Image.network(
                                            loadedProduct.imageUrl,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            loadedProduct.description,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        )
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(fontSize: 35),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, top: 12, bottom: 12),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${(totalPrice != 0 ? totalPrice : loadedProduct.price)}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 35,
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: FloatingActionButton(
                                            onPressed: () =>
                                                incAndDecrement(itemCount, '+'),
                                            heroTag: 'f1',
                                            child: Text(
                                              '+',
                                              style: TextStyle(fontSize: 25),
                                            ),

                                            //highlightElevation: deviceSize.height * .0150
                                          ),
                                          height: deviceSize.height * .07,
                                        ),
                                        Container(
                                          child: Text(
                                            '  $itemCount  ',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                        Container(
                                          child: FloatingActionButton(
                                            onPressed: () =>
                                                incAndDecrement(itemCount, '-'),
                                            heroTag: 'f2',
                                            child: Text(
                                              '-',
                                              style: TextStyle(fontSize: 25),
                                            ),
                                          ),
                                          height: deviceSize.height * .07,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ])),
                    ]),
              )),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 15.0, left: 30, right: 30, top: 15),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: added
                  ? Row(
                      children: [
                        Text('Item added to chart'),
                        RaisedButton(
                          child: Text(
                            'Open',
                            style: TextStyle(color: Colors.black, fontSize: 24),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(CartScreen.routeName);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          color: Theme.of(context).primaryColor,
                          textColor:
                              Theme.of(context).primaryTextTheme.button.color,
                        ),
                      ],
                    )
                  : RaisedButton(
                      child: Text(
                        'Add to chart',
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      onPressed: () {
                        print(totalPrice);
                        cart.addItem(
                            loadedProduct.id,
                            totalPrice,
                            loadedProduct.title,
                            itemCount,
                            loadedProduct.imageUrl);
                        setState(() {
                          added = true;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
            ),
          ),
        ]));
  }
}
