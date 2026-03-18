import 'package:flutter/material.dart';

import 'core/app_routes.dart';
import 'core/app_state.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const QuickAidRoot());
}

class QuickAidRoot extends StatefulWidget {
  const QuickAidRoot({super.key});

  @override
  State<QuickAidRoot> createState() => _QuickAidRootState();
}

class _QuickAidRootState extends State<QuickAidRoot> {
  late final AppStateController _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppStateController();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuickAid Tech',
        theme: buildQatTheme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRoutes.landing,
      ),
    );
  }
}
