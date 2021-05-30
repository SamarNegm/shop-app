import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: Container(
              color: Theme.of(context).accentColor,
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                  width: MediaQuery.of(context).size.height * .2,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
          ),
        ),
        header: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            product.title,
            style: TextStyle(
              color: Color(0xff222831),
            ),
          ),
        ),
        footer: GridTileBar(
          // backgroundColor: Colors.black26,
          //    leading: Text('\$'+product.price.toString()),
          leading: Consumer<Product>(
            builder: (ctx, v, _) => IconButton(
              icon: Icon(
                v.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Color(0xff222831),
              onPressed: () {
                v.toggleFavoriteStatus(authData.token, authData.uerId);
              },
            ),
          ),
          title: Text(
            '',
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title, 1,
                  product.imageUrl);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Color(0xff222831),
          ),
        ),
      ),
    );
  }
}
