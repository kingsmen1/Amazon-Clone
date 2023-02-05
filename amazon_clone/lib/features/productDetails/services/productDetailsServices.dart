import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/productModel.dart';
import 'package:amazon_clone/models/userModel.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductDetailsServices {
  Future<void> rateProduct(
    BuildContext context, {
    required Product product,
    required double rating,
  }) async {
    final UserProvider userProvider = context.read<UserProvider>();
    try {
      http.Response res = await http.post(
          Uri.parse('$uri/api/v1/products/rating/${product.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          },
          body: jsonEncode({'rating': rating}));
      debugPrint("${res.statusCode}");
      httpErrorHandler(response: res, context: context, onSuccess: () {});
    } catch (e) {
      showSnackbar(context, e.toString());
      rethrow;
    }
  }

  Future<void> addToCart(BuildContext context, String prodId,
      {bool isAdding = false}) async {
    final UserProvider userProvider = context.read<UserProvider>();
    try {
      http.Response res = await http.post(
          Uri.parse('$uri/api/v1/products/add-to-cart/$prodId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });

      debugPrint('${res.statusCode}');
      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            User user =
                userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
            userProvider.setUserFromModel(user);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            showSnackbar(context,
                isAdding ? 'Product Added to Cart!' : 'Quanitity Increased');
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
