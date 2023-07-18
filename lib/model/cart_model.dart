import 'package:flutter/material.dart';
import '../components/grocery_item_tile.dart';

class CartModel extends ChangeNotifier {
  // list of items on sale
  final List _shopItems = const [
    // [ itemName, itemPrice, imagePath, color ]
    ["Groceries", "4.00", "lib/images/avocado.png", Colors.green],
    ["Electronics", "122.50", "lib/images/computer.png", Colors.blue],
    //["Chicken", "12.80", "lib/images/chicken.png", Colors.brown],
    //["Water", "1.00", "lib/images/water.png", Colors.blue],
  ];

  
  // list of cart items
  List _cartItems = [];

  get cartItems => _cartItems;

  get shopItems => _shopItems;

  // add item to cart
  void addItemToCart(int index, String scannedPrice) {
    //_cartItems.add(_shopItems[index]);
    _cartItems.add([shopItems[index][0], scannedPrice, shopItems[index][2], shopItems[index][3]]);
    notifyListeners();
  }

  // remove item from cart
  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // calculate total price
  String calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalPrice += double.parse(cartItems[i][1]);
    }
    return totalPrice.toStringAsFixed(2);
  }
}