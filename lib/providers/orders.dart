import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/CartItemModel.dart';
import 'package:flutter_complete_guide/models/orderItemModel.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

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
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
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
                (e) => CartItemModel(
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

  Future<void> addOrder(List<CartItemModel> cartProducts, double total) async {
    final url =
        'https://shop-app-8948a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    final uri = Uri.parse(url);
    var date = DateTime.now();
    final timestamp = DateTime.now();
    final response = await http.post(
      uri,
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
