import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_cool_minesweeper/app_data.dart';
import 'package:super_cool_minesweeper/desktop_layout.dart';
import 'package:super_cool_minesweeper/mobile_layout.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return ChangeNotifierProvider(
        create: (_) => AppData(),
        child: MaterialApp(home: LayoutBuilder(builder: (_, constraints) {
          return constraints.maxWidth > MobileLayout.maxMobileLayoutWidth
              ? DesktopLayout(size: size)
              : const MobileLayout();
        })));
  }
}

void main() {
  runApp(const App());
}
