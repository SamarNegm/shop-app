import 'package:flutter/material.dart';

class CartItemModel {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String url;

  CartItemModel({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.url,
  });
}
