import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class EarningsLedgerScreen extends StatefulWidget {
  const EarningsLedgerScreen({super.key});

  @override
  State<EarningsLedgerScreen> createState() => _EarningsLedgerScreenState();
}

class _EarningsLedgerScreenState extends State<EarningsLedgerScreen> {
  String _selectedFilter = 'All';

  void _exportReport() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export Commission Ledger'),
        content: const Text('Generate compliant Excel / PDF reconciliation statement for tax and audit reporting?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ledger export generated: TradeLink_Earnings_Oct2026.pdf'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            child: const Text('Export Statement'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.deepNavy;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final filteredEntries = state.ledgerEntries.where((e) {
      if (_selectedFilter == 'All') return true;
      return e.status == _selectedFilter;
    }).toList();

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
        title: const Text('Earnings Ledger'),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: _exportReport,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Monthly Earnings KPI Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0F1E36), const Color(0xFF1E293B)]
                    : [AppColors.deepNavy, const Color(0xFF16325C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF2B4365) : Colors.transparent),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.15),
                  blurRadius: 12,
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
                    const Text(
                      'TOTAL REVENUE RECEIVABLE',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.8),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.tradeTeal.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '+14.2% MoM',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF5EEAD4)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${state.totalMonthlyEarnings.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF2E466E), height: 1),
                const SizedBox(height: 14),

                // Received vs Pending Breakdown
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.check_circle, size: 14, color: AppColors.successGreen),
                              SizedBox(width: 4),
                              Text('Settled / Received', style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${state.totalReceived.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 32, color: const Color(0xFF2E466E)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.pending, size: 14, color: AppColors.gold),
                              SizedBox(width: 4),
                              Text('Pending Milestone', style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${state.totalPending.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.gold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('All Entries', 'All', cardBg, borderColor, textSecondary),
                const SizedBox(width: 8),
                _buildFilterChip('Received / Paid', 'Paid', cardBg, borderColor, textSecondary),
                const SizedBox(width: 8),
                _buildFilterChip('Pending Due', 'Pending', cardBg, borderColor, textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Transaction Rows
          Expanded(
            child: filteredEntries.isEmpty
                ? Center(
                    child: Text('No ledger entries found.', style: TextStyle(color: textSecondary)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = filteredEntries[index];
                      return _buildLedgerTile(entry, cardBg, borderColor, textPrimary, textSecondary, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String key, Color cardBg, Color borderColor, Color textSecondary) {
    final isSelected = _selectedFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tradeTeal : cardBg,
          borderRadius: BorderRadius.circular(16),
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

  Widget _buildLedgerTile(
    LedgerEntryModel entry,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    final isPaid = entry.status == 'Paid';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPaid
                  ? (isDark ? AppColors.successGreen.withValues(alpha: 0.15) : AppColors.greenTint)
                  : (isDark ? AppColors.gold.withValues(alpha: 0.15) : AppColors.goldTint),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPaid ? Icons.arrow_downward : Icons.schedule,
              color: isPaid ? AppColors.successGreen : AppColors.gold,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.orderNumber,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textPrimary),
                    ),
                    Text(
                      '+ \$${entry.commissionAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isPaid ? AppColors.successGreen : textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${entry.clientName} • ${entry.paymentMethod}',
                      style: TextStyle(fontSize: 11, color: textSecondary),
                    ),
                    Text(
                      entry.dateText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isPaid ? textSecondary : AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
