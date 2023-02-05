import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/home/screens/categoryDealScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({Key? key}) : super(key: key);

  void navigateToCategoriesScreen(BuildContext context, String category) {
    //~passing data through arguments in named routing
    Navigator.of(context).pushNamed(CategoryDealsScreen.routeName,
        arguments: {"category": category});
  }

  @override
  Widget build(BuildContext context) {
    return
        //  Expanded(
        //   child:
        SizedBox(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: GlobalVariables.categoryImages.length,
          itemExtent: 83,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (() => navigateToCategoriesScreen(context,
                  GlobalVariables.categoryImages[index]['title']!.toString())),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          GlobalVariables.categoryImages[index]['image']!,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        )),
                  ),
                  Text(GlobalVariables.categoryImages[index]['title']!,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400))
                ],
              ),
            );
          }),
    );
    // );
  }
}
