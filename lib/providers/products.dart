import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './product.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  var autToken;
  String userId;

  Products(this.autToken, this._items, this.userId);

  List<Product> _items = [];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items.reversed];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    print(items.length);
    if (items.length > 0) return _items.firstWhere((prod) => prod.id == id);
    return null;
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
  Future<void> fetchAndSetProducts(
      [bool filterByUser = false, String type = '']) async {
    _items = [];
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final typeString = type != '' ? 'orderBy="type"&equalTo="$type"' : '';

    String url =
        'https://shop-app-8948a-default-rtdb.firebaseio.com/products.json?auth=$autToken&$filterString&$typeString';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      print(response.body.toString());
      final chatchedData = json.decode(response.body) as Map<String, dynamic>;
      if (chatchedData['error'] != null) {
        throw HttpException(chatchedData['error']['message']);
      }
      if (chatchedData == null) {
        _items = [];
        notifyListeners();

        return;
      }
      final favRespons = await http.get(Uri.parse(
          'https://shop-app-8948a-default-rtdb.firebaseio.com/favoriteProducts/$userId.json?auth=$autToken'));
      final chatchedfav = json.decode(favRespons.body);
      final List<Product> loadedProducts = [];

      chatchedData.forEach((prdId, product) {
        // print(prdId+'         '+ chatchedfav[prdId].toString()+'    '+(chatchedfav==null?false: chatchedfav[prdId]??false).toString());
        loadedProducts.add(Product(
          id: prdId,
          description: product['description'],
          price: product['price'],
          imageUrl: product['imageUrl'],
          title: product['title'],
          type: product['type'],
          isFavorite: chatchedfav == null ? false : chatchedfav[prdId] ?? false,
        ));
      });

      _items = [...loadedProducts];
      print('len ' + _items.length.toString());
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product, File image) async {
    final url =
        'https://shop-app-8948a-default-rtdb.firebaseio.com/products.json?auth=$autToken';
    final uri = Uri.parse(url);
    try {
      final response = await http.post(uri,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'type': product.type,
            'imageUrl': '',
            'creatorId': userId,
          }));

      print('ok1');
      print(product.id);
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      print('ok11');
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('userimage')
          .child(json.decode(response.body)['name'] + '.jpg');
      print('ok2  ' + autToken);
      await ref.putFile(image);
      print('ok3');
      final imageUrl = await ref.getDownloadURL();
      print('ok4 ' + imageUrl);
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: imageUrl,
          type: product.type,
          id: json.decode(response.body)['name']);
      _items.add(newProduct);
      for (var item in _items) {
        print(item.title);
      }
      notifyListeners();
      updateProduct(json.decode(response.body)['name'], newProduct, _items);
      // _items.insert(0, newProduct); // at the start of the list

    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct, List items) async {
    final prodIndex = items.indexWhere((prod) => prod.id == id);
    print('prodIndex ' + prodIndex.toString() + '  ' + items.length.toString());
    if (prodIndex >= 0) {
      final url =
          'https://shop-app-8948a-default-rtdb.firebaseio.com/products/$id.json?auth=$autToken';
      final uri = Uri.parse(url);
      await http.patch(uri,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'type': newProduct.type,
          }));
      items[prodIndex] = newProduct;
      _items = [...items];
      print(newProduct.title + '<<<<<<<<<<<<<<<<<<<<<<<<<');

      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    http.Response response;
    final url =
        'https://shop-app-8948a-default-rtdb.firebaseio.com/products/$id.json?auth=$autToken';
    final uri = Uri.parse(url);
    int x = 0;

    response = await http.delete(uri);
    if (response.statusCode >= 400) {
      throw ('error');
    } else {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }

  Future<void> refresh(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }
}
