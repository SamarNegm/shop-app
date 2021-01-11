import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final devicesize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(devicesize.height * .8),
                bottomRight: Radius.circular(devicesize.height * .8)),
            child: SizedBox(
              height: devicesize.height * .15,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 40,
                        child:
                            Image(image: AssetImage('assets/images/bag.png'))),
                    Text(
                      '  My bag',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(
            height: devicesize.height * .6,
            child: Container(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].url,
                ),
              ),
            ),
          ),
          SizedBox(
            height: devicesize.height * .25,
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total Amount',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.grey, fontSize: 25),
                    ),
                    SizedBox(
                        height: 50,
                        width: devicesize.width,
                        child: OrderButton(cart: cart))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return widget.cart.totalAmount <= 0
        ? Spacer()
        : RaisedButton(
            child: _isLoading
                ? CircularProgressIndicator()
                : Text(
                    'ORDER NOW',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
            onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<Orders>(context, listen: false).addOrder(
                      widget.cart.items.values.toList(),
                      widget.cart.totalAmount,
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    widget.cart.clear();
                  },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textColor: Theme.of(context).primaryColor,
            color: Theme.of(context).primaryColor,
          );
  }
}
