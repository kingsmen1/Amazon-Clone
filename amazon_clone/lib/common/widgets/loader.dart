import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Center loader() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

const loaderRotating = SpinKitRotatingCircle(
  color: GlobalVariables.secondaryColor,
  size: 50.0,
);

final loaderRibbon = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    print('played');
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven
            ? GlobalVariables.secondaryColor
            : GlobalVariables.selectedNavBarColor,
      ),
    );
  },
);

const loadingCircle = Padding(
  padding: EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 10,
  ),
  child: SpinKitFadingCircle(color: GlobalVariables.secondaryColor, size: 100),
);
