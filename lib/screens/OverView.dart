import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/widgets/products_grid.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class OverView extends StatefulWidget {
  @override
  _OverViewState createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  var _isInit = true;
  var _isLoading = false;
  bool _dispose=false;

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
        if(_dispose)return;
        await Provider.of<Products>(context).fetchAndSetProducts();
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        print(error);
        throw error;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dispose=true;
    Navigator.of(context).pushNamed(ProductsOverviewScreen.routName);
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
                  : ProductsGrid(false, 'Discover'),
            ),
          ))),
    );
  }
}
