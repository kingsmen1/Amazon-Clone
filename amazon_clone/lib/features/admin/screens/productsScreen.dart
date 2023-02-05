import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/accounts/widgets/singleProduct.dart';
import 'package:amazon_clone/features/admin/screens/addProducts.dart';
import 'package:amazon_clone/features/admin/services/adminServices.dart';
import 'package:amazon_clone/models/productModel.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final AdminServices adminServices = AdminServices();
  //^NOTE:in order to check if list is null dont initialize it.
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  fetchProducts() async {
    // await Future.delayed(const Duration(seconds: 1));
    products = await adminServices.fetchProducts(context);
    setState(() {});
  }

  deleteProduct(String id, int index) async {
    await adminServices.deleteProduct(context, id: id);
    products!.removeAt(index);
    setState(() {});
  }

  void navigateToAddProducts() {
    Navigator.pushNamed(context, AddProducts.routeName).then((productData) {
      final Product? product =
          productData == null ? null : productData as Product;
      if (product != null) {
        products!.add(product);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //^Note: how we checking if products is null instead of isEmpty.
    return products == null
        ? loadingCircle
        : Scaffold(
            body: GridView.builder(
                itemCount: products!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final productData = products![index];
                  return Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: SingleProduct(image: productData.images[0]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              productData.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                deleteProduct(productData.id!, index);
                              },
                              icon: const Icon(Icons.delete_outlined))
                        ],
                      )
                    ],
                  );
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProducts,

              tooltip: 'Add a Product',
              child: const Icon(Icons.add),
              //~tooltip
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
