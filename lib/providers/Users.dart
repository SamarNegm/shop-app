import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/users.dart';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {
  users _users;
  String token;
  String userId;

  Users(this.token, this._users, this.userId);

  users get usres {
    return _users;
  }

  Future<void> fetchCurrentSetUsers() async {
    print('**********1');
    print('**********1' + userId + ' ' + token);
    final url =
        'https://shop-app-8948a-default-rtdb.firebaseio.com/myUsers/$userId/$userId.json?auth=$token';
    final uri = Uri.parse(url);
    print('**********1');
    try {
      final response = await http.get(uri);
      print('**********2');
      final chatchedData = json.decode(response.body);
      print('**********3 chatchedData is ' + chatchedData.toString());
      if (chatchedData == null) {
        print('**********4');
        _users = null;
        notifyListeners();
        return null;
      }
      users loadedUser = null;
      print('**********5');
      chatchedData.forEach((userId, user) {
        loadedUser = users(name: user['name'], email: user['email']);
        print(user['name'] + user['email'] + '  data');
      });
      _users = loadedUser;
      print('Cuttent user is ' + loadedUser.name);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addUser(users user, id, token) async {
    print('adding new user' + user.name + '  ' + user.email);
    print('adding new user' + userId.toString() + '  ' + token.toString());
    final url =
        'https://shop-app-8948a-default-rtdb.firebaseio.com/myUsers/$id/$id.json?auth=$token';
    final uri = Uri.parse(url);
    try {
      final response = await http.post(
        uri,
        body: json.encode({
          'name': user.name,
          'email': user.email,
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
    _users = users(
      email: user.email,
      name: user.name,
    );
    notifyListeners();
  }
}
