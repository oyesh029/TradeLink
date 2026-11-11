import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '10_quotation_builder_screen.dart';

class InquiriesRfqScreen extends StatefulWidget {
  const InquiriesRfqScreen({super.key});

  @override
  State<InquiriesRfqScreen> createState() => _InquiriesRfqScreenState();
}

class _InquiriesRfqScreenState extends State<InquiriesRfqScreen> {
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.deepNavy;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final filteredRfqs = state.rfqs.where((rfq) {
      if (_selectedStatus == 'All') return true;
      return rfq.status == _selectedStatus;
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
        title: const Text('Inquiries & RFQs'),
        actions: const [
          ThemeToggleButton(transparentBackground: true),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Pipeline Summary Counters Strip
          Container(
            color: cardBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: _buildPipelineTile('Open', '7', AppColors.tradeTeal, isDark ? AppColors.tradeTeal.withValues(alpha: 0.15) : AppColors.tealTint),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPipelineTile('Quoted', '12', AppColors.gold, isDark ? AppColors.gold.withValues(alpha: 0.15) : AppColors.goldTint),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPipelineTile('Won', '31', AppColors.successGreen, isDark ? AppColors.successGreen.withValues(alpha: 0.15) : AppColors.greenTint),
                ),
              ],
            ),
          ),

          // Filter Chips
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusChip('All (${state.rfqs.length})', 'All', cardBg, borderColor, textSecondary),
                  const SizedBox(width: 8),
                  _buildStatusChip('Open', 'Open', cardBg, borderColor, textSecondary),
                  const SizedBox(width: 8),
                  _buildStatusChip('Quoted', 'Quoted', cardBg, borderColor, textSecondary),
                  const SizedBox(width: 8),
                  _buildStatusChip('Won', 'Won', cardBg, borderColor, textSecondary),
                ],
              ),
            ),
          ),

          // Inquiries List
          Expanded(
            child: filteredRfqs.isEmpty
                ? Center(
                    child: Text('No inquiries in this category.', style: TextStyle(color: textSecondary)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRfqs.length,
                    itemBuilder: (context, index) {
                      final rfq = filteredRfqs[index];
                      return _buildRfqCard(context, rfq, cardBg, borderColor, textPrimary, textSecondary, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineTile(String label, String count, Color color, Color tint) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
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

  Widget _buildRfqCard(
    BuildContext context,
    RfqModel rfq,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    final isCritical = rfq.urgency == 'Critical';
    final isHigh = rfq.urgency == 'High';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rfq.rfqNumber,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isCritical
                      ? (isDark ? AppColors.alertRed.withValues(alpha: 0.2) : AppColors.redTint)
                      : isHigh
                          ? (isDark ? AppColors.gold.withValues(alpha: 0.2) : AppColors.goldTint)
                          : (isDark ? AppColors.oceanBlue.withValues(alpha: 0.2) : AppColors.blueTint),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${rfq.urgency} Urgency',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isCritical
                        ? AppColors.alertRed
                        : isHigh
                            ? AppColors.gold
                            : AppColors.oceanBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Product & Quantity
          Text(
            rfq.productName,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
          ),
          const SizedBox(height: 3),
          Text(
            'Target Volume: ${rfq.targetQuantity} • Buyer: ${rfq.buyerName}',
            style: TextStyle(fontSize: 12, color: textSecondary),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 10),

          // Footer: Deadline & Respond Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 14, color: AppColors.alertRed),
                  const SizedBox(width: 4),
                  Text(
                    rfq.deadlineText,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.alertRed),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tradeTeal,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Respond with Quote', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
