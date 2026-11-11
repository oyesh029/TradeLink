import 'package:flutter/material.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

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
        backgroundColor: context.cardColor,
        title: Row(
          children: [
            const Icon(Icons.verified, color: AppColors.tradeTeal, size: 24),
            const SizedBox(width: 8),
            Text(
              'Customs Checklist Export',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pakistan Single Window (PSW) & GCC Compliance Dossier',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: context.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Includes tariff schedule HS 9405.42 (Duty 11%, Sales Tax 18%, ACD 2%, WHT 5.5%) alongside signed 5-point verification checks for container clearance.',
              style: TextStyle(fontSize: 12, color: context.textSecondary),
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
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Customs Compliance Checklist PDF downloaded!'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tradeTeal,
              foregroundColor: Colors.white,
            ),
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
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.canvasColor,
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
        actions: const [
          ThemeToggleButton(transparentBackground: true),
          SizedBox(width: 8),
        ],
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
                color: context.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PSW Tariff Schedule Lookup',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    style: TextStyle(fontSize: 13, color: context.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search product keyword (e.g. LED panel light) or HS code...',
                      hintStyle: TextStyle(fontSize: 12, color: context.textSecondary),
                      prefixIcon: Icon(Icons.search, size: 20, color: context.textSecondary),
                      filled: true,
                      fillColor: context.surfaceColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.borderColor)),
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
                color: context.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.tradeTeal.withValues(alpha: 0.6) : AppColors.tradeTeal.withValues(alpha: 0.4),
                  width: 1.5,
                ),
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
                              color: isDark ? const Color(0xFF1E293B) : AppColors.deepNavy,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isDark ? const Color(0xFF38BDF8) : Colors.transparent),
                            ),
                            child: Text(
                              'HS ${hs.hsCode}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFF38BDF8) : Colors.white,
                              ),
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
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.tradeTeal.withValues(alpha: 0.2) : AppColors.tealTint,
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                    style: TextStyle(fontSize: 13, color: context.textPrimary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 14),
                  Divider(height: 1, color: context.borderColor),
                  const SizedBox(height: 12),

                  // Duty Breakdown Grid
                  Row(
                    children: [
                      Expanded(child: _buildDutyCol('Customs Duty', '${hs.customsDutyPct}%', context)),
                      Expanded(child: _buildDutyCol('Sales Tax / VAT', '${hs.salesTaxPct}%', context)),
                      Expanded(child: _buildDutyCol('Additional Duty', '${hs.additionalDutyPct}%', context)),
                      Expanded(child: _buildDutyCol('Withholding Tax', '${hs.withholdingTaxPct}%', context)),
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
                Text(
                  'Pre-Shipment Compliance Checklist',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.textPrimary),
                ),
                Text(
                  '${state.customsChecklist.where((x) => x.isChecked).length} of ${state.customsChecklist.length} Verified',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Material(
              color: context.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: context.borderColor),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.customsChecklist.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: context.borderColor),
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
                        color: item.isChecked ? context.textSecondary : context.textPrimary,
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
                backgroundColor: isDark ? AppColors.tradeTeal : AppColors.deepNavy,
                foregroundColor: Colors.white,
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

  Widget _buildDutyCol(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: context.textSecondary)),
        const SizedBox(height: 3),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: context.textPrimary)),
      ],
    );
  }
}
