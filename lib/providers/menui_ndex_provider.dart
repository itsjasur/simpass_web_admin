import 'package:flutter/material.dart';

class MenuIndexProvider with ChangeNotifier {
  int _openSideMenuIndex = -1;

  int get openSideMenuIndex => _openSideMenuIndex;

  void updateMenuIndexWithUrl(String routePath) {
    int newIndex;
    switch (routePath) {
      case '/profile':
        newIndex = 0;
        break;
      case '/': // this is for manage members
        newIndex = 1;
        break;
      case '/application-receipt-status':
        newIndex = 2;
        break;
      default:
        newIndex = -1; // Default or not found
        break;
    }
    if (openSideMenuIndex != newIndex) {
      _openSideMenuIndex = newIndex;
      notifyListeners();
    }
  }
}
