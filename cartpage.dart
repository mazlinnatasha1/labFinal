import 'dart:convert';
import 'package:bookbytes/models/cart.dart';
import 'package:bookbytes/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookbytes/views/screens/myconfig.dart';
import 'billscreen.dart';

class CartPage extends StatefulWidget {
  final User user;

  const CartPage({super.key, required this.user});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> cartList = <Cart>[];
  double total = 0.0;
  int totalItems = 0;

  @override
  void initState() {
    super.initState();
    loadUserCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: cartList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Expanded(
                child: 
                ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        background: Container(
                          color: Colors.red,
                          child: Row(children: [
                            IconButton(
                                onPressed: () {
                                  deleteCartItemDialog(index);
                                },
                                icon: const Icon(Icons.delete)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.update),
                           ),
                          ]),
                        ),
                         onDismissed: (direction) {
                          setState(() {
                            cartList.removeAt(index);
                            updateTotal();
                          });
                         },
                        key: Key(cartList[index].bookId.toString()),
                        child: ListTile(
                            title: Text(cartList[index].bookTitle.toString()),
                            onTap: () async {},
                            subtitle: Text("RM ${cartList[index].bookPrice}"),
                            leading: const Icon(Icons.sell),
                            trailing:
                                Text("x ${cartList[index].cartQty} unit")),
                      );
                    }),
              ),
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TOTAL RM ${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => BillScreen(
                                          user: widget.user,
                                          totalprice: total,
                                        )));
                            loadUserCart();
                          },
                          child: const Text("Pay Now"))
                    ],
                  ))
            ]),
    );
  }

  void loadUserCart() {
    String userid = widget.user.userid.toString();
    http
        .get(
      Uri.parse(
          "${MyServerConfig.server}/bookbytes_v1/php/load_cart.php?userid=$userid"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        // log(response.body);
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          cartList.clear();
          total = 0.0;
          data['data']['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));
            
            total = total +
                double.parse(v['book_price'] * int.parse(v['cart_qty']));
          });
          print(total);
          setState(() {});
        } else {
          Navigator.of(context).pop();
          //if no status failed
        }
      }
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      print("Timeout");
    });
  }
  void deleteCartItemDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Item"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel button
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Implement the logic to delete the item
                deleteCartItem(index);
                Navigator.of(context).pop(); // Delete button
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void deleteCartItem(int index) {
    // Implement the logic to delete the item, e.g., make an HTTP request
    // Here, you might want to send a request to your server to delete the cart item
  }
  void updateTotal() {
    // Recalculate the total and totalItems after any changes to cartList
    total = 0.0;
    totalItems = 0;
    cartList.forEach((cart) {
      total += double.parse(cart.bookPrice!) * int.parse(cart.cartQty!);
      totalItems += int.parse(cart.cartQty!);
    });
  }
}
