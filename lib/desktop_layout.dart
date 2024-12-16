import 'package:flutter/material.dart';

class DesktopLayout extends StatefulWidget {
  static double maxMobileLayoutWidth = 767;

  const DesktopLayout({super.key});

  @override
  State<StatefulWidget> createState() => DesktopLayoutState();
}

class DesktopLayoutState extends State<DesktopLayout> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
    );
  }

}