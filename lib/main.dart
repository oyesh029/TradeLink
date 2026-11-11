import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/access/01_splash_screen.dart';
import 'state/trade_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const TradeLinkApp());
}

class TradeLinkApp extends StatefulWidget {
  const TradeLinkApp({super.key});

  @override
  State<TradeLinkApp> createState() => _TradeLinkAppState();
}

class _TradeLinkAppState extends State<TradeLinkApp> {
  final TradeState _tradeState = TradeState();

  @override
  void initState() {
    super.initState();
    _tradeState.initDatabase();
  }

  @override
  void dispose() {
    _tradeState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TradeStateInherited(
      notifier: _tradeState,
      child: AnimatedBuilder(
        animation: _tradeState,
        builder: (context, _) {
          return MaterialApp(
            title: 'TradeLink | Import Export Commission Agent Platform',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _tradeState.currentUser.darkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
