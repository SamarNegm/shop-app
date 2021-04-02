import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/Favorits.dart';
import 'package:flutter_complete_guide/screens/OverView.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/profil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import './cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routName = '\overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  @override
  List<Object> _pages;
  int _selectedPageIndex = 0;
  void initState() {
    _pages = [
      OverView(),
      Favorits(),
      profile(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _selectPage(int index) {
      setState(() {
        _selectedPageIndex = index;
        if (_selectedPageIndex == 1) {
          _showOnlyFavorites = true;
        } else {
          _showOnlyFavorites = false;
        }
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(40.0)),
          child: AppBar(
            backgroundColor: HexColor('#f1d2c5'),
            actions: <Widget>[
              Consumer<Cart>(
                builder: (_, cart, ch) => Badge(
                  child: ch,
                  value: cart.itemCount.toString(),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: _pages[_selectedPageIndex],
      floatingActionButton: FloatingActionButton(
        elevation: 4.0,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//      Container(
//          color: HexColor('#f1d2c5'),
//          child: Container(
//              child: ClipRRect(
//            borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
//               child: Container(
//                color: Colors.white,
//                child: _isLoading
//                  ? Center(child: CircularProgressIndicator())
//                  : ProductsGrid(_showOnlyFavorites,'Discover'),
//            ),
//          ))),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: HexColor('#f1d2c5'),
          selectedItemColor: HexColor('#222831'),
          currentIndex: _selectedPageIndex,
          // type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              backgroundColor: HexColor('#f1d2c5'),
              icon: _selectedPageIndex == 0
                  ? Icon(Icons.home)
                  : Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: HexColor('#f1d2c5'),
              icon: _selectedPageIndex == 1
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              backgroundColor: HexColor('#f1d2c5'),
              icon: _selectedPageIndex == 2
                  ? Icon(Icons.person)
                  : Icon(Icons.person_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
