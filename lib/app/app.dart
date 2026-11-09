import 'package:flutter/material.dart';

import '../config/router/router.dart';
import '../config/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GitHub Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.defaultTheme.themeData,
      routerConfig: appRouter,
    );
  }
}
