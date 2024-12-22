import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_cool_minesweeper/app_data.dart';
import 'package:super_cool_minesweeper/widgets/desktop/game_layout.dart' as desktop;
import 'package:super_cool_minesweeper/widgets/mobile/game_layout.dart' as mobile;
import 'constants.dart' as constants;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AppData(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LayoutBuilder(
              builder: (_, constraints) => resolveLayout(constraints)),
        ));
  }

  Widget resolveLayout(BoxConstraints constraints) {
    double maxWidth = constraints.maxWidth;
    return maxWidth > constants.maxMobileLayoutWidth
        ? const desktop.GameLayout()
        : const desktop.GameLayout();
  }
}
