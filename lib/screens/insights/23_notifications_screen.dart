import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);

    final filteredNotifs = state.notifications.where((n) {
      if (_selectedCategory == 'All') return true;
      return n.category == _selectedCategory;
    }).toList();

    final todayNotifs = filteredNotifs.where((n) => n.group == 'Today').toList();
    final earlierNotifs = filteredNotifs.where((n) => n.group == 'Earlier').toList();

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
          tooltip: 'Back to Dashboard',
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Notifications & Alerts'),
        actions: [
          TextButton(
            onPressed: () => state.markAllNotificationsRead(),
            child: const Text('Mark all read', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('All (${state.notifications.length})', 'All'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Orders', 'Orders'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Payments', 'Payments'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('System Alerts', 'System'),
                ],
              ),
            ),
          ),

          // Notification Groups
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (todayNotifs.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('TODAY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondaryLight, letterSpacing: 0.5)),
                  ),
                  ...todayNotifs.map((n) => _buildNotifCard(n)),
                  const SizedBox(height: 16),
                ],
                if (earlierNotifs.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('EARLIER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondaryLight, letterSpacing: 0.5)),
                  ),
                  ...earlierNotifs.map((n) => _buildNotifCard(n)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String key) {
    final isSelected = _selectedCategory == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepNavy : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildNotifCard(NotificationModel n) {
    IconData icon;
    Color iconColor;
    Color iconTint;

    if (n.category == 'Payments') {
      icon = Icons.payments_outlined;
      iconColor = AppColors.successGreen;
      iconTint = AppColors.greenTint;
    } else if (n.title.contains('overdue') || n.title.contains('rejected')) {
      icon = Icons.warning_amber_rounded;
      iconColor = AppColors.alertRed;
      iconTint = AppColors.redTint;
    } else {
      icon = Icons.local_shipping_outlined;
      iconColor = AppColors.tradeTeal;
      iconTint = AppColors.tealTint;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: n.isRead ? Colors.white : AppColors.tealTint.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: n.isRead ? const Color(0xFFE2E8F0) : AppColors.tradeTeal.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconTint, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
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
                        n.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w800,
                          color: AppColors.deepNavy,
                        ),
                      ),
                    ),
                    Text(n.timeAgo, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  n.detail,
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
