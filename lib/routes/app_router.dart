import 'package:flutter/material.dart';

import '../screens/login_page.dart';
import '../screens/credits_page.dart';
import '../screens/shell_page.dart';
import '../screens/splash_page.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const shell = '/shell';
  static const credits = '/credits';
}

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (_) => const SplashPage(),
    AppRoutes.login: (_) => const LoginPage(successRouteName: AppRoutes.shell),
    AppRoutes.shell: (_) => const ShellPage(),
    AppRoutes.credits: (_) => const CreditsPage(),
  };
}