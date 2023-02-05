import 'package:amazon_clone/common/widgets/appbar.dart';
import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/home/services/homeServices.dart';
import 'package:amazon_clone/features/productDetails/screens/productDetailsScreen.dart';
import 'package:amazon_clone/models/productModel.dart';
import 'package:flutter/material.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const routeName = '/category-Deals';
  final String category;
  const CategoryDealsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  @override
  void initState() {
    super.initState();
    getCategoryProducts(widget.category);
  }

  final HomeServices homeServices = HomeServices();
  List<Product>? products;

  Future<void> getCategoryProducts(String category) async {
    products =
        await homeServices.getCategoryProducts(context, category: category);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? loadingCircle
        : Scaffold(
            appBar: customAppbar(centerTitle: true, title: widget.category),
            body: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Keep shopping for ${widget.category}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 15),
                      itemCount: products!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1, childAspectRatio: 1.4),
                      itemBuilder: (context, index) {
                        final Product product = products![index];
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, ProductDetailsScreen.routeName,
                              arguments: product),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 130,
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black12, width: 0.8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Image.network(product.images[0]),
                                    )),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(
                                    top: 5, left: 0, right: 15),
                                child: Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          );
  }
}
