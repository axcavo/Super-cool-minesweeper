import 'package:flutter/material.dart';

class GameLayout extends StatefulWidget {
  const GameLayout({super.key});

  @override
  State<StatefulWidget> createState() => GameLayoutState();
}

class GameLayoutState extends State<GameLayout> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor:Color(0xFFC86AE1),
    );
  }
}