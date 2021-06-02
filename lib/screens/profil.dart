import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/Users.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/widgets/user_product_item2.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class profile extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  var _isInit = true;

  var _isLoading = false;

  bool _dispose = false;
  String name = '';
  String profilePicUrl = '';

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
        if (_dispose) return;
        await Provider.of<Products>(context, listen: false)
            .fetchAndSetProducts(true, '');
        await Provider.of<Users>(context, listen: false).fetchCurrentSetUsers();
        name = Provider.of<Users>(context, listen: false).myUser.name;
        profilePicUrl =
            Provider.of<Users>(context, listen: false).myUser.profilePicUrl;

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

  File _storedImage;
  final _picker = ImagePicker();
  String dropdownValue = 'spoons';

  Future getImage() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
      maxHeight: 200,
    );
    setState(() {
      if (pickedFile != null) {
        setState(() {
          _storedImage = File(pickedFile.path);

          Provider.of<Users>(context, listen: false).upDate(
              Provider.of<Users>(context, listen: false).myUser,
              Provider.of<Auth>(context, listen: false).uerId,
              Provider.of<Auth>(context, listen: false).token,
              _storedImage);
        });
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> refresh(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts(true);
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context).items;
    return Scaffold(
        body: Container(
      color: HexColor('#f1d2c5'),
      child: Container(
          child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
              child: Container(
                color: Colors.white,
                child: FutureBuilder(
                    future: refresh(context),
                    builder: (ctx, snapshot) => _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () => refresh(context),
                            child: CustomScrollView(
                              slivers: [
                                SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0,
                                    childAspectRatio: 1.5,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext ctx, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10),
                                      child: Column(
                                        children: [
                                          Consumer<Users>(
                                            builder: (ctx, myUser, _) =>
                                                CircleAvatar(
                                              radius: 60,
                                              child:
                                                  myUser.myUser.profilePicUrl ==
                                                          ''
                                                      ? Container()
                                                      : Container(
                                                          child: Image.network(
                                                              myUser.myUser
                                                                  .profilePicUrl),
                                                        ),
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                              onPressed: () {
                                                getImage();
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.black45,
                                              ),
                                              label: Text('Edit Profile Pic')),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Consumer<Users>(
                                              builder:
                                                  (context, value, child) =>
                                                      Text(name),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }, childCount: 1),
                                ),
                              SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext ctx, int i) {
                                      print(productsData[i].title +
                                          ' ********title');

                                      return Padding(
                                        padding: i % 2 == 1
                                            ? EdgeInsets.only(right: 12)
                                            : EdgeInsets.only(left: 12),
                                        child: userProductItem2(
                                          id: productsData[i].id,
                                          title: productsData[i].title,
                                          imageUrl:
                                              productsData[i].imageUrl,
                                        ),
                                      );
                                    }, childCount: productsData.length),
                                  ),

                              ],
                            ),
                          )),
              ))),
    ));
  }
}
