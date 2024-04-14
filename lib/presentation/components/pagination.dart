import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/presentation/components/pagination_drop_down.dart';
import 'package:admin_simpass/presentation/components/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class Pagination extends StatefulWidget {
  final Function(dynamic)? onSelected;
  const Pagination({super.key, this.onSelected});

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  final List<int> _perPageCounts = [10, 20, 50, 100, 200];

  int _selectedIndex = 0;

  int _totalCount = 23;
  int _currentPage = 1;

  int _fromCount = 1;
  int _toCount = 1;

  bool _backButtonHovered = false;
  bool _forwardButtonHovered = false;

  @override
  void initState() {
    _updateNumbers();
    super.initState();
  }

  void _updateNumbers() {
    _fromCount = (_currentPage * _perPageCounts[_selectedIndex]) - _perPageCounts[_selectedIndex] + 1;
    _toCount = (_currentPage * _perPageCounts[_selectedIndex]);

    if (_toCount > _totalCount) _toCount = _totalCount;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // (_currentPage *  _perPageCounts[_selectedIndex] –10) / _totalCount;

        Text(
          '$_fromCount - $_toCount / $_totalCount',
          style: const TextStyle(color: Colors.black87),
        ),
        const Gap(10),

        const Text(
          '페이지 당 행',
          style: TextStyle(color: Colors.black87),
        ),
        const Gap(10),
        SimpleDropDown(
          items: _perPageCounts,
          onSelected: (selectedIndex) {
            _selectedIndex = selectedIndex;
            _updateNumbers();
          },
        ),
        const Gap(20),
        InkWell(
          onTap: () {
            if (_currentPage > 1) _currentPage--;

            _updateNumbers();
          },
          onHover: (value) {
            _backButtonHovered = value;
            setState(() {});
          },
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 15,
            color: _backButtonHovered ? MainUi.mainColor : Colors.black54,
          ),
        ),
        const Gap(10),
        Row(
          children: List.generate(
            (_totalCount / _perPageCounts[_selectedIndex]).ceil(),
            (index) {
              if (index + 1 == _currentPage) {
                return Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: MainUi.mainColor),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      (index + 1).toString(),
                    ),
                  ),
                );
              }
              return InkWell(
                onTap: () {
                  _currentPage = index + 1;
                  _updateNumbers();
                  setState(() {});
                },
                onHover: (value) {},
                borderRadius: BorderRadius.circular(3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Text(
                    (index + 1).toString(),
                  ),
                ),
              );
            },
          ),
        ),
        const Gap(10),
        InkWell(
          onTap: () {
            if (_currentPage < (_totalCount / _perPageCounts[_selectedIndex]).ceil()) _currentPage++;

            _updateNumbers();
          },
          onHover: (value) {
            _forwardButtonHovered = value;

            setState(() {});
          },
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: _forwardButtonHovered ? MainUi.mainColor : Colors.black54,
          ),
        ),
      ],
    );
  }
}
