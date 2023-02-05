import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/home/widgets/addressBox.dart';
import 'package:amazon_clone/features/home/widgets/carousal_images.dart';
import 'package:amazon_clone/features/home/widgets/dealOfDay.dart';
import 'package:amazon_clone/features/home/widgets/topCategories.dart';
import 'package:amazon_clone/features/search/screens/searchScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchQueryController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchQueryController.dispose();
  }

  void navigateToSearchScreen(String searchQuery) {
    _searchQueryController.text = '';
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    // final User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: GlobalVariables.appBarGradient)),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 15),
                    //~Material can be used to give elevation.
                    child: Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        controller: _searchQueryController,
                        onFieldSubmitted: navigateToSearchScreen,
                        decoration: InputDecoration(
                            prefixIcon: InkWell(
                              onTap: () {},
                              child: const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 23,
                                  )),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(top: 10),
                            //^Creates a rounded rectangle outline border for an [InputDecorator].
                            //^If the [borderSide] parameter is [BorderSide.none], it will not draw a border. However, it will still define a shape (which you can see if [InputDecoration.filled] is true).
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 1)),
                            hintText: 'Search Amazon.in',
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17)),
                      ),
                    ),
                  )),
                  Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 42,
                    child: const Icon(
                      Icons.mic,
                      color: Colors.black,
                      size: 25,
                    ),
                  )
                ]),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            AddressBox(),
            SizedBox(
              height: 10,
            ),
            TopCategories(),
            SizedBox(
              height: 10,
            ),
            CarouselImages(),
            SizedBox(
              height: 10,
            ),
            DealOfDay()
          ],
        ),
      ),
    );
  }
}
