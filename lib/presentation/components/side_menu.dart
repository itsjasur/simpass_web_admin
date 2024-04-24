import 'package:admin_simpass/presentation/components/clickable_logo.dart';
import 'package:admin_simpass/providers/menu_navigation_provider.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:admin_simpass/presentation/components/side_menu_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final myInfoProvider = Provider.of<MyinfoProvifer>(context, listen: false);
    List<String> roles = await myInfoProvider.getRolesList();
    setState(() {
      isAdmin = roles.contains("ROLE_SUPER") || roles.contains("ROLE_ADMIN");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.black,
      // width: 500,
      // shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
      child: Consumer<MenuIndexProvider>(builder: (context, value, child) {
        return ListView(
          children: [
            InkWell(
              onTap: () {
                context.go('/');
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
            SideMenuWidget(
              title: "나의 정보",
              iconSrc: "assets/icons/user.svg",
              press: () {
                context.go('/profile');
              },
              isSelected: value.openSideMenuIndex == 0,
            ),
            if (isAdmin)
              SideMenuWidget(
                title: "사용자 관리",
                iconSrc: "assets/icons/admin.svg",
                press: () {
                  context.go('/manage-users');
                },
                isSelected: value.openSideMenuIndex == 1,
              ),
            SideMenuWidget(
              title: "요금제 관리",
              iconSrc: "assets/icons/plans.svg",
              press: () {
                context.go('/manage-plans');
              },
              isSelected: value.openSideMenuIndex == 2,
            ),
            SideMenuWidget(
              title: "신청서 접수현황",
              iconSrc: "assets/icons/regis.svg",
              press: () {
                context.go('/applications');
              },
              isSelected: value.openSideMenuIndex == 3,
            ),
            SideMenuWidget(
              title: "판매점 계약현황",
              iconSrc: "assets/icons/partner.svg",
              press: () {
                context.go('/retailers');
              },
              isSelected: value.openSideMenuIndex == 4,
            ),
          ],
        );
      }),
    );
  }
}
