import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class DisputeArbitrationScreen extends StatefulWidget {
  const DisputeArbitrationScreen({super.key});

  @override
  State<DisputeArbitrationScreen> createState() => _DisputeArbitrationScreenState();
}

class _DisputeArbitrationScreenState extends State<DisputeArbitrationScreen> {
  String _selectedStatus = 'All';

  void _showFileDisputeDialog() {
    final orderCtrl = TextEditingController(text: 'ORD-5531');
    final claimCtrl = TextEditingController(text: '4500.00');
    final reasonCtrl = TextEditingController(text: 'Quality specification variance in cargo shipment');
    String disputeType = 'Quality Defect';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.alertRed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.gavel, color: AppColors.alertRed, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'File Trade Dispute / Claim',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary),
                      ),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Submits formal claim to Chamber of Commerce & freezes contested escrow milestone.',
                style: TextStyle(fontSize: 12, color: context.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: orderCtrl,
                style: TextStyle(fontSize: 13, color: context.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Linked Contract / Order Number',
                  labelStyle: TextStyle(color: context.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: context.borderColor),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: claimCtrl,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 13, color: context.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Claim Amount (USD)',
                        labelStyle: TextStyle(color: context.textSecondary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: context.borderColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: disputeType,
                      dropdownColor: context.cardColor,
                      style: TextStyle(fontSize: 13, color: context.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Dispute Nature',
                        labelStyle: TextStyle(color: context.textSecondary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: context.borderColor),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(value: 'Quality Defect', child: Text('Quality Defect', style: TextStyle(color: context.textPrimary))),
                        DropdownMenuItem(value: 'Demurrage Delay', child: Text('Demurrage Delay', style: TextStyle(color: context.textPrimary))),
                        DropdownMenuItem(value: 'Short Shipment', child: Text('Short Shipment', style: TextStyle(color: context.textPrimary))),
                        DropdownMenuItem(value: 'Document Error', child: Text('Document Error', style: TextStyle(color: context.textPrimary))),
                      ],
                      onChanged: (val) => setSheetState(() => disputeType = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonCtrl,
                maxLines: 2,
                style: TextStyle(fontSize: 13, color: context.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Detailed Claim Rationale & Evidence Summary',
                  labelStyle: TextStyle(color: context.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: context.borderColor),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: () {
                  final state = TradeStateInherited.of(context);
                  final amt = double.tryParse(claimCtrl.text.trim()) ?? 4500.0;
                  final newDispute = TradeDisputeModel(
                    disputeId: 'disp-${DateTime.now().millisecondsSinceEpoch}',
                    disputeCode: 'DISP-${DateTime.now().millisecondsSinceEpoch % 1000}',
                    orderNumber: orderCtrl.text.trim().isEmpty ? 'ORD-5531' : orderCtrl.text.trim(),
                    complainant: state.currentUser.fullName,
                    respondent: 'Shenzhen Tech Ltd',
                    claimAmount: amt,
                    reason: reasonCtrl.text.trim(),
                    status: 'Active',
                    filedDate: 'Today',
                    escrowFrozenAmount: amt,
                    evidenceDocsCount: 2,
                  );
                  state.fileDispute(newDispute);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.shield, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('Claim ${newDispute.disputeCode} lodged. Contested escrow (\$${amt.toStringAsFixed(0)}) frozen safely.'),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.alertRed,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.alertRed,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.lock_clock, size: 18),
                label: const Text('Freeze Escrow & Lodge Claim', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettlementDialog(TradeDisputeModel dispute) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.cardColor,
        title: Row(
          children: [
            const Icon(Icons.balance, color: AppColors.tradeTeal, size: 24),
            const SizedBox(width: 8),
            Text(
              'Chamber Arbitration Settlement',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Case ${dispute.disputeCode} • Linked to ${dispute.orderNumber}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              'Claim of \$${dispute.claimAmount.toStringAsFixed(2)} filed for: ${dispute.reason}',
              style: TextStyle(fontSize: 12, color: context.textSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Contested Escrow', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                      Text('\$${dispute.escrowFrozenAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.alertRed)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SGS Inspection Evidence', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                      Text('${dispute.evidenceDocsCount} Certified Files', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tradeTeal)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: context.textSecondary)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              final state = TradeStateInherited.of(context);
              state.resolveDispute(dispute.disputeId, 'Resolved');
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Dispute ${dispute.disputeCode} settled via Chamber Arbitration!'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.handshake, size: 16),
            label: const Text('Execute Settlement'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final isDark = context.isDark;

    final filteredDisputes = state.disputes.where((d) {
      if (_selectedStatus == 'All') return true;
      return d.status == _selectedStatus;
    }).toList();

    final totalFrozen = state.disputes
        .where((d) => d.status != 'Resolved')
        .fold(0.0, (sum, d) => sum + d.escrowFrozenAmount);

    return Scaffold(
      backgroundColor: context.canvasColor,
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
        title: const Text('Trade Dispute & Arbitration Center'),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
          IconButton(
            icon: const Icon(Icons.add_moderator_outlined),
            tooltip: 'File Claim',
            onPressed: _showFileDisputeDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showFileDisputeDialog,
        backgroundColor: AppColors.alertRed,
        icon: const Icon(Icons.gavel, color: Colors.white, size: 20),
        label: const Text('Lodge Dispute', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Executive KPI Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Contested Escrow Under Hold', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                          const SizedBox(height: 2),
                          Text(
                            '\$${totalFrozen.toStringAsFixed(0)} USD',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: totalFrozen > 0 ? AppColors.alertRed : AppColors.successGreen,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.alertRed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline, color: AppColors.alertRed, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${state.disputes.where((d) => d.status == "Active").length} Active Claims',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.alertRed),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(height: 1, color: context.borderColor),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricItem('Resolution Rate', '94.2%', AppColors.successGreen, context),
                      Container(width: 1, height: 26, color: context.borderColor),
                      _buildMetricItem('Avg. Settled Time', '4.8 Days', AppColors.tradeTeal, context),
                      Container(width: 1, height: 26, color: context.borderColor),
                      _buildMetricItem('Chamber Cases', '${state.disputes.length}', isDark ? const Color(0xFF38BDF8) : AppColors.deepNavy, context),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Filter Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildStatusTab('All', isDark),
                  _buildStatusTab('Active', isDark),
                  _buildStatusTab('In Arbitration', isDark),
                  _buildStatusTab('Resolved', isDark),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Dispute Records List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredDisputes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final dispute = filteredDisputes[index];
                return _buildDisputeCard(dispute, context, isDark);
              },
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTab(String status, bool isDark) {
    final isSelected = _selectedStatus == status;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedStatus = status),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? AppColors.cardDark : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? Colors.white : AppColors.deepNavy)
                  : (isDark ? const Color(0xFF94A3B8) : AppColors.textSecondaryLight),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color, BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: context.textSecondary)),
      ],
    );
  }

  Widget _buildDisputeCard(TradeDisputeModel dispute, BuildContext context, bool isDark) {
    Color badgeColor;
    Color badgeBg;
    if (dispute.status == 'Active') {
      badgeColor = AppColors.alertRed;
      badgeBg = AppColors.alertRed.withValues(alpha: 0.15);
    } else if (dispute.status == 'In Arbitration') {
      badgeColor = AppColors.gold;
      badgeBg = AppColors.gold.withValues(alpha: 0.15);
    } else {
      badgeColor = AppColors.successGreen;
      badgeBg = AppColors.greenTint;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    dispute.disputeCode,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.textPrimary),
                  ),
                  const SizedBox(width: 8),
                  Text('• ${dispute.orderNumber}', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  dispute.status.toUpperCase(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            dispute.reason,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimary),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Claimed by', style: TextStyle(fontSize: 10, color: context.textSecondary)),
                  Text(dispute.complainant, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Claim Amount', style: TextStyle(fontSize: 10, color: context.textSecondary)),
                  Text('\$${dispute.claimAmount.toStringAsFixed(0)} USD', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.tradeTeal)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: context.borderColor),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.attachment, size: 14, color: AppColors.tradeTeal),
                  const SizedBox(width: 4),
                  Text(
                    '${dispute.evidenceDocsCount} Evidence Documents',
                    style: TextStyle(fontSize: 11, color: context.textSecondary),
                  ),
                ],
              ),
              if (dispute.status != 'Resolved')
                OutlinedButton(
                  onPressed: () => _showSettlementDialog(dispute),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    side: const BorderSide(color: AppColors.tradeTeal),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Arbitrate', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tradeTeal)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
