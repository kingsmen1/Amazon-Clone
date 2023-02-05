import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/home/screens/homeScreen.dart';
import 'package:amazon_clone/models/userModel.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart ' as http;
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> signUpUser(BuildContext context,
      {required String email,
      required String name,
      required String password}) async {
    try {
      User user = User(
          address: '',
          id: '',
          name: name,
          email: email,
          password: password,
          token: '',
          type: '',
          cart: []);
      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackbar(
                context, "Account created! Login with same credentials");
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<void> signInUser(BuildContext context,
      {required String email, required String password}) async {
    try {
      User user = User(
          address: '',
          id: '',
          name: '',
          email: email,
          password: password,
          token: '',
          type: '',
          cart: []);
      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () async {
            //~SharedPreferences - storing our token locally.
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            // ignore: use_build_context_synchronously
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);
            // ignore: use_build_context_synchronously
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<void> getUserData(
    BuildContext context,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('x-auth-token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      http.Response res = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      bool isTokenValid = jsonDecode(res.body);

      if (isTokenValid == true) {
        http.Response userRes = await http.get(Uri.parse('$uri/'), headers: {
          'Content-Type': 'application/json; charsest=UTF=8',
          'x-auth-token': token
        });

        // ignore: use_build_context_synchronously
        UserProvider userProvider = context.read<UserProvider>();
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      showSnackbar(context, e.toString());
    }
  }
}
