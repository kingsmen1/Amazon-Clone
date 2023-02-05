import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final String image;
  const SingleProduct({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1.2),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.network(
          image,
          fit: BoxFit.cover,
          // width: 180,
        ),
      ),
    );
  }
}
