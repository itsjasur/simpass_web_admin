// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// // class MenuDrawerController extends ChangeNotifier {
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// //   GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

// //   void openSideMenu() {
// //     print('open drawer pressed');
// //     if (!_scaffoldKey.currentState!.isDrawerOpen) {
// //       _scaffoldKey.currentState!.openDrawer();
// //     }
// //   }

// //   void closeSideMenu() {
// //     print('close drawer pressed');
// //     if (_scaffoldKey.currentState!.isDrawerOpen) {
// //       _scaffoldKey.currentState!.openDrawer();
// //     }
// //   }
// // }

// class MenuDrawerController {
//   final _sideMenuStatusNotifier = ValueNotifier<bool>(true);

//   ValueListenable<bool> get sideMenuStatus => _sideMenuStatusNotifier;

//   void openSideMenu() async {
//     print('open drawer pressed');
//     if (_sideMenuStatusNotifier.value == false) {
//       _sideMenuStatusNotifier.value = true;
//     }
//   }

//   void closeSideMenu() {
//     print('close drawer pressed');
//     if (_sideMenuStatusNotifier.value == true) {
//       _sideMenuStatusNotifier.value = false;
//     }
//   }
// }

// final MenuDrawerController sideMenuController = MenuDrawerController();
