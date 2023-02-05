import 'package:amazon_clone/features/cart/services/cartServices.dart';
import 'package:amazon_clone/features/productDetails/services/productDetailsServices.dart';
import 'package:amazon_clone/models/productModel.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({super.key, required this.index});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  final CartServices cartServices = CartServices();

  void increaseQuantity(String product, bool isAdding) {
    productDetailsServices.addToCart(context, product, isAdding: isAdding);
  }

  void decreaseQuantity(
    String product,
  ) {
    cartServices.removeFromCart(
      context,
      product,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromMap(productCart['product']);
    final int quantity = productCart['quantity'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.network(
                product.images[0],
                fit: BoxFit.contain,
                height: 135,
                width: 135,
              ),
            ),
            Column(
              children: [
                Container(
                  width: 235,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    product.name,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 2,
                  ),
                ),
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    '\$${product.price}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text('Eligible for FREE Shipping'),
                ),
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: const Text(
                    'In Stock',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            )
          ],
        ),
        //~Increment / Decrement box
        Container(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 1.5),
              borderRadius: BorderRadius.circular(5),
              color: Colors.black12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => decreaseQuantity(product.id!),
                  child: Container(
                      height: 32,
                      width: 35,
                      alignment: Alignment.center,
                      child: const Icon(Icons.remove, size: 18)),
                ),
                Container(
                    color: Colors.white,
                    height: 32,
                    width: 35,
                    alignment: Alignment.center,
                    child: Text(quantity.toString())),
                InkWell(
                  onTap: () => increaseQuantity(product.id!, quantity == 0),
                  child: Container(
                      height: 32,
                      width: 35,
                      alignment: Alignment.center,
                      child: const Icon(Icons.add, size: 18)),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
