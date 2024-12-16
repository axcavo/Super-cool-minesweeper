import 'package:flutter/material.dart';
import 'package:super_cool_minesweeper/desktop_layout.dart';
import 'package:super_cool_minesweeper/mobile_layout.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return MaterialApp(home: LayoutBuilder(builder: (_, constraints) {
      return constraints.maxWidth > MobileLayout.maxMobileLayoutWidth
          ? const DesktopLayout()
          : const MobileLayout();
    }));
  }
}

void main() {
  runApp(const App());
}
