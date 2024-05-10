import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/presentation/components/clickable_logo.dart';
import 'package:admin_simpass/providers/menu_provider.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:admin_simpass/presentation/components/side_menu_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // //checking user roles from myinfoprovider
    // final myInfoProvider = Provider.of<MyinfoProvifer>(context, listen: false);
    // List<String> myRoles = myInfoProvider.myRoles;

    return Consumer<MyinfoProvifer>(
      builder: (context, myInfoProvider, child) => Drawer(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black,
        // width: 500,
        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
        child: Consumer<MenuProvider>(
          builder: (context, value, child) {
            return ListView(
              children: [
                InkWell(
                  onTap: () {
                    context.go('/profile');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    alignment: Alignment.topLeft,
                    child: const ClickableLogo(
                      height: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Text(
                    "반갑습니다 ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (myInfoProvider.userName != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Text(
                      myInfoProvider.userName!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                SideMenuWidget(
                  title: sideMenuPages[0],
                  iconSrc: "assets/icons/user.svg",
                  press: () {
                    context.go('/profile');
                  },
                  isSelected: value.index == 0,
                ),
                if (myInfoProvider.myRoles.any((role) => rolePathAccessInfo['/manage-users']!.contains(role)))
                  SideMenuWidget(
                    title: sideMenuPages[1],
                    iconSrc: "assets/icons/admin.svg",
                    press: () {
                      context.go('/manage-users');
                    },
                    isSelected: value.index == 1,
                  ),
                if (myInfoProvider.myRoles.any((role) => rolePathAccessInfo['/manage-plans']!.contains(role)))
                  SideMenuWidget(
                    title: sideMenuPages[2],
                    iconSrc: "assets/icons/plans.svg",
                    press: () {
                      context.go('/manage-plans');
                    },
                    isSelected: value.index == 2,
                  ),
                if (myInfoProvider.myRoles.any((role) => rolePathAccessInfo['/applications']!.contains(role)))
                  SideMenuWidget(
                    title: sideMenuPages[3],
                    iconSrc: "assets/icons/regis.svg",
                    press: () {
                      context.go('/applications');
                    },
                    isSelected: value.index == 3,
                  ),
                if (myInfoProvider.myRoles.any((role) => rolePathAccessInfo['/retailers']!.contains(role)))
                  SideMenuWidget(
                    title: sideMenuPages[4],
                    iconSrc: "assets/icons/partner.svg",
                    press: () {
                      context.go('/retailers');
                    },
                    isSelected: value.index == 4,
                  ),
                SideMenuWidget(
                  title: sideMenuPages[5],
                  iconSrc: "assets/icons/call.svg",
                  press: () {
                    context.go('/customer-requests');
                  },
                  isSelected: value.index == 5,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
