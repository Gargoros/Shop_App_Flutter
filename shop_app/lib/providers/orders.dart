import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        Uri.https("myshopappdata-default-rtdb.firebaseio.com", "/orders.json");
    final timestamp = DateTime.now();

    try {
      final response = await http.post(url,
          body: json.encode({
            "amount": total,
            "products": cartProduct
                .map((cp) => {
                      "id": cp.id,
                      "title": cp.title,
                      "quantity": cp.quantity,
                      "price": cp.price,
                    })
                .toList(),
            "dateTime": timestamp.toIso8601String(),
          }));

      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)["name"],
              amount: total,
              products: cartProduct,
              dateTime: timestamp));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetOrder() async {
    final url = Uri.parse(
        "https://myshopappdata-default-rtdb.firebaseio.com/orders.json");
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrder = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrder.add(OrderItem(
          id: orderId,
          amount: orderData["amount"],
          products: (orderData["products"] as List<dynamic>)
              .map((item) => CartItem(
                  id: item["id"],
                  title: item["title"],
                  quantity: item["quantity"],
                  price: item["price"]))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ));
      });
      _orders = loadedOrder.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
