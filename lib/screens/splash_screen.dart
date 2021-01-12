import 'package:flutter/material.dart';

class SplashScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: SizedBox(
              height: 300,
              width: 300,
              child: Image(image: AssetImage('assets/images/logo.png')))),
    );
  }
}
