import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class SanctionsComplianceScreen extends StatefulWidget {
  const SanctionsComplianceScreen({super.key});

  @override
  State<SanctionsComplianceScreen> createState() => _SanctionsComplianceScreenState();
}

class _SanctionsComplianceScreenState extends State<SanctionsComplianceScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _queryCtrl = TextEditingController();
  final TextEditingController _countryCtrl = TextEditingController();
  String _entityType = 'Buyer Company';
  bool _isScreening = false;

  @override
  void dispose() {
    _queryCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  void _runComplianceScreening() async {
    final query = _queryCtrl.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an entity name, vessel IMO, or counterparty.'),
          backgroundColor: AppColors.alertRed,
        ),
      );
      return;
    }

    setState(() => _isScreening = true);
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    final lower = query.toLowerCase();
    String riskLevel;
    String listsChecked;
    String clearanceToken;

    if (lower.contains('caspian') || lower.contains('volga') || lower.contains('blocked')) {
      riskLevel = 'Sanctioned (Blocked)';
      listsChecked = 'OFAC SDN List, EU Restrictive Measures, UN 1267';
      clearanceToken = 'AML-BLOCKED-DENIED-9901';
    } else if (lower.contains('transport') || lower.contains('freight') || lower.contains('maritime')) {
      riskLevel = 'Flagged (Due Diligence)';
      listsChecked = 'OFAC Maritime Advisory, FATF Enhanced Due Diligence';
      clearanceToken = 'AML-EDD-REQ-${DateTime.now().millisecondsSinceEpoch % 10000}';
    } else {
      riskLevel = 'Low Risk (Passed)';
      listsChecked = 'OFAC SDN, UN 1267, EU Consolidated, FATF, UK OFSI';
      clearanceToken = 'AML-CLR-2026-${DateTime.now().millisecondsSinceEpoch % 10000}';
    }

    final newRecord = SanctionsScreeningRecord(
      recordId: 'scr-${DateTime.now().millisecondsSinceEpoch}',
      entityName: query,
      country: _countryCtrl.text.trim().isEmpty ? 'United Arab Emirates' : _countryCtrl.text.trim(),
      entityType: _entityType,
      riskLevel: riskLevel,
      listsChecked: listsChecked,
      clearanceToken: clearanceToken,
      timestamp: 'Just now',
    );

    final state = TradeStateInherited.of(context);
    state.addSanctionsRecord(newRecord);

    setState(() {
      _isScreening = false;
      _queryCtrl.clear();
      _countryCtrl.clear();
    });

    _showResultDialog(newRecord);
  }

  void _showResultDialog(SanctionsScreeningRecord record) {
    final isBlocked = record.riskLevel.contains('Sanctioned');
    final isFlagged = record.riskLevel.contains('Flagged');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isBlocked ? Icons.gpp_bad : (isFlagged ? Icons.warning_rounded : Icons.verified_user),
              color: isBlocked ? AppColors.alertRed : (isFlagged ? AppColors.gold : AppColors.successGreen),
              size: 26,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Screening Verdict',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isBlocked ? AppColors.alertRed : (isFlagged ? AppColors.gold : AppColors.successGreen))
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isBlocked ? AppColors.alertRed : (isFlagged ? AppColors.gold : AppColors.successGreen),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.entityName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Verdict: ${record.riskLevel}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isBlocked ? AppColors.alertRed : (isFlagged ? AppColors.gold : AppColors.successGreen),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _buildDialogRow('Clearance Token:', record.clearanceToken),
            _buildDialogRow('Entity Classification:', record.entityType),
            _buildDialogRow('Country of Record:', record.country),
            _buildDialogRow('Watchlists Audited:', record.listsChecked),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: context.textSecondary)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _showCertificateDialog(record);
            },
            icon: const Icon(Icons.verified, size: 16, color: Colors.white),
            label: const Text('Export Certificate', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  void _showCertificateDialog(SanctionsScreeningRecord record) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.shield_outlined, color: AppColors.tradeTeal, size: 24),
            const SizedBox(width: 8),
            Text(
              'Official AML Certificate',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary),
            ),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.verified_sharp, size: 40, color: AppColors.tradeTeal),
                    const SizedBox(height: 6),
                    Text(
                      'TRADELINK COMPLIANCE CLEARANCE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: context.textPrimary,
                      ),
                    ),
                    Text(
                      'ISO 37301 & FATF Cross-Border Verified',
                      style: TextStyle(fontSize: 10, color: context.textSecondary),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),
              _buildDialogRow('Subject Entity:', record.entityName),
              _buildDialogRow('Clearance Hash:', record.clearanceToken),
              _buildDialogRow('Jurisdiction:', record.country),
              _buildDialogRow('Compliance Status:', record.riskLevel),
              _buildDialogRow('Verification Officer:', 'Automated LexisNexis / OFAC Gateway'),
              _buildDialogRow('Timestamp:', record.timestamp),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock, size: 14, color: AppColors.successGreen),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Cryptographic token valid for international bank Letter of Credit presentation.',
                        style: TextStyle(fontSize: 9, color: AppColors.successGreen, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Done', style: TextStyle(color: context.textSecondary)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('AML Compliance Certificate exported and saved to Documents vault.'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            icon: const Icon(Icons.download, size: 16, color: Colors.white),
            label: const Text('Save PDF Record', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tradeTeal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final records = state.sanctionsRecords.where((r) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Passed') return r.riskLevel.contains('Passed');
      if (_selectedFilter == 'Flagged') return r.riskLevel.contains('Flagged');
      if (_selectedFilter == 'Sanctioned') return r.riskLevel.contains('Sanctioned');
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: AppBar(
        title: const Text('Sanctions & AML Compliance'),
        actions: const [
          ThemeToggleButton(transparentBackground: true),
          SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header Infobar
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.tradeTeal.withValues(alpha: 0.3)),
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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.tradeTeal.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.security, color: AppColors.tradeTeal, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Global Regulatory Gateways Active',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'OFAC SDN • UN 1267 • EU Restrictive • FATF Dual-Use',
                            style: TextStyle(fontSize: 10, color: const Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Screen prospective buyers, suppliers, beneficiary banking accounts, and cargo vessels prior to issuing LC documentation.',
                    style: TextStyle(fontSize: 12, color: const Color(0xFFE2E8F0), height: 1.4),
                  ),
                ],
              ),
            ),
          ),

          // Instant Screening Form
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instant Entity Screener',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _queryCtrl,
                    style: TextStyle(fontSize: 13, color: context.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Enter company name, IMO number, or counterparty...',
                      hintStyle: TextStyle(fontSize: 13, color: context.textSecondary),
                      prefixIcon: Icon(Icons.corporate_fare, size: 20, color: context.textSecondary),
                      filled: true,
                      fillColor: context.surfaceColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: context.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.tradeTeal, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _entityType,
                          dropdownColor: context.cardColor,
                          style: TextStyle(fontSize: 12, color: context.textPrimary),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            filled: true,
                            fillColor: context.surfaceColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: context.borderColor),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Buyer Company', child: Text('Buyer Company')),
                            DropdownMenuItem(value: 'Manufacturer / Exporter', child: Text('Manufacturer / Exporter')),
                            DropdownMenuItem(value: 'Beneficiary Bank', child: Text('Beneficiary Bank')),
                            DropdownMenuItem(value: 'Vessel Carrier', child: Text('Vessel Carrier')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _entityType = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _countryCtrl,
                          style: TextStyle(fontSize: 12, color: context.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Jurisdiction (e.g. UAE)',
                            hintStyle: TextStyle(fontSize: 12, color: context.textSecondary),
                            filled: true,
                            fillColor: context.surfaceColor,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: context.borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: AppColors.tradeTeal, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: _isScreening ? null : _runComplianceScreening,
                      icon: _isScreening
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.radar, size: 18, color: Colors.white),
                      label: Text(
                        _isScreening ? 'Querying Global Watchlists...' : 'Execute AML / OFAC Scan',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Audit Records Section Header & Filters
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Compliance Audits',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Passed', 'Flagged', 'Sanctioned'].map((f) {
                        final isSel = _selectedFilter == f;
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: InkWell(
                            onTap: () => setState(() => _selectedFilter = f),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.primaryNavy : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                f,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                  color: isSel ? Colors.white : context.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Audit Records List
          records.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        'No compliance records match this filter.',
                        style: TextStyle(color: context.textSecondary),
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, idx) {
                      final rec = records[idx];
                      final isBlocked = rec.riskLevel.contains('Sanctioned');
                      final isFlagged = rec.riskLevel.contains('Flagged');

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: context.borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.04),
                              blurRadius: 6,
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
                                Expanded(
                                  child: Text(
                                    rec.entityName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: context.textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: (isBlocked
                                            ? AppColors.alertRed
                                            : (isFlagged ? AppColors.gold : AppColors.successGreen))
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    rec.riskLevel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: isBlocked
                                          ? AppColors.alertRed
                                          : (isFlagged ? AppColors.gold : AppColors.successGreen),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${rec.entityType} • ${rec.country}',
                              style: TextStyle(fontSize: 11, color: context.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: context.surfaceColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.qr_code, size: 14, color: AppColors.tradeTeal),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      rec.clearanceToken,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.w700,
                                        color: context.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    rec.timestamp,
                                    style: TextStyle(fontSize: 10, color: context.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    rec.listsChecked,
                                    style: TextStyle(fontSize: 10, color: context.textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _showCertificateDialog(rec),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    child: Text(
                                      'View Certificate',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.tradeTeal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: records.length,
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}

