import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.deepNavy;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final filteredNotifs = state.notifications.where((n) {
      if (_selectedCategory == 'All') return true;
      return n.category == _selectedCategory;
    }).toList();

    final todayNotifs = filteredNotifs.where((n) => n.group == 'Today').toList();
    final earlierNotifs = filteredNotifs.where((n) => n.group == 'Earlier').toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
          tooltip: 'Back',
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Notifications & Alerts'),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
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
            color: cardBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('All (${state.notifications.length})', 'All', cardBg, borderColor, textSecondary),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Orders', 'Orders', cardBg, borderColor, textSecondary),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Payments', 'Payments', cardBg, borderColor, textSecondary),
                  const SizedBox(width: 8),
                  _buildCategoryChip('System Alerts', 'System', cardBg, borderColor, textSecondary),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('TODAY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textSecondary, letterSpacing: 0.5)),
                  ),
                  ...todayNotifs.map((n) => _buildNotifCard(n, cardBg, borderColor, textPrimary, textSecondary, isDark)),
                  const SizedBox(height: 16),
                ],
                if (earlierNotifs.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('EARLIER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textSecondary, letterSpacing: 0.5)),
                  ),
                  ...earlierNotifs.map((n) => _buildNotifCard(n, cardBg, borderColor, textPrimary, textSecondary, isDark)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String key, Color cardBg, Color borderColor, Color textSecondary) {
    final isSelected = _selectedCategory == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tradeTeal : cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.tradeTeal : borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildNotifCard(
    NotificationModel n,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    IconData icon;
    Color iconColor;
    Color iconTint;

    if (n.category == 'Payments') {
      icon = Icons.payments_outlined;
      iconColor = AppColors.successGreen;
      iconTint = isDark ? AppColors.successGreen.withValues(alpha: 0.15) : AppColors.greenTint;
    } else if (n.title.contains('overdue') || n.title.contains('rejected')) {
      icon = Icons.warning_amber_rounded;
      iconColor = AppColors.alertRed;
      iconTint = isDark ? AppColors.alertRed.withValues(alpha: 0.15) : AppColors.redTint;
    } else {
      icon = Icons.local_shipping_outlined;
      iconColor = AppColors.tradeTeal;
      iconTint = isDark ? AppColors.tradeTeal.withValues(alpha: 0.15) : AppColors.tealTint;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: n.isRead ? cardBg : (isDark ? const Color(0xFF1E3A5F).withValues(alpha: 0.3) : AppColors.tealTint.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: n.isRead ? borderColor : AppColors.tradeTeal.withValues(alpha: 0.4)),
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
                          color: textPrimary,
                        ),
                      ),
                    ),
                    Text(n.timeAgo, style: TextStyle(fontSize: 10, color: textSecondary)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  n.detail,
                  style: TextStyle(fontSize: 12, color: textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
