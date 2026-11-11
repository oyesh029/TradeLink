import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  String _selectedStatus = 'All';

  void _showCreateInvoiceDialog() {
    final clientController = TextEditingController(text: 'Al Noor Traders');
    final amountController = TextEditingController(text: '12400');
    final dueController = TextEditingController(text: 'Due: 28 Nov 2026');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Generate Trade Invoice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: clientController, decoration: const InputDecoration(labelText: 'Client Name')),
            const SizedBox(height: 8),
            TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (USD)')),
            const SizedBox(height: 8),
            TextField(controller: dueController, decoration: const InputDecoration(labelText: 'Due Date')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newInv = InvoiceModel(
                invoiceId: 'inv-${DateTime.now().millisecondsSinceEpoch}',
                invoiceNumber: 'INV-${DateTime.now().millisecondsSinceEpoch % 10000}',
                clientName: clientController.text.trim().isEmpty ? 'Al Noor Traders LLC' : clientController.text.trim(),
                amount: double.tryParse(amountController.text) ?? 5000.0,
                status: 'Unpaid',
                issueDate: 'Today',
                dueDate: dueController.text.trim().isEmpty ? 'Due 30 Oct 2026' : dueController.text.trim(),
              );
              final state = TradeStateInherited.of(context);
              state.addInvoice(newInv);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invoice ${newInv.invoiceNumber} generated!')),
              );
            },
            child: const Text('Generate & Send'),
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
    final surfaceBg = isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9);

    final filteredInvoices = state.invoices.where((inv) {
      if (_selectedStatus == 'All') return true;
      return inv.status == _selectedStatus;
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
        title: const Text('Invoices'),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateInvoiceDialog,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // KPI Summary Tiles
          Container(
            color: cardBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(child: _buildKpiTile('Paid', '\$68K', AppColors.successGreen, isDark ? AppColors.successGreen.withValues(alpha: 0.15) : AppColors.greenTint)),
                const SizedBox(width: 10),
                Expanded(child: _buildKpiTile('Unpaid', '\$21K', AppColors.gold, isDark ? AppColors.gold.withValues(alpha: 0.15) : AppColors.goldTint)),
                const SizedBox(width: 10),
                Expanded(child: _buildKpiTile('Overdue', '\$6K', AppColors.alertRed, isDark ? AppColors.alertRed.withValues(alpha: 0.15) : AppColors.redTint)),
              ],
            ),
          ),

          // Filter Tabs
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusChip('All (${state.invoices.length})', 'All', cardBg, borderColor, textSecondary),
                  const SizedBox(width: 8),
                  _buildStatusChip('Paid', 'Paid', cardBg, borderColor, textSecondary),
                  const SizedBox(width: 8),
                  _buildStatusChip('Unpaid', 'Unpaid', cardBg, borderColor, textSecondary),
                  const SizedBox(width: 8),
                  _buildStatusChip('Overdue', 'Overdue', cardBg, borderColor, textSecondary),
                ],
              ),
            ),
          ),

          // Invoice Rows
          Expanded(
            child: filteredInvoices.isEmpty
                ? Center(
                    child: Text('No invoices in this category.', style: TextStyle(color: textSecondary)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredInvoices.length,
                    itemBuilder: (context, index) {
                      final inv = filteredInvoices[index];
                      return _buildInvoiceTile(inv, cardBg, borderColor, textPrimary, textSecondary, surfaceBg, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiTile(String label, String amount, Color color, Color tint) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String key, Color cardBg, Color borderColor, Color textSecondary) {
    final isSelected = _selectedStatus == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = key),
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

  Widget _buildInvoiceTile(
    InvoiceModel inv,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    Color surfaceBg,
    bool isDark,
  ) {
    Color statusColor;
    Color statusTint;
    if (inv.status == 'Paid') {
      statusColor = AppColors.successGreen;
      statusTint = isDark ? AppColors.successGreen.withValues(alpha: 0.15) : AppColors.greenTint;
    } else if (inv.status == 'Overdue') {
      statusColor = AppColors.alertRed;
      statusTint = isDark ? AppColors.alertRed.withValues(alpha: 0.15) : AppColors.redTint;
    } else {
      statusColor = AppColors.gold;
      statusTint = isDark ? AppColors.gold.withValues(alpha: 0.15) : AppColors.goldTint;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            decoration: BoxDecoration(color: surfaceBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.receipt_long_outlined, color: isDark ? const Color(0xFF93C5FD) : AppColors.deepNavy, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(inv.invoiceNumber, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textPrimary)),
                    Text('\$${inv.amount.toStringAsFixed(0)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimary)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(inv.clientName, style: TextStyle(fontSize: 12, color: textSecondary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: statusTint, borderRadius: BorderRadius.circular(8)),
                      child: Text(inv.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: statusColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(inv.dueDate, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
