import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '05_client_management_screen.dart';
import '../deal_cycle/10_quotation_builder_screen.dart';
import '../deal_cycle/13_order_details_screen.dart';
import '../logistics/14_shipment_tracking_screen.dart';
import '../finance/17_commission_calculator_screen.dart';
import '../finance/21_currency_rates_screen.dart';
import '../insights/23_notifications_screen.dart';
import '../insights/25_settings_profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedGrowthPeriod = '6M';
  int _selectedMonthIndex = 5; // Default to latest month (Oct)
  String _selectedActivityFilter = 'All';

  final List<Map<String, dynamic>> _monthlyData = [
    {'month': 'May', 'factor': 0.50, 'value': '\$6,200', 'deals': 14, 'volume': '\$248K'},
    {'month': 'Jun', 'factor': 0.65, 'value': '\$8,100', 'deals': 18, 'volume': '\$324K'},
    {'month': 'Jul', 'factor': 0.60, 'value': '\$7,400', 'deals': 16, 'volume': '\$296K'},
    {'month': 'Aug', 'factor': 0.78, 'value': '\$9,800', 'deals': 21, 'volume': '\$392K'},
    {'month': 'Sep', 'factor': 0.86, 'value': '\$10,800', 'deals': 23, 'volume': '\$432K'},
    {'month': 'Oct', 'factor': 1.00, 'value': '\$12,430', 'deals': 26, 'volume': '\$497K'},
  ];

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final user = state.currentUser;
    final primaryOrder = state.orders.isNotEmpty ? state.orders.first : null;
    final activeShipment = state.activeShipment;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.deepNavy;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final surfaceBg = isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9);

    final selectedMonthData = _monthlyData[_selectedMonthIndex];

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        title: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsProfileScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hi, ${user.fullName}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFFCBD5E1)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${user.companyName} • ${user.role == UserRole.agent ? 'Commission Agent' : user.role == UserRole.importer ? 'Importer / Buyer' : 'Exporter / Supplier'}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined, size: 24),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.alertRed,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${state.notifications.where((n) => !n.isRead).length}',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4 Real-Time Executive KPI Cards
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: user.role == UserRole.importer ? 'Active Orders' : 'Active Deals',
                    value: '24',
                    badge: '+12%',
                    badgePositive: true,
                    icon: Icons.handshake_outlined,
                    iconColor: AppColors.tradeTeal,
                    tint: isDark ? AppColors.tradeTeal.withValues(alpha: 0.18) : AppColors.tealTint,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: user.role == UserRole.importer ? 'Trade Spend' : 'Commission',
                    value: user.role == UserRole.importer ? '\$240K' : '\$12.4K',
                    badge: '+8%',
                    badgePositive: true,
                    icon: Icons.payments_outlined,
                    iconColor: AppColors.gold,
                    tint: isDark ? AppColors.gold.withValues(alpha: 0.18) : AppColors.goldTint,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'In Transit',
                    value: '9',
                    badge: '4 Ports',
                    badgePositive: true,
                    icon: Icons.directions_boat_outlined,
                    iconColor: AppColors.oceanBlue,
                    tint: isDark ? AppColors.oceanBlue.withValues(alpha: 0.18) : AppColors.blueTint,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Pending Docs',
                    value: '6',
                    badge: '2 Urgent',
                    badgePositive: false,
                    icon: Icons.description_outlined,
                    iconColor: AppColors.alertRed,
                    tint: isDark ? AppColors.alertRed.withValues(alpha: 0.18) : AppColors.redTint,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Operations / Shortcuts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                ),
                Text(
                  'One-tap operations',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickActionBtn(
                    title: 'New Quote',
                    icon: Icons.calculate_rounded,
                    iconColor: AppColors.gold,
                    tint: isDark ? AppColors.gold.withValues(alpha: 0.15) : AppColors.goldTint,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionBtn(
                    title: 'Add Client',
                    icon: Icons.person_add_alt_1_rounded,
                    iconColor: AppColors.tradeTeal,
                    tint: isDark ? AppColors.tradeTeal.withValues(alpha: 0.15) : AppColors.tealTint,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientManagementScreen()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionBtn(
                    title: 'Track Cargo',
                    icon: Icons.directions_boat_rounded,
                    iconColor: AppColors.oceanBlue,
                    tint: isDark ? AppColors.oceanBlue.withValues(alpha: 0.15) : AppColors.blueTint,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ShipmentTrackingScreen()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionBtn(
                    title: 'Commission',
                    icon: Icons.pie_chart_rounded,
                    iconColor: AppColors.successGreen,
                    tint: isDark ? AppColors.successGreen.withValues(alpha: 0.15) : AppColors.greenTint,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CommissionCalculatorScreen()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionBtn(
                    title: 'Live FX',
                    icon: Icons.currency_exchange_rounded,
                    iconColor: AppColors.tradeTeal,
                    tint: isDark ? AppColors.tradeTeal.withValues(alpha: 0.15) : const Color(0xFFF1F5F9),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CurrencyRatesScreen()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Active Contract Spotlight Card
            if (primaryOrder != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.tradeTeal.withValues(alpha: 0.2) : AppColors.tealTint,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                primaryOrder.orderId,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.tradeTeal,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Active Contract Spotlight',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.oceanBlue.withValues(alpha: 0.2) : const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            primaryOrder.status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF93C5FD) : AppColors.oceanBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${primaryOrder.buyerName} • ${primaryOrder.productSummary}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Contract Value: \$${primaryOrder.orderValue.toStringAsFixed(0)} • Net Commission: \$${primaryOrder.agentCommission.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 12, color: textSecondary),
                    ),
                    const SizedBox(height: 12),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: primaryOrder.progressPct / 100.0,
                        minHeight: 6,
                        backgroundColor: isDark ? const Color(0xFF2E3856) : const Color(0xFFF1F5F9),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.tradeTeal),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Milestone: ${primaryOrder.milestones.lastWhere((m) => m.isCompleted, orElse: () => primaryOrder.milestones.first).title}',
                          style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: primaryOrder)),
                            );
                          },
                          child: const Row(
                            children: [
                              Text(
                                'View Contract',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.tradeTeal),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Active Maritime Shipment Radar Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF0F1E36), const Color(0xFF162B4D)]
                      : [const Color(0xFF0F2B48), const Color(0xFF1E3A5F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF2B4365) : Colors.transparent,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.directions_boat_filled, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            activeShipment.containerNumber,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.tradeTeal.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.tradeTeal.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          activeShipment.status,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF5EEAD4)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Vessel: ${activeShipment.vesselName} (${activeShipment.containerType})',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Route: ${activeShipment.originPort} → ${activeShipment.destinationPort} • ETA in 2 days',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ShipmentTrackingScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined, size: 14, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Open Vessel AIS Route Map',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // HIGH-END COMMISSION & REVENUE ANALYTICS PANEL (HIGH FIDELITY)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row with Timeframe Switcher
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Commission Growth',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Trailing performance & revenue pace',
                            style: TextStyle(fontSize: 12, color: textSecondary),
                          ),
                        ],
                      ),
                      // Timeframe Switcher (3M, 6M, 1Y)
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: surfaceBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: ['3M', '6M', '1Y'].map((period) {
                            final isSel = _selectedGrowthPeriod == period;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedGrowthPeriod = period),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.tradeTeal : Colors.transparent,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  period,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                    color: isSel ? Colors.white : textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Mini Metric Strip inside Panel
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: surfaceBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Oct Revenue', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('\$12,430', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                          ],
                        ),
                        Container(width: 1, height: 26, color: borderColor),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MoM Delta', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            const Text('+14.2%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.successGreen)),
                          ],
                        ),
                        Container(width: 1, height: 26, color: borderColor),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Avg Rate', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('2.5% CIF', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
                          ],
                        ),
                        Container(width: 1, height: 26, color: borderColor),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Volume', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('26 Deals', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Target Baseline Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.tradeTeal,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Selected: ${selectedMonthData['month']} (${selectedMonthData['value']} • ${selectedMonthData['deals']} Deals)',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                          ),
                        ],
                      ),
                      Text(
                        'Target: \$10,000/mo',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Interactive Custom Bar Chart Canvas
                  SizedBox(
                    height: 135,
                    child: Stack(
                      children: [
                        // Dotted target horizontal line at ~80%
                        Positioned(
                          top: 30,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: borderColor.withValues(alpha: 0.8),
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Bars Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(_monthlyData.length, (idx) {
                            final item = _monthlyData[idx];
                            final isSel = _selectedMonthIndex == idx;
                            final isOct = idx == 5;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedMonthIndex = idx),
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Month value tag
                                  Text(
                                    item['value'],
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                      color: isSel ? AppColors.tradeTeal : textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // The Bar Container
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: isSel ? 28 : 22,
                                    height: 85 * (item['factor'] as double),
                                    decoration: BoxDecoration(
                                      gradient: isOct
                                          ? const LinearGradient(
                                              colors: [AppColors.tradeTeal, Color(0xFF0F766E)],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            )
                                          : isSel
                                              ? const LinearGradient(
                                                  colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                )
                                              : null,
                                      color: (!isOct && !isSel)
                                          ? (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1))
                                          : null,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: isSel
                                          ? [
                                              BoxShadow(
                                                color: AppColors.tradeTeal.withValues(alpha: 0.35),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : [],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['month'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                                      color: isSel ? textPrimary : textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Reconciliation Summary Footer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: surfaceBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shield_outlined, size: 14, color: AppColors.tradeTeal),
                            const SizedBox(width: 6),
                            Text(
                              'Gross GMV: ${selectedMonthData['volume']}',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textPrimary),
                            ),
                          ],
                        ),
                        Text(
                          'Net Payout (90%): \$${((itemToNumber(selectedMonthData['value']) * 0.9)).toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.successGreen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // HIGH-END RECENT ACTIVITY & AUDIT FEED (HIGH FIDELITY)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Live deals, escrow releases & vessel events',
                      style: TextStyle(fontSize: 12, color: textSecondary),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                    );
                  },
                  icon: const Icon(Icons.history_rounded, size: 16, color: AppColors.tradeTeal),
                  label: const Text(
                    'Full Feed',
                    style: TextStyle(color: AppColors.tradeTeal, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Filter Chips Row for Activities
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Deals', 'Escrow', 'Logistics'].map((filter) {
                  final isSel = _selectedActivityFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedActivityFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.tradeTeal : cardBg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: isSel ? AppColors.tradeTeal : borderColor),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel ? Colors.white : textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Audit Feed Cards
            _buildProActivityItem(
              title: 'Quotation Approved',
              refCode: 'Q-1042',
              partner: 'Al Noor Traders (Dubai, UAE)',
              detail: 'Approved 8,000 pcs LED panels • \$98,400 CIF Dubai',
              amountBadge: '+\$1,235 Commission',
              amountColor: AppColors.successGreen,
              time: '15m ago',
              icon: Icons.check_circle_outline_rounded,
              iconColor: AppColors.successGreen,
              accentColor: AppColors.successGreen,
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              surfaceBg: surfaceBg,
            ),
            _buildProActivityItem(
              title: 'Escrow Milestone Released',
              refCode: 'ORD-5530',
              partner: 'Mumbai Spices & Exports',
              detail: '50% advance milestone \$6,500 disbursed upon B/L verification',
              amountBadge: '\$6,500 Released',
              amountColor: AppColors.gold,
              time: '2h ago',
              icon: Icons.lock_open_rounded,
              iconColor: AppColors.gold,
              accentColor: AppColors.gold,
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              surfaceBg: surfaceBg,
            ),
            _buildProActivityItem(
              title: 'Vessel Departed Seaport',
              refCode: 'MSKU-7781452',
              partner: 'MV Ocean Star (Maersk Line)',
              detail: 'Departed Port Qasim, Karachi. En route to Jebel Ali. ETA Nov 09.',
              amountBadge: 'In Transit',
              amountColor: AppColors.oceanBlue,
              time: '4h ago',
              icon: Icons.directions_boat_filled_rounded,
              iconColor: AppColors.oceanBlue,
              accentColor: AppColors.oceanBlue,
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              surfaceBg: surfaceBg,
            ),
            _buildProActivityItem(
              title: 'Customs HS Tariff Cleared',
              refCode: 'HS-9405.42',
              partner: 'Pakistan Single Window (PSW)',
              detail: '5-point compliance validated: 0% customs duty waiver recognized',
              amountBadge: 'PSW Verified',
              amountColor: AppColors.tradeTeal,
              time: '6h ago',
              icon: Icons.policy_rounded,
              iconColor: AppColors.tradeTeal,
              accentColor: AppColors.tradeTeal,
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              surfaceBg: surfaceBg,
            ),
          ],
        ),
      ),
    );
  }

  double itemToNumber(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 10000.0;
  }

  Widget _buildQuickActionBtn({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color tint,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 86,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 7),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String badge,
    required bool badgePositive,
    required IconData icon,
    required Color iconColor,
    required Color tint,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: badgePositive
                      ? AppColors.successGreen.withValues(alpha: 0.15)
                      : AppColors.alertRed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: badgePositive ? AppColors.successGreen : AppColors.alertRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProActivityItem({
    required String title,
    required String refCode,
    required String partner,
    required String detail,
    required String amountBadge,
    required Color amountColor,
    required String time,
    required IconData icon,
    required Color iconColor,
    required Color accentColor,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color surfaceBg,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored Vertical Accent Strip
              Container(
                width: 4,
                color: accentColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon container
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                      const SizedBox(width: 12),

                      // Activity Body
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textPrimary),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: surfaceBg,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        refCode,
                                        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: textSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: amountColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    amountBadge,
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: amountColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              partner,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.tradeTeal),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              detail,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11, color: textSecondary),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded, size: 11, color: textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  time,
                                  style: TextStyle(fontSize: 10, color: textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
