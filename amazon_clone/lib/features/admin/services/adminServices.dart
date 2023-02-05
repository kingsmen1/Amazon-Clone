import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/models/salesModel.dart';
import 'package:amazon_clone/models/orderModel.dart';
import 'package:amazon_clone/models/productModel.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  Future<void> sellProducts(
    BuildContext context, {
    required String name,
    required String description,
    required String category,
    required double price,
    required double quantity,
    required List<File> images,
  }) async {
    final UserProvider userProvider = context.read<UserProvider>();
    try {
      //*Storing and getting url's of product images using Cloudinary.
      //~Cloudinary package used for storing media files as mongodb free clustor give 512mb only.
      final cloudinary = CloudinaryPublic('ds5mx2ozv', 'ecsau3qn');
      List<String> imageUrl = [];
      for (File image in images) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: name),
        );
        imageUrl.add(res.secureUrl);
      }

      //*Creating product model .
      final Product product = Product(
          name: name,
          description: description,
          quantity: quantity,
          images: imageUrl,
          category: category,
          price: price);
      //*Calling our api to upload product on database.
      http.Response res =
          await http.post(Uri.parse('$uri/api/v1/admin/product'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: product.toJson());

      // debugPrint('${res.statusCode} ${res.body}');

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackbar(context, "Product Added Successfully!");
            Navigator.pop(context, product);
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<List<Product>> fetchProducts(BuildContext context) async {
    final UserProvider userProvider = context.read<UserProvider>();
    List<Product> products = [];
    try {
      http.Response res = await http.get(Uri.parse('$uri/api/v1/admin/product'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });
      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            List.generate(jsonDecode(res.body).length, (index) {
              products.add(
                  //^CAPTION: first decode whole body then select by index.
                  Product.fromJson(jsonEncode(jsonDecode(res.body)[index])));
            });
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return products;
  }

  Future<void> deleteProduct(BuildContext context, {required String id}) async {
    final UserProvider userProvider = context.read<UserProvider>();
    try {
      http.Response res = await http.delete(
          Uri.parse('$uri/api/v1/admin/product/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            showSnackbar(context, 'Product deleted Succesfully');
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<List<Order>> fetchOrders(BuildContext context) async {
    List<Order> orders = [];
    final UserProvider userProvider = context.read<UserProvider>();
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/v1/admin/orders'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      debugPrint('${res.statusCode}');
      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            orders = List.generate(jsonDecode(res.body).length, (index) {
              //^just for taking single items by index we are jsonDecoding.
              return Order.fromJson(jsonEncode(jsonDecode(res.body)[index]));
            });
            print(orders.length);
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return orders;
  }

  Future<int?> updateOrderStatus(BuildContext context,
      {required String orderId, required int status}) async {
    int? statuss;
    final UserProvider userProvider = context.read<UserProvider>();
    try {
      http.Response res =
          await http.patch(Uri.parse('$uri/api/v1/admin/orders/$orderId'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: jsonEncode({'status': status}));

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            statuss = jsonDecode(res.body)['status'];

            showSnackbar(context, 'Status Updated');
          });
    } catch (e) {
      showSnackbar(context, e.toString());
      rethrow;
    }
    return statuss;
  }

  Future<Map<String, dynamic>> getAnalytics(
    BuildContext context,
  ) async {
    List<Sales> sales = [];
    int totalEarnings = 0;
    final UserProvider userProvider = context.read<UserProvider>();
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/v1/admin/analytics'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
      );
      debugPrint('${res.statusCode}');
      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            var response = jsonDecode(res.body);
            totalEarnings = response['totalEarnings'];
            sales = [
              Sales('Essentials', response['essentialsEarning']),
              Sales('Mobile', response['mobileEarning']),
              Sales('Appliances', response['appliancesEarning']),
              Sales('Books', response['booksEarning']),
              Sales('Fashion', response['fashionEarning']),
            ];
          });
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar(context, e.toString());
      rethrow;
    }
    return {'sales': sales, 'totalEarnings': totalEarnings};
  }
}
