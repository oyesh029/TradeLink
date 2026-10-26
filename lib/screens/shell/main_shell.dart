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
    ModulesDirectorySheet(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.deepNavy,
          unselectedItemColor: AppColors.textSecondaryLight,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard, color: AppColors.deepNavy),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people, color: AppColors.deepNavy),
              label: 'Clients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fact_check_outlined),
              activeIcon: Icon(Icons.fact_check, color: AppColors.deepNavy),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_boat_outlined),
              activeIcon: Icon(Icons.directions_boat, color: AppColors.deepNavy),
              label: 'Tracking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view, color: AppColors.tradeTeal),
              label: 'All 25 Modules',
            ),
          ],
        ),
      ),
    );
  }
}
