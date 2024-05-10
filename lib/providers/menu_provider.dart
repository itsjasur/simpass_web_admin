import 'package:admin_simpass/globals/constants.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  int _index = -1;

  String _title = "";

  int get index => _index;
  String get title => _title;

  void updateMenu(int index) {
    _index = index;
    _title = sideMenuPages[index];
    notifyListeners();
  }
}
