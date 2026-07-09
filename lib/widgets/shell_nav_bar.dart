import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ShellNavBar({super.key, required this.navigationShell});

  @override
  State<ShellNavBar> createState() => _ShellNavBarState();
}

class _ShellNavBarState extends State<ShellNavBar> {
  @override
  Widget build(BuildContext context) {
    double ligterDarker() {
      return MediaQuery.of(context).platformBrightness == Brightness.dark
          ? 0.1
          : -0.1;
    }

    var surface = Theme.of(context).colorScheme.surface;
    var bgColor = surface.withValues(
      red: (surface.r + ligterDarker()).clamp(0, 1),
      green: (surface.g + ligterDarker()).clamp(0, 1),
      blue: (surface.b + ligterDarker()).clamp(0, 1),
    );
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(24)),
        child: BottomNavigationBar(
          backgroundColor: bgColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: widget.navigationShell.currentIndex,
          onTap: (index) {
            widget.navigationShell.goBranch(
              index,
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          },
          selectedFontSize: 18,
          items:
              [
                    (Icons.explore, 'Explore'),
                    (Icons.home, 'Base'),
                    (Icons.inventory, 'Inventory'),
                    (Icons.build, 'Craft'),
                    (Icons.settings, 'Settings'),
                  ]
                  .map(
                    (e) => BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(e.$1),
                      ),
                      label: e.$2,
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
