import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/productModel.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchServices {
  Future<List<Product>> fetchSearchedProduct(BuildContext context,
      {required String searchQuery}) async {
    UserProvider userProvider = context.read<UserProvider>();
    List<Product> products = [];
    try {
      http.Response res = await http.get(
          Uri.parse('$uri/api/v1/products/search/$searchQuery'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });

      debugPrint('${res.statusCode}');
      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            List.generate(jsonDecode(res.body).length, (index) {
              products.add(
                  Product.fromJson(jsonEncode(jsonDecode(res.body)[index])));
            });
          });
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar(context, e.toString());
    }
    return products;
  }
}
