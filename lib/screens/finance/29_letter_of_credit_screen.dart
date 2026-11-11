import 'package:flutter/material.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class LetterOfCreditScreen extends StatefulWidget {
  const LetterOfCreditScreen({super.key});

  @override
  State<LetterOfCreditScreen> createState() => _LetterOfCreditScreenState();
}

class _LetterOfCreditScreenState extends State<LetterOfCreditScreen> {
  String _selectedFilter = 'All';

  void _showDiscrepancyScanner() {
    final blPortCtrl = TextEditingController(text: 'Bremerhaven Port');
    final lcPortCtrl = TextEditingController(text: 'Port of Hamburg');
    final daysLateCtrl = TextEditingController(text: '3');
    bool partialShipment = true;
    bool transshipmentAllowed = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final hasPortMismatch = blPortCtrl.text.trim().toLowerCase() != lcPortCtrl.text.trim().toLowerCase();
          final lateDays = int.tryParse(daysLateCtrl.text.trim()) ?? 0;
          final discrepanciesFound = (hasPortMismatch ? 1 : 0) + (lateDays > 0 ? 1 : 0) + (!transshipmentAllowed ? 1 : 0);

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: context.borderColor, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.document_scanner_rounded, color: AppColors.gold, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'UCP 600 LC Discrepancy Scanner',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Detect document variance before negotiating shipping papers at the advising bank counter.',
                    style: TextStyle(fontSize: 12, color: context.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: lcPortCtrl,
                    style: TextStyle(fontSize: 12, color: context.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Port of Discharge Stated in LC',
                      labelStyle: TextStyle(fontSize: 11, color: context.textSecondary),
                      filled: true,
                      fillColor: context.surfaceColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (_) => setSheetState(() {}),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: blPortCtrl,
                    style: TextStyle(fontSize: 12, color: context.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Port of Discharge Stated in Bill of Lading (B/L)',
                      labelStyle: TextStyle(fontSize: 11, color: context.textSecondary),
                      filled: true,
                      fillColor: context.surfaceColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (_) => setSheetState(() {}),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: daysLateCtrl,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 12, color: context.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Days past latest shipment date',
                            labelStyle: TextStyle(fontSize: 11, color: context.textSecondary),
                            filled: true,
                            fillColor: context.surfaceColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (_) => setSheetState(() {}),
                        ),
                      ),
                  Row(
                    children: [
                      Expanded(
                        child: FilterChip(
                          label: Text(partialShipment ? 'Partial Allowed' : 'Partial Prohibited'),
                          selected: partialShipment,
                          selectedColor: AppColors.tradeTeal.withValues(alpha: 0.2),
                          onSelected: (val) => setSheetState(() => partialShipment = val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilterChip(
                          label: Text(transshipmentAllowed ? 'Transshipment OK' : 'No Transshipment'),
                          selected: transshipmentAllowed,
                          selectedColor: AppColors.tradeTeal.withValues(alpha: 0.2),
                          onSelected: (val) => setSheetState(() => transshipmentAllowed = val),
                        ),
                      ),
                    ],
                  ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: discrepanciesFound > 0
                          ? AppColors.alertRed.withValues(alpha: 0.1)
                          : AppColors.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: discrepanciesFound > 0 ? AppColors.alertRed : AppColors.successGreen,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              discrepanciesFound > 0 ? Icons.error_outline : Icons.check_circle_outline,
                              color: discrepanciesFound > 0 ? AppColors.alertRed : AppColors.successGreen,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              discrepanciesFound > 0
                                  ? '$discrepanciesFound High-Risk Discrepancies Found'
                                  : 'UCP 600 Compliant: Clean Presentation',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: discrepanciesFound > 0 ? AppColors.alertRed : AppColors.successGreen,
                              ),
                            ),
                          ],
                        ),
                        if (hasPortMismatch) ...[
                          const SizedBox(height: 6),
                          Text(
                            '• Article 14(d): Port mismatch (${blPortCtrl.text} vs ${lcPortCtrl.text}) will cause bank refusal.',
                            style: TextStyle(fontSize: 11, color: context.textPrimary),
                          ),
                        ],
                        if (lateDays > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            '• Article 14(c): Late presentation or shipment exceeds latest allowable date by $lateDays days.',
                            style: TextStyle(fontSize: 11, color: context.textPrimary),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showAmendmentDialog(lcPortCtrl.text, blPortCtrl.text);
                      },
                      icon: const Icon(Icons.edit_note, size: 18, color: Colors.white),
                      label: const Text('Draft LC Amendment Request', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepNavy,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAmendmentDialog(String originalPort, String amendmentPort) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.published_with_changes_rounded, color: AppColors.tradeTeal, size: 22),
            const SizedBox(width: 8),
            Text(
              'LC Amendment Request',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Proposed Swift MT707 Amendment:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textPrimary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.borderColor),
              ),
              child: Text(
                'FIELD 44B (Port of Discharge): Amend from "$originalPort" to "$amendmentPort". All other terms and conditions remain unchanged under UCP 600.',
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Amendment Fee: \$120.00 (Standard issuing bank debit)',
              style: TextStyle(fontSize: 11, color: context.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: context.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('SWIFT MT707 amendment dispatch submitted to applicant issuing bank.'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tradeTeal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Dispatch SWIFT MT707', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final lcs = state.lettersOfCredit.where((lc) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Clean') return lc.status.contains('Clean');
      if (_selectedFilter == 'Discrepancy') return lc.status.contains('Discrepancy');
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: AppBar(
        title: const Text('Letters of Credit (LC) Advisor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.document_scanner, color: Colors.white),
            tooltip: 'UCP 600 Discrepancy Scanner',
            onPressed: _showDiscrepancyScanner,
          ),
          const ThemeToggleButton(transparentBackground: true),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Trade Finance Overview Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: context.isDark ? 0.35 : 0.12),
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
                              color: AppColors.gold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.account_balance, color: AppColors.gold, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Active LC Trade Vault',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'UCP 600 GOVERNED',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.successGreen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderStat('Total LC Value', '\$238,500', '3 Contracts'),
                      _buildHeaderStat('Discrepancy Rate', '33.3%', '1 Flagged'),
                      _buildHeaderStat('Average Expiry', '32 Days', 'Clean Cover'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Filter Chips & Scanner Callout
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: ['All', 'Clean', 'Discrepancy'].map((f) {
                      final isSel = _selectedFilter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f),
                          selected: isSel,
                          selectedColor: AppColors.deepNavy,
                          backgroundColor: context.surfaceColor,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel ? Colors.white : context.textPrimary,
                          ),
                          side: BorderSide(color: isSel ? AppColors.deepNavy : context.borderColor),
                          onSelected: (_) => setState(() => _selectedFilter = f),
                        ),
                      );
                    }).toList(),
                  ),
                  TextButton.icon(
                    onPressed: _showDiscrepancyScanner,
                    icon: const Icon(Icons.scanner, size: 16, color: AppColors.tradeTeal),
                    label: const Text('Scan Discrepancy', style: TextStyle(fontSize: 12, color: AppColors.tradeTeal)),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // LC Cards List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, idx) {
                final lc = lcs[idx];
                final hasDiscrepancy = lc.status.contains('Discrepancy');

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: hasDiscrepancy ? AppColors.alertRed.withValues(alpha: 0.5) : context.borderColor,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                                    color: AppColors.deepNavy.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    lc.lcNumber,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.deepNavy,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  lc.incoterm,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.textSecondary),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (hasDiscrepancy ? AppColors.alertRed : AppColors.successGreen).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                lc.status,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: hasDiscrepancy ? AppColors.alertRed : AppColors.successGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Issuing Bank: ${lc.issuingBank}',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: context.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Applicant: ${lc.applicant} • Beneficiary: ${lc.beneficiary}',
                          style: TextStyle(fontSize: 11, color: context.textSecondary),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoCol('Document Value', '${lc.currency} ${lc.amount.toStringAsFixed(0)}'),
                            _buildInfoCol('Latest Shipment', lc.latestShipmentDate),
                            _buildInfoCol('LC Expiry Date', lc.expiryDate),
                          ],
                        ),
                        if (lc.discrepancies.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.alertRed.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.alertRed.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.warning, size: 14, color: AppColors.alertRed),
                                    SizedBox(width: 6),
                                    Text(
                                      'UCP 600 Bank Discrepancy Warnings:',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.alertRed),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ...lc.discrepancies.map((d) => Text('• $d', style: TextStyle(fontSize: 11, color: context.textPrimary))),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
              childCount: lcs.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
        Text(sub, style: const TextStyle(fontSize: 9, color: Color(0xFF4ADE80), fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildInfoCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: context.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textPrimary)),
      ],
    );
  }
}
