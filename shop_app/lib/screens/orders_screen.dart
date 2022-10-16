import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "orders";

//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   //var _isLoading = false;
//   @override
//   void initState() {
//     // Future.delayed(Duration.zero).then((_) async {
//     //   setState(() {
//     //     _isLoading = true;
//     //   });
//     //   await Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
//     //   setState(() {
//     //     _isLoading = false;
//     //   });
//     // });
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text("Do error handler staff here"),
                );
              } else {
                return Consumer<Orders>(
                    builder: (context, ordersData, child) => ListView.builder(
                        itemCount: ordersData.orders.length,
                        itemBuilder: (context, index) =>
                            OrderItem(ordersData.orders[index])));
              }
            }
          }),
        ));
  }
}
