import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/address/screens/addressScreen.dart';
import 'package:amazon_clone/features/cart/widgets/cartProduct.dart';
import 'package:amazon_clone/features/cart/widgets/cartSubtotal.dart';
import 'package:amazon_clone/features/home/widgets/addressBox.dart';
import 'package:amazon_clone/features/search/screens/searchScreen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _searchQueryController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchQueryController.dispose();
  }

  void navigateToSearchScreen(String? searchQuery) {
    _searchQueryController.text = '';
    Navigator.of(context)
        .pushNamed(SearchScreen.routeName, arguments: searchQuery);
  }

  void navigateToAddress(int sum) {
    Navigator.pushNamed(context, AddressScreen.routeName,
        arguments: sum.toString());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int subTotal = 0;
    user.cart.map((e) {
      subTotal += e['quantity'] * e['product']['price'] as int;
    }).toList();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: GlobalVariables.appBarGradient)),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 15),
                    //~Material can be used to give elevation.
                    child: Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        controller: _searchQueryController,
                        onFieldSubmitted: navigateToSearchScreen,
                        decoration: InputDecoration(
                            prefixIcon: InkWell(
                              onTap: () {},
                              child: const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 23,
                                  )),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(top: 10),
                            //^Creates a rounded rectangle outline border for an [InputDecorator].
                            //^If the [borderSide] parameter is [BorderSide.none], it will not draw a border. However, it will still define a shape (which you can see if [InputDecoration.filled] is true).
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 1)),
                            hintText: 'Search Amazon.in',
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17)),
                      ),
                    ),
                  )),
                  Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 42,
                    child: const Icon(
                      Icons.mic,
                      color: Colors.black,
                      size: 25,
                    ),
                  )
                ]),
          )),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AddressBox(),
          const CartSubTotal(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: 'Proceed to Buy (${user.cart.length} items)',
              onTap: () => navigateToAddress(subTotal),
              color: Colors.yellow[600],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            color: Colors.black.withOpacity(0.08),
            height: 1,
          ),
          const SizedBox(
            height: 5,
          ),
          ListView.builder(
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(index: index);
              })
        ],
      )),
    );
  }
}
