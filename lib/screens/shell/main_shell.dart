import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../core/04_dashboard_screen.dart';
import '../core/05_client_management_screen.dart';
import '../deal_cycle/12_orders_screen.dart';
import '../logistics/14_shipment_tracking_screen.dart';
import 'modules_directory_sheet.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ClientManagementScreen(),
    OrdersScreen(),
    ShipmentTrackingScreen(),
    FinanceHubScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          selectedItemColor: isDark ? AppColors.tradeTeal : AppColors.deepNavy,
          unselectedItemColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Clients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.handshake_outlined),
              activeIcon: Icon(Icons.handshake),
              label: 'Deals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_boat_outlined),
              activeIcon: Icon(Icons.directions_boat),
              label: 'Logistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Finance',
            ),
          ],
        ),
      ),
    );
  }
}
