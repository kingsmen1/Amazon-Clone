import 'package:amazon_clone/models/userModel.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubTotal extends StatelessWidget {
  const CartSubTotal({super.key});

  @override
  Widget build(BuildContext context) {
    //calculating subtotal.
    final User user = context.watch<UserProvider>().user;
    int subTotal = 0;
    user.cart.map((e) {
      subTotal += e['quantity'] * e['product']['price'] as int;
    }).toList();
    return Container(
      padding: const EdgeInsets.all(10),
      child: RichText(
        text: TextSpan(
            text: 'Subtotal ',
            style: const TextStyle(fontSize: 20, color: Colors.black),
            children: [
              TextSpan(
                  text: '\$${subTotal.toString()}',
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ]),
      ),
    );
  }
}
