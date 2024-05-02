import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyinfoProvifer extends ChangeNotifier {
  List<String> _myRoles = [];
  String? _userName;

  List<String> get myRoles => _myRoles;
  String? get userName => _userName;

  Future<void> setRoles(List<String> roles) async {
    _myRoles = roles;
    notifyListeners();
  }

  Future<void> updateUserInfo(List<String> roles, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('myRolesList', roles);
    await prefs.setString('userName', name);
    _myRoles = roles;
    _userName = name;

    notifyListeners();
  }

  Future<List<String>> getRolesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> roles = prefs.getStringList('myRolesList') ?? [];
    String? name = prefs.getString('userName');
    _myRoles = roles;
    _userName = name;
    return roles;
  }
}
