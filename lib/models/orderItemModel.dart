import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/CartItemModel.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItemModel> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
