import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({
    super.key,
    required this.title,
    required this.iconSrc,
    required this.press,
    this.isSelected = false,
  });

  final String title, iconSrc;
  final VoidCallback press;
  final bool isSelected;

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  //changing color when hovered
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: MouseRegion(
          onEnter: (PointerEvent details) {
            _hovering = true;
            setState(() {});
          },
          onExit: (PointerEvent details) {
            _hovering = false;
            setState(() {});
          },
          child: Row(
            children: [
              SvgPicture.asset(
                widget.iconSrc,
                colorFilter: widget.isSelected || _hovering
                    ? const ColorFilter.mode(Colors.orangeAccent, BlendMode.srcIn)
                    : const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                height: 16,
              ),
              const SizedBox(width: 15),
              Text(
                widget.title,
                style: TextStyle(color: widget.isSelected || _hovering ? Colors.orangeAccent : Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
