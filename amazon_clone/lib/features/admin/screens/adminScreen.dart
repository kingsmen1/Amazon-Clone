import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/analyticsScreen.dart';
import 'package:amazon_clone/features/admin/screens/ordersScreen.dart';
import 'package:amazon_clone/features/admin/screens/productsScreen.dart';
import 'package:amazon_clone/common/widgets/appbar.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;

  double _bottomBarWith = 42;

  double _bottomBarBorderWidth = 5;

  final List<Widget> _pages = const [
    ProductsScreen(),
    AnalyticsScreen(),
    OrdersScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _page,
            selectedItemColor: GlobalVariables.selectedNavBarColor,
            unselectedItemColor: GlobalVariables.unselectedNavBarColor,
            iconSize: 28,
            backgroundColor: GlobalVariables.backgroundColor,
            onTap: (value) {
              setState(() {
                _page = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Container(
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
                        badgeColor: Colors.white,
                        badgeContent: const Text('5'),
                        elevation: 0,
                        child: const Icon(Icons.home_outlined)),
                  ),
                  label: ''),
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
                        badgeContent: const Text('5'),
                        child: const Icon(Icons.analytics_outlined)),
                  ),
                  label: ''),
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
                        badgeContent: const Text('5'),
                        child: const Icon(Icons.all_inbox_outlined)),
                  ),
                  label: ''),
            ]),
        body: _pages[_page]);
  }
}
