import 'package:amazon_clone/common/widgets/bottomBar.dart';
import 'package:amazon_clone/features/address/screens/addressScreen.dart';
import 'package:amazon_clone/features/admin/screens/addProducts.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/categoryDealScreen.dart';
import 'package:amazon_clone/features/home/screens/homeScreen.dart';
import 'package:amazon_clone/features/orderDetailScreen/screens/orderDetailScreen.dart';
import 'package:amazon_clone/features/productDetails/screens/productDetailsScreen.dart';
import 'package:amazon_clone/features/search/screens/searchScreen.dart';
import 'package:amazon_clone/models/orderModel.dart';
import 'package:amazon_clone/models/productModel.dart';
import 'package:flutter/material.dart';

//*This method is responsible for generating routes.
//RouteSettings will be useful in constructing a [Route].
Route<dynamic> generateRoute(RouteSettings routeSettings) {
  //~ switch case
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());
    case BottomBar.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const BottomBar());
    case AddProducts.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AddProducts());
    case CategoryDealsScreen.routeName:
      //~accessing and passing arguments to widgets.
      Map<String, dynamic> argumets =
          routeSettings.arguments! as Map<String, dynamic>;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => CategoryDealsScreen(
                category: argumets['category'],
              ));
    case SearchScreen.routeName:
      //~accessing and passing arguments to widgets.
      String searchQuery = routeSettings.arguments! as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => SearchScreen(
                searchQuery: searchQuery,
              ));
    case ProductDetailsScreen.routeName:
      Product product = routeSettings.arguments! as Product;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ProductDetailsScreen(
                product: product,
              ));
    case AddressScreen.routeName:
      String sum = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => AddressScreen(
                sum: sum,
              ));
    case OrderDetailScreen.routeName:
      Order order = routeSettings.arguments as Order;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => OrderDetailScreen(
                order: order,
              ));
    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const Scaffold(
                body: Center(
              child: Text('Screen does not exist'),
            ));
          });
  }
}
