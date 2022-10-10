import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, index) => Column(
                  children: [
                    UserProductItem(productsData.items[index].title,
                        productsData.items[index].imageUrl),
                    Divider(),
                  ],
                )),
        padding: EdgeInsets.all(8),
      ),
    );
  }
}
