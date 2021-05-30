import 'package:flutter/material.dart';

class SplashScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height * .3,
              width: MediaQuery.of(context).size.height * .3,
              child: Container(
                  child: Image(image: AssetImage('assets/images/logo.png'))))),
    );
  }
}
