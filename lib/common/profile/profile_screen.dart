import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:exitmatrix/core/utils/app_bar.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  // Get the current user
  final user = FirebaseAuth.instance.currentUser;

  // Set the route name
  static String routeName = '/profile';

  // Create the widget
  ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser!;
    // Return the scaffold with the app bar and body
    return Scaffold(
      body: Body(user: user),
    );
  }
}
