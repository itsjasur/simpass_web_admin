import 'package:admin_simpass/presentation/components/simple_drop_down.dart';
import 'package:admin_simpass/presentation/components/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Pagination extends StatefulWidget {
  const Pagination({super.key});

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  final List _perPageCounts = [2023431231, 50, 100, 200, 100000234200];
  int? _selectedIndex;

  MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.arrow_back_ios_new),
        SizedBox(width: 10),
        SimpleDropDown(
          items: _perPageCounts,
          onSelected: (selectedIndex) {
            setState(() {});
          },
          width: 200,
        )
      ],
    );
  }
}
