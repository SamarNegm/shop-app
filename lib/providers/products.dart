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

  Products(this.autToken,this._items,this.userId);

  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    print(_items.length);
    if(items.length>0)
    return _items.firstWhere((prod) => prod.id == id);
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
  Future<void> fetchAndSetProducts([bool filterByUser=false,String type='']) async
  {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final typeString= type!=''? 'orderBy="type"&equalTo="$type"' :'';

    String url = 'https://shop-app-8948a-default-rtdb.firebaseio.com/products.json?auth=$autToken&$filterString&$typeString';

    print('url '+url);
    try {
      final response = await http.get(url);
      print(response.body.toString());
      final chatchedData = json.decode(response.body) as Map<String, dynamic>;
      if (chatchedData['error'] != null) {
        throw HttpException(chatchedData['error']['message']);
      }
      if(chatchedData==null) {
        _items=[];
        notifyListeners();

        return;
      }
      final favRespons= await http.get('https://shop-app-8948a-default-rtdb.firebaseio.com/favoriteProducts/$userId.json?auth=$autToken');
      final chatchedfav = json.decode(favRespons.body);
      final List<Product>loadedProducts = [];

      chatchedData.forEach((prdId, product) {
      // print(prdId+'         '+ chatchedfav[prdId].toString()+'    '+(chatchedfav==null?false: chatchedfav[prdId]??false).toString());
        loadedProducts.add(Product(
          id: prdId,
          description: product['description'],
          price: product['price'],
          imageUrl: product['imageUrl'],
          title: product['title'],
          type: product['type'],
          isFavorite: chatchedfav==null?false: chatchedfav[prdId]??false,
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    }
    catch (error) {
      throw(error);
    }
  }

  Future<void> addProduct(Product product,File image) async {
    final url = 'https://shop-app-8948a-default-rtdb.firebaseio.com/products.json?auth=$autToken';
    try {
      final response = await http.post(
          url,
          body: json.encode(
              {
                'title': product.title,
                'description': product.description,
                'price': product.price,
                'type':product.type,
                'imageUrl': '',
                'creatorId':userId,

              }
          ));

      print('ok1');
      print(product.id);
      firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
      print('ok11');
      final ref= firebase_storage.FirebaseStorage.instance.ref().child('userimage').child(json.decode(response.body)['name']+'.jpg');
      print('ok2  '+autToken);
      await ref.putFile(image).onComplete;
      print('ok3');
      final imageUrl=  await ref.getDownloadURL();
      print('ok4 '+imageUrl);
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: imageUrl,
          type: product.type,
          id: json.decode(response.body)['name']
      );
      _items.add(newProduct);
      notifyListeners();
      print(newProduct.imageUrl+'  a7a::::');
      updateProduct(json.decode(response.body)['name'], newProduct);
      // _items.insert(0, newProduct); // at the start of the list

    }
    catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    print(newProduct.imageUrl+'  a7a222222222222');
    if (prodIndex >= 0) {
      final url = 'https://shop-app-8948a-default-rtdb.firebaseio.com/products/$id.json?auth=$autToken';
      await http.patch(url, body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
        'type':newProduct.type,

      }));
      _items[prodIndex]=newProduct;
      print(newProduct.title + '<<<<<<<<<<<<<<<<<<<<<<<<<');

      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    http.Response response;
    final url = 'https://shop-app-8948a-default-rtdb.firebaseio.com/products/$id.json?auth=$autToken';
    int x=0;

    response= await http.delete(url);
    if(response.statusCode>=400)
      {
        throw ('error');
      }
    else
      {
        _items.removeWhere((prod) => prod.id == id);
        notifyListeners();
      }




  }
  Future<void>refresh(BuildContext context) async
  { try {
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
  }
  catch(error)
  {
    print(error.toString());
    throw(error);
  }
  }
}
