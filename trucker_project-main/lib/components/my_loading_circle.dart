import 'package:flutter/material.dart';

/*
 Loading circle
 */

// Show
void showLoadingCircle(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}

// Hide
void hideLoadingCircle(BuildContext context) {
  Navigator.pop(context);
}
