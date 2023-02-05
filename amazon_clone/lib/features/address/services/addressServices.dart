import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/productModel.dart';
import 'package:amazon_clone/models/userModel.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressServices {
  Future<void> addAddress(
    BuildContext context, {
    required String address,
  }) async {
    final UserProvider userProvider = context.read<UserProvider>();
    try {
      //*Calling our api to upload product on database.
      http.Response res =
          await http.post(Uri.parse('$uri/api/v1/user/add-address'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: jsonEncode({'address': address}));

      // debugPrint('${res.statusCode} ${res.body}');

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            final User user = userProvider.user
                .copyWith(address: jsonDecode(res.body)['address']);
            userProvider.setUserFromModel(user);
            print(jsonDecode(res.body)['address']);
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<void> placeOrder(BuildContext context,
      {required String address, required double totalSum}) async {
    final UserProvider userProvider = context.read<UserProvider>();
    try {
      //*Calling our api to upload product on database.
      http.Response res = await http.post(Uri.parse('$uri/api/v1/user/order'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
            'address': address,
            'totalPrice': totalSum
          }));

      debugPrint('${res.statusCode} ${res.body}');

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackbar(context, 'Your Order has been Placed!');
            final User user = userProvider.user.copyWith(cart: []);
            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
