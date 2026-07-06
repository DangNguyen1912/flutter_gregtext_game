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
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Base'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inv'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Craft'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}
