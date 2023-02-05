import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textField.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/adminServices.dart';
import 'package:amazon_clone/common/widgets/appbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddProducts extends StatefulWidget {
  static const routeName = '/add-products';
  const AddProducts({Key? key}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  List<File> _images = [];
  final AdminServices adminServices = AdminServices();
  final _addProductFormKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  String category = 'Mobiles';

  final List<String> _productCategories = [
    'Mobiles',
    "Essentials",
    "Appliances",
    'Books',
    'Fashion'
  ];

  void sellProduct() async {
    if (_images.isEmpty) {
      return showSnackbar(context, 'Please Select Images');
    }
    if (_addProductFormKey.currentState!.validate() && _images.isNotEmpty) {
      await adminServices.sellProducts(context,
          name: productNameController.text,
          description: descriptionController.text,
          category: category,
          price: double.parse(priceController.text),
          quantity: double.parse(quantityController.text),
          images: _images);
    }
  }

  Future<void> selectImages() async {
    final List<File> pickedImages = await pickImages();
    setState(() {
      _images = pickedImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(centerTitle: true, title: 'Add Products'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _addProductFormKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  //~DottedBorder
                  _images.isNotEmpty
                      ? CarouselSlider(
                          items: _images.map((image) {
                            return Builder(builder: (BuildContext context) {
                              return Image.file(
                                image,
                                fit: BoxFit.cover,
                                height: 200,
                              );
                            });
                          }).toList(),
                          options: CarouselOptions(
                              viewportFraction: 1,
                              height: 200,
                              autoPlay: true,
                              autoPlayInterval:
                                  const Duration(milliseconds: 3000)),
                        )
                      : GestureDetector(
                          onTap: selectImages,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.folder_open,
                                    size: 40,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Select Product Image',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                      controller: productNameController,
                      hintText: 'Product Name'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Description',
                    maxLines: 7,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: priceController,
                    hintText: 'Price',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: quantityController,
                    hintText: 'Quanitity',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    //~DropdownButton
                    child: DropdownButton(
                      value: category,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _productCategories.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newVal) {
                        setState(() {
                          category = newVal!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(text: 'Sell', onTap: sellProduct)
                ],
              )),
        ),
      ),
    );
  }
}
