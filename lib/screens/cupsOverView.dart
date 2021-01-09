import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/widgets/products_grid.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class CupsOverView extends StatefulWidget {
  static const routeName = '/cupsOcerView';
  @override
  _CupsOverViewState createState() => _CupsOverViewState();
}

class _CupsOverViewState extends State<CupsOverView> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Products>(context).fetchAndSetProducts(false, 'cups');
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        throw error;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Navigator.of(context).pushReplacementNamed('/');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: HexColor('#f1d2c5'),
          child: Container(
              child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
            child: Container(
              color: Colors.white,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ProductsGrid(false, 'cups'),
            ),
          ))),
    );
  }
}
