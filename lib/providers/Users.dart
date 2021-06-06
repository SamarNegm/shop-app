import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/users.dart';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {
  users _users;
  String token;
  String userId;

  Users(this.token, this._users, this.userId);
  users get myUser {
    return _users;
  }

  Future<void> fetchCurrentSetUsers() async {
    final url =
        'https://shop-app-8948a-default-rtdb.firebaseio.com/myUsers/$userId.json?auth=$token';
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri);
      final chatchedData = json.decode(response.body);
      if (chatchedData == null) {
        _users = null;
        notifyListeners();
        return null;
      }
      users loadedUser = null;

      // chatchedData.forEach((uId, user) {
      //   print(user.toString() + '<<');
      //   loadedUser = users(
      //       name: user['name'],
      //       email: user['email'],
      //       profilePicUrl: user['profilePicUrl'],
      //       id: user['id']);
      // });
      loadedUser = users(
          name: chatchedData['name'],
          email: chatchedData['email'],
          profilePicUrl: chatchedData['profilePicUrl'],
          id: chatchedData['id']);
      _users = loadedUser;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addUser(users user, id, token) async {
    var response;
    print('adding new user' + user.name + '  ' + user.email);
    print('adding new user' + userId.toString() + '  ' + token.toString());
    final url =
        'https://shop-app-8948a-default-rtdb.firebaseio.com/myUsers/$id.json?auth=$token';
    final uri = Uri.parse(url);
    try {
      response = await http.put(
        uri,
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'profilePicUrl': user.profilePicUrl,
          'id': ''
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
    _users = users(
        email: user.email,
        name: user.name,
        profilePicUrl: user.profilePicUrl,
        id: json.decode(response.body)['name']);
    notifyListeners();
  }

  Future<void> upDate(File image) async {
    final url =
        'https://shop-app-8948a-default-rtdb.firebaseio.com/myUsers/$userId.json?auth=$token';
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    print('ok11');
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('userProfileimag')
        .child(userId + '.jpg');
    await ref.putFile(image);
    print('ok3');
    final imageUrl = await ref.getDownloadURL();
    print('ok4 ' + imageUrl);
    final uri = Uri.parse(url);
    try {
      final response = await http.put(
        uri,
        body: json.encode({
          'name': _users.name,
          'email': _users.email,
          'profilePicUrl': imageUrl,
          'id': _users.id
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
    _users = users(
        email: _users.email,
        name: _users.name,
        profilePicUrl: imageUrl,
        id: _users.id);
    notifyListeners();
  }
}
