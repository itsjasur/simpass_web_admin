import 'package:flutter/material.dart';

class AuthServiceProvider extends ChangeNotifier {
  bool _isLoggedIn = true;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}



// class AuthServiceProvider with ChangeNotifier {
//   void login(String accessToken, String refreshToken) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('accessToken', accessToken);
//     await prefs.setString('refreshToken', refreshToken);
//     notifyListeners(); // Notify listeners that login status has changed
//   }

//   void logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('accessToken');
//     await prefs.remove('refreshToken');
//     notifyListeners(); // Notify listeners that login status has changed
//   }
// }
