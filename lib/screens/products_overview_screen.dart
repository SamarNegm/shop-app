import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/Favorits.dart';
import 'package:flutter_complete_guide/screens/OverView.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../providers/products.dart';

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



    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    void _selectPage(int index) {
      setState(() {
        _selectedPageIndex = index;
        if(_selectedPageIndex==1)
          {
            _showOnlyFavorites = true;

          }
        else
          {
            _showOnlyFavorites=false;
          }
      });
    }


    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(40.0)),
          child: AppBar(
            title:  Text('Discover',style: TextStyle(fontSize: 32,fontFamily: 'NIRVANA'),),
            backgroundColor: HexColor('#f1d2c5'),
            actions: <Widget>[
              PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.Favorites) {
                      _showOnlyFavorites = true;
                    } else {
                      _showOnlyFavorites = false;
                    }
                  });
                },
                icon: Icon(
                  Icons.more_vert,
                ),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Text('Only Favorites'),
                    value: FilterOptions.Favorites,
                  ),
                  PopupMenuItem(
                    child: Text('Show All'),
                    value: FilterOptions.All,
                  ),
                ],
              ),
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
      body:_pages[_selectedPageIndex],
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
      bottomNavigationBar:BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: HexColor('#f1d2c5'),
        unselectedItemColor: Colors.white,
        selectedItemColor:HexColor('#222831'),
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: HexColor('#f1d2c5'),
             icon: _selectedPageIndex==0? Icon(Icons.home): Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: HexColor('#f1d2c5'),
            icon: _selectedPageIndex==1?Icon(Icons.favorite):Icon(Icons.favorite_border),
            label:'Favorites',
          ),
        ],
      ),
    );
  }
}
