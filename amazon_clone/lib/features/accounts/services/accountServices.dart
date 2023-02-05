import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/models/orderModel.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fetchOrders(BuildContext context) async {
    List<Order> orders = [];
    final UserProvider userProvider = context.read<UserProvider>();
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/v1/user/order'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      debugPrint('${res.statusCode}');
      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            //^NOTE: always jsonDecode for performing action's such as indexing find length etc.;
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              final Order order =
                  Order.fromJson(jsonEncode(jsonDecode(res.body)[i]));
              orders.add(order);
            }
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return orders;
  }

  Future<void> logout(BuildContext context) async {
    print('playedc');
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString('x-auth-token', '');
    //~pushNamedAndRemoveUntil will remove all the previous routes until the given route is pushed
    //~read docs for full information.
    //ignore:, use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
      context,
      AuthScreen.routeName,
      (route) => false,
    );
  }
}
