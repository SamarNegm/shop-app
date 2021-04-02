import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class userProductItem2 extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  userProductItem2({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: GridTile(
        child: Container(
          color: Theme.of(context).accentColor,
          child: Image.network(
            imageUrl,
            fit: BoxFit.scaleDown,
          ),
        ),
        header: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(title),
        ),
        footer: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: HexColor('#222831'),
                ),
                onPressed: () async {
                  print('id is ' + id);
                  await Provider.of<Products>(context, listen: false)
                      .fetchAndSetProducts(true, '');
                  final productsData =
                      await Provider.of<Products>(context, listen: false).items;
                  print('poddata len' + productsData.length.toString());
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id)
                      .catchError((_) {
                    print('i got your error');
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content:
                          Text('some thing went wrong cant delete the product'),
                    ));
                  });
                  print('done@@@@@@@@@@@@@');
                },
                color: Theme.of(context).errorColor,
              ),
            ]),
      ),
    );
  }
}
