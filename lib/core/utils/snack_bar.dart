import 'package:flutter/material.dart';

// Function to open a snackbar with provided message and color
void openSnackbar(BuildContext context, String snackMessage, Color color) {
  // Show a snackbar with the provided message and color
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // Set the background color of the snackbar
      backgroundColor: color,
      // Define an action for the snackbar
      action: SnackBarAction(
        // Label for the action button
        label: "OK",
        // Text color of the action button
        textColor: Colors.white,
        // Action to perform when the button is pressed
        onPressed: () {},
      ),
      // Content of the snackbar displaying the message
      content: Text(
        snackMessage,
        style: const TextStyle(fontSize: 14),
      ),
    ),
  );
}
