import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';

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
        title: const Text('Export Earnings Ledger'),
        content: const Text('Export itemized commission reconciliation ledger for October 2026 as Excel (.xlsx) or audit PDF (.pdf)?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported Excel ledger report!')));
            },
            child: const Text('Excel (.xlsx)'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported PDF ledger report!')));
            },
            child: const Text('PDF Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);

    final filteredEntries = state.ledgerEntries.where((e) {
      if (_selectedFilter == 'All') return true;
      return e.status == _selectedFilter;
    }).toList();

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
        title: const Text('Earnings Ledger'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: _exportReport,
          ),
        ],
      ),
      body: Column(
        children: [
          // Monthly Earnings KPI Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.deepNavy, Color(0xFF16325C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepNavy.withValues(alpha: 0.2),
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
                      'Total Earnings (October 2026)',
                      style: TextStyle(fontSize: 13, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.tradeTeal.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '+14.2% vs Sept',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
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
                _buildFilterChip('All Entries', 'All'),
                const SizedBox(width: 8),
                _buildFilterChip('Received / Paid', 'Paid'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending Due', 'Pending'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Transaction Rows
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredEntries.length,
              itemBuilder: (context, index) {
                final entry = filteredEntries[index];
                return _buildLedgerTile(entry);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String key) {
    final isSelected = _selectedFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepNavy : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.deepNavy : const Color(0xFFE2E8F0)),
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

  Widget _buildLedgerTile(LedgerEntryModel entry) {
    final isPaid = entry.status == 'Paid';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPaid ? AppColors.greenTint : AppColors.goldTint,
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
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                    ),
                    Text(
                      '+ \$${entry.commissionAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isPaid ? AppColors.successGreen : AppColors.deepNavy,
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
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                    ),
                    Text(
                      entry.dateText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isPaid ? AppColors.textSecondaryLight : AppColors.gold,
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
