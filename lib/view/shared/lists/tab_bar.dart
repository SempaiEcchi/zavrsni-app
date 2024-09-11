import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundedTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final bool large;
  final int? breakPoint;

  @override
  Size get preferredSize => const Size.fromHeight(47);

  const RoundedTabBar({
    Key? key,
    required this.tabs,
    this.large = false,
    this.breakPoint,
  }) : super(key: key);

  @override
  State<RoundedTabBar> createState() => _RoundedTabBarState();
}

class _RoundedTabBarState extends State<RoundedTabBar> {
  bool showArrow = false;
  late ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent * 0.9) {
        setState(() {
          showArrow = false;
        });
      } else {
        setState(() {
          showArrow = true;
        });
      }
    });
    Future(() {
      controller.jumpTo(0.0000001);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      margin: widget.large ? null : const EdgeInsets.symmetric(horizontal: 50),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 2))
        ],
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
      ),
      child: Consumer(
        builder: (context, ref, child) {
          return LayoutBuilder(builder: (context, snapshot) {
            double width = snapshot.maxWidth;
            if (widget.tabs.length > 3) {
              width = width + width / 3;
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: width,
                    child: _buildTabBar(widget.tabs, ref),
                  ),
                ),
                if (showArrow && widget.tabs.length > 3)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        controller.animateTo(
                            controller.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      },
                      child: const SizedBox(
                        height: 47,
                        width: 47,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: FigmaColors.neutralNeutral6,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          });
        },
      ),
    );
  }

  Widget _buildTabBar(
    List<String> tabs,
    ref,
  ) {
    // if (breakPoint != null && tabs.length > breakPoint!) {
    //   final pagesCount = (tabs.length / breakPoint!).ceil();
    //   return PageView.builder(
    //     itemCount: pagesCount,
    //     itemBuilder: (context, index) {
    //       final start = index * breakPoint!;
    //       int end = (index + 1) * breakPoint!;
    //       end = end < tabs.length ? end : tabs.length;
    //       logger.info('start: $start, end: $end');
    //       return tabBar(tabs.sublist(start, end));
    //     },
    //   );
    // }
    return tabBar(tabs, ref);
  }

  TabBar tabBar(List<String> tabs, WidgetRef ref) {
    return TabBar(
        onTap: (index) {
          ref.a.logEvent(name: AnalyticsEvent.tab_bar_tap, parameters: {
            "tab_name": tabs[index],
          });
        },
        dividerColor: Colors.transparent,
        unselectedLabelColor: FigmaColors.neutralNeutral6,
        labelStyle: const TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: FigmaColors.neutralBlack,
        ),
        tabs: [
          ...tabs.map((e) => Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      e,
                      strutStyle: const StrutStyle(forceStrutHeight: true),
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              )),
        ]);
  }
}
