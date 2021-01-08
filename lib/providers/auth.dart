import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
class Auth with ChangeNotifier
{
  String _token;
//  DateTime _expiryDate;
  String _userId;
  Timer _autTimer;
  String get uerId{
    return _userId;
  }
  bool get isAuth
  {
    print('hooooooooooooooooooooooo');
    if(token==null)
      return false;
    print('hoooooooooooooooooooooootrue');
    return true;
  }
  String get token {
    if (
        _token != null) {
      return _token;
    }
    return null;
  }
  Future<void>authentication(String email,String password,String Url) async
  {
    final url=Url;
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      //_expiryDate = DateTime.now().add(
//        Duration(
//          seconds: int.parse(
//            responseData['expiresIn'],
//          ),
//        ),
   //   );
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
     final userData= json.encode({
        'token':_token,
       'userId':_userId,
     //  'expiryDate':_expiryDate
      });
      prefs.setString('userData', userData);
    }
    catch(error)
    {
      throw(error);

    }

  }
  Future<bool>tryAutoLogin() async
  {
    final prefs =await SharedPreferences.getInstance();
    if(prefs.containsKey('userData'))
      {
        final data=json.decode(prefs.getString('userData')) as Map<String,Object>;
//        final exExpiryDate=DateTime.parse(data['expiryDate']);
//        if(exExpiryDate.isBefore(DateTime.now()))
//          {
//            return false;
//          }
//        _expiryDate=exExpiryDate;
        final exUserId=data['userId'];
        final exToken=data['token'];
        _userId=exUserId;
        _token=exToken;
        notifyListeners();
        return true;





      }
    else
      return false;
  }
Future<void>signup(String email,String password) async
{

  const url='https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDyHRnY7EodZtDnI5Dd3squv0a2XoT9M-E';
 return authentication(email, password, url);
}

  Future<void>signin(String email,String password) async
  {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDyHRnY7EodZtDnI5Dd3squv0a2XoT9M-E';
   return authentication(email, password, url);
  }
  Future<void> logout()
  async {
    print('lohhing out..........');
    _userId =null;
    _token=null;
    //_expiryDate=null;
    if(_autTimer!=null)
      _autTimer.cancel();
    _autTimer=null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }
  void autoLogout()
  {
//    if(_autTimer!=null)
//      _autTimer.cancel();
//    var time=_expiryDate.difference(DateTime.now()).inSeconds;
//    Timer(Duration(seconds: time),logout);

  }
}