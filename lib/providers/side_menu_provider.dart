import 'package:flutter/material.dart';
import 'package:admin_simpass/presentation/constants.dart';
import 'package:admin_simpass/globals/global_keys.dart';

class SideMenuProvider with ChangeNotifier {
  // Private variables to handle the drawer's visibility
  bool _isSideMenuOpen = false;
  bool _sideMenuManuallyClosed = false;
  bool _isDesktop = false;

  // Getters to access private variables
  bool get isSideMenuOpen => _isSideMenuOpen;
  bool get sideMenuManuallyClosed => _sideMenuManuallyClosed;
  bool get isDesktop => _isDesktop;

  // Function to toggle the drawer's state
  void toggleDrawer() {
    _isSideMenuOpen = !_isSideMenuOpen;
    if (_isDesktop) _sideMenuManuallyClosed = !_sideMenuManuallyClosed;
    notifyListeners();
  }

  // changes if the device is desktop based on the width
  void updateDrawerBasedOnScreenSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > desktopBreakPoint) {
      _isDesktop = true;
      _isSideMenuOpen = true;
      homePageScaffoldKey.currentState?.closeDrawer();
    } else {
      _isDesktop = false;
      _isSideMenuOpen = false;
    }
    notifyListeners();
  }
}
