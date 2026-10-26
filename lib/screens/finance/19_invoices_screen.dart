import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  String _selectedStatus = 'All';

  void _showCreateInvoiceDialog() {
    final invNumController = TextEditingController(text: 'INV-2212');
    final clientController = TextEditingController(text: 'Shenzhen Tech Ltd');
    final amountController = TextEditingController(text: '18500');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Generate Trade Invoice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: invNumController, decoration: const InputDecoration(labelText: 'Invoice Number', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: clientController, decoration: const InputDecoration(labelText: 'Client Company', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (USD)', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invoice INV-2212 created and dispatched to client!'), backgroundColor: AppColors.successGreen),
              );
            },
            child: const Text('Create & Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);

    final filteredInvoices = state.invoices.where((inv) {
      if (_selectedStatus == 'All') return true;
      return inv.status == _selectedStatus;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('19. Trade & Commission Invoices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateInvoiceDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // KPI Summary Tiles
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(child: _buildKpiTile('Paid', '\$68K', AppColors.successGreen, AppColors.greenTint)),
                const SizedBox(width: 10),
                Expanded(child: _buildKpiTile('Unpaid', '\$21K', AppColors.gold, AppColors.goldTint)),
                const SizedBox(width: 10),
                Expanded(child: _buildKpiTile('Overdue', '\$6K', AppColors.alertRed, AppColors.redTint)),
              ],
            ),
          ),

          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusChip('All (${state.invoices.length})', 'All'),
                  const SizedBox(width: 8),
                  _buildStatusChip('Paid', 'Paid'),
                  const SizedBox(width: 8),
                  _buildStatusChip('Unpaid', 'Unpaid'),
                  const SizedBox(width: 8),
                  _buildStatusChip('Overdue', 'Overdue'),
                ],
              ),
            ),
          ),

          // Invoice Rows
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredInvoices.length,
              itemBuilder: (context, index) {
                final inv = filteredInvoices[index];
                return _buildInvoiceTile(inv);
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

  Widget _buildStatusChip(String label, String key) {
    final isSelected = _selectedStatus == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = key),
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

  Widget _buildInvoiceTile(InvoiceModel inv) {
    Color statusColor;
    Color statusTint;
    if (inv.status == 'Paid') {
      statusColor = AppColors.successGreen;
      statusTint = AppColors.greenTint;
    } else if (inv.status == 'Overdue') {
      statusColor = AppColors.alertRed;
      statusTint = AppColors.redTint;
    } else {
      statusColor = AppColors.gold;
      statusTint = AppColors.goldTint;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.receipt_long_outlined, color: AppColors.deepNavy, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(inv.invoiceNumber, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                    Text('\$${inv.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(inv.clientName, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
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
