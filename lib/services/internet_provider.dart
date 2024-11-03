// Importing necessary packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

// InternetProvider class to manage internet connectivity state
class InternetProvider extends ChangeNotifier {
  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;

  // Constructor: initializes the provider and checks internet connection status
  InternetProvider() {
    checkInternetConnection();
  }

  // Function: checks and updates internet connection status
  Future checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _hasInternet = false;
    } else {
      _hasInternet = true;
    }
    notifyListeners();
  }
}
