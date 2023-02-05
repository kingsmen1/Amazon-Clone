import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/userModel.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CartServices {
  Future<void> removeFromCart(BuildContext context, String id) async {
    final UserProvider userProvider = context.read<UserProvider>();
    try {
      http.Response res = await http.delete(
          Uri.parse("$uri/api/v1/products/remove-from-cart/$id"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            final User user =
                userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
            userProvider.setUserFromModel(user);
            if (ScaffoldMessenger.of(context).mounted) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            }

            showSnackbar(context, 'Item removed from Cart');
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
