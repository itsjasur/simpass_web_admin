import 'package:flutter/material.dart';

class SimpleDropDown extends StatefulWidget {
  final List items;
  final Function(dynamic)? onSelected;
  final int? selectedindex;
  final double? width;
  final double height;

  const SimpleDropDown({super.key, this.onSelected, required this.items, this.width, this.selectedindex, this.height = 40});

  @override
  State<SimpleDropDown> createState() => _SimpleDropDownState();
}

class _SimpleDropDownState extends State<SimpleDropDown> {
  int? _selectedIndex;
  bool _isMenuOpen = false;
  final MenuController _menuController = MenuController();

  final GlobalKey _key = GlobalKey(); // Global key for the widget we want to measure
  double _dynamicWidth = 200; // Default width

  @override
  void initState() {
    _selectedIndex = widget.selectedindex;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      onClose: () {
        if (mounted) {
          _isMenuOpen = false;
          setState(() {});
        }
      },
      onOpen: () {
        if (mounted) {
          _isMenuOpen = true;
          setState(() {});
        }
      },
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
            _toggleMenu();

            if (widget.onSelected != null) {
              widget.onSelected!(index);
            }

            setState(() {});
          },
          child: Container(
            width: widget.width ?? _dynamicWidth,
            color: widget.selectedindex == index ? Colors.grey.shade200 : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(widget.items[index].toString()),
              ),
            ),
          ),
        ),
      ),
      child: InkWell(
        onHover: (value) {},

        borderRadius: BorderRadius.circular(5),
        onTap: () {
          final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
          _dynamicWidth = renderBox.size.width;

          _toggleMenu();
          setState(() {});
        },

        // width of this padding widget should decice width of sizedbox above
        child: Container(
          constraints: BoxConstraints(minHeight: widget.height),
          key: _key,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(3),
          ),
          width: widget.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    _selectedIndex != null ? widget.items[_selectedIndex!] : "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                _isMenuOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleMenu() {
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }
}
