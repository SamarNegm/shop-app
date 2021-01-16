import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/Favorits.dart';
import 'package:flutter_complete_guide/screens/OverView.dart';
import 'package:flutter_complete_guide/screens/profil.dart';
import 'package:hexcolor/hexcolor.dart';

class bottomNavigationBar extends StatefulWidget {
  BuildContext context;
  int cur;

  bottomNavigationBar(this.context, this.cur);
  @override
  _bottomNavigationBarState createState() =>
      _bottomNavigationBarState(context, cur);
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  BuildContext context;
  int c;
  _bottomNavigationBarState(this.context, this.c);
  get getc {
    return c;
  }

  var _showOnlyFavorites = false;
  @override
  List<Object> _pages;

  void initState() {
    _pages = [
      OverView(),
      Favorits(),
      profile(),
    ];
    super.initState();
  }

  int _selectedPageIndex;
  @override
  Widget build(context) {
    _selectedPageIndex = getc;
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

    return BottomNavigationBar(
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
    );
  }
}
