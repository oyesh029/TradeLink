import 'package:flutter/material.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';

class CustomsHsScreen extends StatefulWidget {
  const CustomsHsScreen({super.key});

  @override
  State<CustomsHsScreen> createState() => _CustomsHsScreenState();
}

class _CustomsHsScreenState extends State<CustomsHsScreen> {
  final _searchController = TextEditingController(text: 'LED panel light');

  void _showExportPdfDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.verified, color: AppColors.tradeTeal, size: 24),
            SizedBox(width: 8),
            Text('Customs Checklist Export'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pakistan Single Window (PSW) & GCC Compliance Dossier',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.deepNavy),
            ),
            SizedBox(height: 8),
            Text(
              'Includes tariff schedule HS 9405.42 (Duty 11%, Sales Tax 18%, ACD 2%, WHT 5.5%) alongside signed 5-point verification checks for container clearance.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Customs Compliance Checklist PDF downloaded!'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Download PDF'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final hs = state.verifiedHsCode;

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
        title: const Text('Customs & HS Code Tariff'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PSW Tariff Schedule Lookup',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search product keyword (e.g. LED panel light) or HS code...',
                      prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondaryLight),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Verified HS Match Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.tradeTeal.withValues(alpha: 0.4), width: 1.5),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.deepNavy,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'HS ${hs.hsCode}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: AppColors.successGreen),
                              SizedBox(width: 4),
                              Text('Verified Match (PSW)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.successGreen)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.tealTint, borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Total Tariff: ${hs.totalDutyPct}%',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.tradeTeal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hs.description,
                    style: const TextStyle(fontSize: 13, color: AppColors.deepNavy, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Duty Breakdown Grid
                  Row(
                    children: [
                      Expanded(child: _buildDutyCol('Customs Duty', '${hs.customsDutyPct}%')),
                      Expanded(child: _buildDutyCol('Sales Tax / VAT', '${hs.salesTaxPct}%')),
                      Expanded(child: _buildDutyCol('Additional Duty', '${hs.additionalDutyPct}%')),
                      Expanded(child: _buildDutyCol('Withholding Tax', '${hs.withholdingTaxPct}%')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Pre-Shipment Compliance Checklist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pre-Shipment Compliance Checklist',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                ),
                Text(
                  '${state.customsChecklist.where((x) => x.isChecked).length} of ${state.customsChecklist.length} Verified',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.customsChecklist.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = state.customsChecklist[index];
                  return CheckboxListTile(
                    value: item.isChecked,
                    activeColor: AppColors.tradeTeal,
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: item.isChecked ? FontWeight.w700 : FontWeight.w500,
                        color: item.isChecked ? AppColors.deepNavy : AppColors.textSecondaryLight,
                        decoration: item.isChecked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    onChanged: (_) => state.toggleComplianceItem(index),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Export Action Button
            ElevatedButton.icon(
              onPressed: _showExportPdfDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepNavy,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: const Text('Generate Customs Checklist as PDF', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDutyCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
      ],
    );
  }
}
