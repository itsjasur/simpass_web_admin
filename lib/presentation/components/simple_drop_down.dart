import 'package:admin_simpass/globals/main_ui.dart';
import 'package:flutter/material.dart';

class SimpleDropDown extends StatefulWidget {
  final List items;
  final Function(dynamic)? onSelected;
  final double width;

  const SimpleDropDown({super.key, this.onSelected, required this.items, this.width = 200});

  @override
  State<SimpleDropDown> createState() => _SimpleDropDownState();
}

class _SimpleDropDownState extends State<SimpleDropDown> {
  int _selectedIndex = 0;
  bool _isMenuOpen = false;

  final MenuController _menuController = MenuController();
  final GlobalKey _key = GlobalKey(); // Global key for the widget we want to measure
  double _dynamicWidth = 200; // Default width

  late RenderBox renderBox;

  final _contectPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _menuController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      style: const MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.white),
        surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
        padding: MaterialStatePropertyAll(EdgeInsets.zero),
        visualDensity: VisualDensity.compact,
      ),
      menuChildren: List.generate(
        widget.items.length,
        (index) => InkWell(
          onTap: () {
            _selectedIndex = index;

            if (_menuController.isOpen) {
              _isMenuOpen = false;
              _menuController.close();
            } else {
              _isMenuOpen = true;
              _menuController.open();
            }

            if (widget.onSelected != null) {
              widget.onSelected!(index);
            }

            setState(() {});
          },
          child: SizedBox(
            width: _dynamicWidth,
            child: Container(
              color: _selectedIndex == index ? Colors.grey.shade200 : null,
              child: Padding(
                padding: _contectPadding,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.items[index].toString(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
          _dynamicWidth = renderBox.size.width;

          if (_menuController.isOpen) {
            _isMenuOpen = false;
            _menuController.close();
          } else {
            _isMenuOpen = true;
            _menuController.open();
          }

          setState(() {});
        },

        // width of this padding widget should decice width of sizedbox above
        child: Padding(
          key: _key,
          padding: _contectPadding,
          child: Row(
            children: [
              Text(widget.items[_selectedIndex].toString()),
              const SizedBox(width: 5),
              _isMenuOpen ? const Icon(Icons.arrow_drop_up) : const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
