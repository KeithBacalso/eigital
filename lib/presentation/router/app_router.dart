import 'package:eigital_test/presentation/screens/home_screen.dart';
import 'package:eigital_test/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.route:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case HomeScreen.route:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      default:
        throw Exception('Route not found!');
    }
  }
}
