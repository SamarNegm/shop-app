import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void>refresh(BuildContext context) async
  { try {
   await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
  }
  catch(error)
    {
      print(error.toString());
      throw(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('rebilding....');
   // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future:refresh(context),
        builder: (ctx, snapshot) => snapshot.connectionState==ConnectionState.waiting? Center(
          child: CircularProgressIndicator(),
        ) :
         RefreshIndicator(
          onRefresh: ()=>refresh(context),

            child: Consumer<Products>(
              builder: (ctx, productsData, _) =>

              Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (_, i) => Column(
                        children: [
                          UserProductItem(
                            productsData.items[i].id,
                            productsData.items[i].title,
                            productsData.items[i].imageUrl,
                          ),
                          Divider(),
                        ],
                      ),
                ),
              ),
            ),

        ),
      ),
    );
  }
}
