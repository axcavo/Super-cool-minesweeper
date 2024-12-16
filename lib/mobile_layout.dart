import 'package:flutter/material.dart';

class MobileLayout extends StatefulWidget {
  static double maxMobileLayoutWidth = 767;

  const MobileLayout({super.key});

  @override
  State<StatefulWidget> createState() => MobileLayoutState();
}

class MobileLayoutState extends State<MobileLayout> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueGrey,
    );
  }
  
}