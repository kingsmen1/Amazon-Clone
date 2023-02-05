import 'package:amazon_clone/common/widgets/appbar.dart';
import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/home/widgets/addressBox.dart';
import 'package:amazon_clone/features/productDetails/screens/productDetailsScreen.dart';
import 'package:amazon_clone/features/search/services/searchServices.dart';
import 'package:amazon_clone/features/search/widgets/searchedProduct.dart';
import 'package:amazon_clone/models/productModel.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';
  final String searchQuery;
  const SearchScreen({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  final SearchServices searchServices = SearchServices();
  List<Product>? products;

  @override
  void dispose() {
    super.dispose();
    _searchQueryController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchSearchedProduct();
  }

  Future<void> fetchSearchedProduct() async {
    products = await searchServices.fetchSearchedProduct(context,
        searchQuery: widget.searchQuery);
    setState(() {});
  }

  void navigateToSearchScreen(String queryString) {
    _searchQueryController.text = '';
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: queryString);
  }

  @override
  Widget build(BuildContext context) {
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
        body: products == null
            ? loadingCircle
            : Column(
                children: [
                  const AddressBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  //^NOTE:alway provide size to listview builder in column or row
                  Expanded(
                    child: ListView.builder(
                        itemCount: products!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, ProductDetailsScreen.routeName,
                                  arguments: products![index]),
                              child:
                                  SearchedProduct(product: products![index]));
                        }),
                  )
                ],
              ));
  }
}
