import 'package:flutter/material.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../deal_cycle/10_quotation_builder_screen.dart';
import '../insights/23_notifications_screen.dart';
import '../logistics/14_shipment_tracking_screen.dart';
import '05_client_management_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${state.currentUser.fullName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            Row(
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
                  '${state.currentUser.companyName} • ${state.currentUser.accountTier}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
                ),
              ],
            ),
          ],
        ),
        actions: [
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
            // 4 Real-Time KPI Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'Active Deals',
                    value: '24',
                    badge: '+12%',
                    badgePositive: true,
                    icon: Icons.handshake_outlined,
                    iconColor: AppColors.tradeTeal,
                    tint: AppColors.tealTint,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Commission',
                    value: '\$12.4K',
                    badge: '+8%',
                    badgePositive: true,
                    icon: Icons.payments_outlined,
                    iconColor: AppColors.gold,
                    tint: AppColors.goldTint,
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
                    tint: AppColors.blueTint,
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
                    tint: AppColors.redTint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Actions Strip
            const Text(
              'Quick Deal Actions',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickActionBtn(
                    label: 'New Quote',
                    icon: Icons.add_circle_outline,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotationBuilderScreen())),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickActionBtn(
                    label: 'Track Container',
                    icon: Icons.radar_outlined,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShipmentTrackingScreen())),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickActionBtn(
                    label: 'Add Client',
                    icon: Icons.person_add_alt_1_outlined,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientManagementScreen())),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Monthly Commission 6-Month Bar Chart
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Commission Growth',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                          ),
                          Text(
                            'Last 6 months performance',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.tealTint,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '+14.2% MoM',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Interactive Custom Bar Chart
                  SizedBox(
                    height: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBar('May', 0.45, '\$6.2K'),
                        _buildBar('Jun', 0.60, '\$8.1K'),
                        _buildBar('Jul', 0.55, '\$7.4K'),
                        _buildBar('Aug', 0.75, '\$9.8K'),
                        _buildBar('Sep', 0.85, '\$10.8K'),
                        _buildBar('Oct', 1.00, '\$12.4K', isHighlighted: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recent Activity Feed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All', style: TextStyle(color: AppColors.tradeTeal, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _buildActivityItem(
              title: 'Quotation Accepted (Q-1042)',
              detail: 'Al Noor Traders approved 8,000 pcs LED panels • Commission \$1,235',
              time: '15m ago',
              icon: Icons.check_circle_outline,
              iconColor: AppColors.successGreen,
              tint: AppColors.greenTint,
            ),
            _buildActivityItem(
              title: 'Escrow Milestone Released',
              detail: 'ORD-5530 advance payment \$6,500 released to Mumbai Spices',
              time: '2h ago',
              icon: Icons.lock_open_outlined,
              iconColor: AppColors.gold,
              tint: AppColors.goldTint,
            ),
            _buildActivityItem(
              title: 'Vessel Departed Seaport',
              detail: 'MV Ocean Star carrying MSKU-7781452 departed Karachi for Jebel Ali',
              time: '4h ago',
              icon: Icons.directions_boat_outlined,
              iconColor: AppColors.oceanBlue,
              tint: AppColors.blueTint,
            ),
            _buildActivityItem(
              title: 'New Buyer RFQ (RFQ-2041)',
              detail: 'Incoming buyer request for 5,000 pcs LED Panel Light 40W',
              time: '1d ago',
              icon: Icons.mail_outline,
              iconColor: AppColors.tradeTeal,
              tint: AppColors.tealTint,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                  color: badgePositive ? AppColors.greenTint : AppColors.redTint,
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
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String month, double factor, String amount, {bool isHighlighted = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          amount,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: isHighlighted ? AppColors.tradeTeal : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 28,
          height: 80 * factor,
          decoration: BoxDecoration(
            color: isHighlighted ? AppColors.tradeTeal : const Color(0xFFCBD5E1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            gradient: isHighlighted
                ? const LinearGradient(
                    colors: [AppColors.tradeTeal, Color(0xFF0D827A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          month,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
            color: isHighlighted ? AppColors.deepNavy : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionBtn({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.tradeTeal),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String detail,
    required String time,
    required IconData icon,
    required Color iconColor,
    required Color tint,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
