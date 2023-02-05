import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';

PreferredSize customAppbar({bool centerTitle = false, String title = ''}) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient)),
        title: centerTitle
            ? Text(
                title,
                style: const TextStyle(color: Colors.black),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/amazon_in.png',
                      width: 120,
                      height: 45,
                    ),
                  ),
                  const Text(
                    'Admin',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  )
                ],
              ),
        centerTitle: centerTitle ? true : false,
      ));
}
