import 'package:firmus/theme/_light_theme.dart';
import 'package:flutter/material.dart';

enum HomeViewType {
  carousel,
  list,
}

class HomeViewTypeSelector extends StatefulWidget {
  final Function(HomeViewType type) onSelected;
  final HomeViewType initialType;

  const HomeViewTypeSelector(
      {super.key, required this.onSelected, required this.initialType});

  @override
  State<HomeViewTypeSelector> createState() => _HomeViewTypeSelectorState();
}

class _HomeViewTypeSelectorState extends State<HomeViewTypeSelector>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    controller = AnimationController(
      value: widget.initialType != HomeViewType.carousel ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    animation = Tween<double>(
      begin: 8.0,
      end: 146 - 8.0 - 67,
    ).animate(controller);
  }

  @override
  void didUpdateWidget(covariant HomeViewTypeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      selected = widget.initialType;
      if (selected == HomeViewType.carousel) {
        controller.value = 0;
      } else {
        controller.value = 1;
        // controller.forward(from: 0);
      }
    });
  }

  late HomeViewType selected = widget.initialType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 146,
      height: 47,
      decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          )),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: animation.value,
            child: Container(
              width: 67,
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: ShapeDecoration(
                color: const Color(0xFF1479EC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ),
          Positioned.fill(
              child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  left: 8,
                  child: _TabIcon(
                    selected: selected == HomeViewType.carousel,
                    onTap: () {
                      _onSelect(HomeViewType.carousel);
                    },
                    icon: Icons.view_carousel,
                  )),
              Positioned(
                  right: 8,
                  child: _TabIcon(
                    selected: selected == HomeViewType.list,
                    onTap: () {
                      _onSelect(HomeViewType.list);
                    },
                    icon: Icons.view_agenda,
                  )),
            ],
          ))
        ],
      ),
    );
  }

  void _onSelect(HomeViewType type) {
    if (selected == type) return;
    selected = type;
    widget.onSelected(type);
    if (type == HomeViewType.carousel) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }
}

class _TabIcon extends StatefulWidget {
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;

  @override
  State<_TabIcon> createState() => _TabIconState();

  const _TabIcon({
    required this.selected,
    required this.onTap,
    required this.icon,
  });
}

class _TabIconState extends State<_TabIcon> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: widget.selected ? 1 : 0,
    )..addListener(() {
        setState(() {});
      });

    animation = ColorTween(
      begin: FigmaColors.neutralNeutral6,
      end: Colors.white,
    ).animate(controller);
  }

  @override
  void didUpdateWidget(covariant _TabIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selected) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
            width: 67,
            child: Center(
                child: Icon(
              widget.icon,
              color: animation.value,
            ))));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
