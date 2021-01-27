import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:flutter_complete_guide/widgets/user_product_item2.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  var _isInit = true;

  var _isLoading = false;

  bool _dispose = false;

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
        await Provider.of<Products>(context).fetchAndSetProducts(true, '');
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
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(40.0)),
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
                                          childAspectRatio: 1.8,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                            (BuildContext ctx, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0, bottom: 10),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 60,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('Samar Negm'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }, childCount: 1),
                                      ),
                                      SliverGrid(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 1.5 / 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                            (BuildContext ctx, int i) {
                                          print(
                                              productsData[i].title + ' title');

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
                    )))));
  }
}
