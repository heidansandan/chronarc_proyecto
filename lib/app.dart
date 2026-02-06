import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

class ChronarcApp extends StatelessWidget {
  const ChronarcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chronarc',
      theme: AppTheme.dark(),
      initialRoute: AppRoutes.splash,
      routes: AppRouter.routes,
    );
  }
}