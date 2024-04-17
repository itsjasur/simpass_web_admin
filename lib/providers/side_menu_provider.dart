import 'package:flutter/material.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/global_keys.dart';

class SideMenuProvider with ChangeNotifier {
  // Private variables to handle the drawer's visibility
  bool _isSideMenuOpen = false;
  bool _sideMenuManuallyClosed = false;
  bool _isDesktop = false;
  double _previousScreenWidth = 0;

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
  void updateDrawerBasedOnScreenSize(double width) {
    if (width != _previousScreenWidth && !_isDesktop && width > desktopBreakPoint) {
      _isDesktop = true;
      rootScaffoldKey.currentState?.closeDrawer();

      _previousScreenWidth = width;
      notifyListeners();
    }
    if (width != _previousScreenWidth && width < desktopBreakPoint && _isDesktop) {
      _isDesktop = false;
      // _isSideMenuOpen = false;

      _previousScreenWidth = width;
      notifyListeners();
    }
  }
}
