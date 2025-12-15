import 'package:flutter/material.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/stock_detail/stock_detail_screen.dart';
import '../../presentation/screens/trade_plan/trade_plan_screen.dart';
import '../../data/models/stock.dart';

/// Application router for navigation
class AppRouter {
  /// Route names
  static const String home = '/';
  static const String stockDetail = '/stock-detail';
  static const String tradePlan = '/trade-plan';

  /// Generate routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case stockDetail:
        final stock = settings.arguments as Stock;
        return MaterialPageRoute(
          builder: (_) => StockDetailScreen(stock: stock),
        );

      case tradePlan:
        final stock = settings.arguments as Stock;
        return MaterialPageRoute(
          builder: (_) => TradePlanScreen(stock: stock),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }

  /// Navigate to home
  static void goToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      home,
      (route) => false,
    );
  }

  /// Navigate to stock detail
  static void goToStockDetail(BuildContext context, Stock stock) {
    Navigator.of(context).pushNamed(
      stockDetail,
      arguments: stock,
    );
  }

  /// Navigate to trade plan
  static void goToTradePlan(BuildContext context, Stock stock) {
    Navigator.of(context).pushNamed(
      tradePlan,
      arguments: stock,
    );
  }
}
