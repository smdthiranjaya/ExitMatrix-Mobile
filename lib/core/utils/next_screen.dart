import 'package:flutter/material.dart';

//This function pushes a new page to the navigation stack
void nextScreen(context, page) {
  //Push a new page to the navigation stack using the MaterialPageRoute
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

//This function pushes a new page to the navigation stack and replaces the current page
void nextScreenReplace(context, page) {
  //Push a new page to the navigation stack using the MaterialPageRoute and replace the current page
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}
