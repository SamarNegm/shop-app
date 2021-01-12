import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String token;
  String userId;
  Orders(this.token, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shop-app-8948a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    try {
      final response = await http.get(url);
      final chatchedData = json.decode(response.body) as Map<String, dynamic>;
      if (chatchedData == null) {
        _orders = [];
        notifyListeners();
        return;
      }
      final List<OrderItem> loadedOrders = [];
      chatchedData.forEach((ordId, order) {
        loadedOrders.add(OrderItem(
          id: ordId,
          amount: order['amount'],
          dateTime: DateTime.parse(order['dateTime']),
          products: (order['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price'],
                    url: e['imageUrl']),
              )
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      ;
      print(loadedOrders.length);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://shop-app-8948a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    var date = DateTime.now();
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                  'imageUrl': cp.url
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
