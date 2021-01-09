import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail4';

  @override
  Widget build(BuildContext context) {
    int itemCount = 1;
    final deviceSize = MediaQuery.of(context).size;
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    if (productId == null) {
      print('ok');
      return ProductsOverviewScreen();
    }
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
        appBar: AppBar(
          title: Text(loadedProduct.title),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    SizedBox(
                      height: deviceSize.height * .44,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                        child: Card(
                          elevation: 1,
                          shadowColor: Colors.black,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
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
                                      child: Icon(
                                        Icons.favorite,
                                        size: deviceSize.height * .05,
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                      Text(
                                        loadedProduct.description,
                                        style: TextStyle(fontSize: 20),
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
                                '\$${loadedProduct.price}',
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
                                          onPressed: () {},
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
                                          onPressed: () {},
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
                    SizedBox(
                      height: 30,
                    ),
                  ])),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 15.0, left: 30, right: 30, top: 15),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text(
                      'Add to chart',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                ),
              ),
            ]));
  }
}
