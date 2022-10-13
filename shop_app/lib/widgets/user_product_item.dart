import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  // final Function deleteHandler;

  const UserProductItem(
    this.title,
    this.imageUrl,
    this.id,
  );

  @override
  Widget build(BuildContext context) {
    final scaffoldMessange = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id);
            },
            icon: Icon(Icons.edit),
            color: Theme.of(context).colorScheme.primary,
          ),
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (error) {
                scaffoldMessange.showSnackBar(SnackBar(
                    content: Text(
                  "Deleting failed!",
                  textAlign: TextAlign.center,
                )));
              }
            },
            icon: Icon(Icons.delete),
            color: Theme.of(context).colorScheme.secondary,
          )
        ]),
      ),
    );
  }
}
