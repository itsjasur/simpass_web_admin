import 'package:flutter/material.dart';

class MyinfoProvifer extends ChangeNotifier {
  final List<String> _myRoles = [];
  List<String> get myRoles => _myRoles;
}
