import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/cart/screens/cartScreens.dart';
import 'package:amazon_clone/features/home/screens/homeScreen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/accounts/screens/accountScreen.dart';

class BottomBar extends StatefulWidget {
  static const routeName = '/actual-home';
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final double _bottomBarWith = 42;
  int _page = 0;
  final double _bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen()
  ];

  //BottomBar onTap will automatically pass page index.
  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int cartLength = context.watch<UserProvider>().user.cart.length;
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        iconSize: 28,
        backgroundColor: GlobalVariables.backgroundColor,
        //^onTap will automatically gives us the current page index.
        onTap: updatePage,
        items: [
          //~BottomNavigationBarItem revise
          BottomNavigationBarItem(
              icon: Container(
                width: _bottomBarWith,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: _page == 0
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                        width: _bottomBarBorderWidth),
                  ),
                ),
                child: Badge(
                    elevation: 0,
                    badgeColor: Colors.white,
                    badgeContent: const Text('2'),
                    child: const Icon(Icons.home_outlined)),
              ),
              label: ''),
          //Account
          BottomNavigationBarItem(
              icon: Container(
                width: _bottomBarWith,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: _page == 1
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                        width: _bottomBarBorderWidth),
                  ),
                ),
                child: Badge(
                    elevation: 0,
                    badgeColor: Colors.white,
                    badgeContent: const Text('1'),
                    child: const Icon(Icons.person_outline_outlined)),
              ),
              label: ''),
          //Cart
          BottomNavigationBarItem(
              icon: Container(
                width: _bottomBarWith,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: _page == 2
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                        width: _bottomBarBorderWidth),
                  ),
                ),
                child: Badge(
                    elevation: 0,
                    badgeColor: Colors.white,
                    badgeContent: Text(
                      cartLength.toString(),
                    ),
                    child: const Icon(Icons.shopping_cart_outlined)),
              ),
              label: ''),
        ],
      ),
    );
  }
}
