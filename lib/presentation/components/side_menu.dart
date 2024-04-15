import 'package:admin_simpass/presentation/components/clickable_logo.dart';
import 'package:flutter/material.dart';
import 'package:admin_simpass/presentation/components/side_menu_tile.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.black,
      // width: 500,
      // shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
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
            isSelected: true,
          ),
          SideMenuWidget(
            title: "사용자 관리",
            iconSrc: "assets/icons/admin.svg",
            press: () {
              context.go('/');
            },
          ),
          SideMenuWidget(
            title: "요금제 관리",
            iconSrc: "assets/icons/plans.svg",
            press: () {},
          ),
          SideMenuWidget(
            title: "신청서 접수현황",
            iconSrc: "assets/icons/regis.svg",
            press: () {},
          ),
          SideMenuWidget(
            title: "판매점 계약현황",
            iconSrc: "assets/icons/partner.svg",
            press: () {},
          ),
          SideMenuWidget(
            title: "판매점 계약현황",
            iconSrc: "assets/icons/partner.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}
