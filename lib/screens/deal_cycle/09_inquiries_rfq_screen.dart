import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
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

    final filteredRfqs = state.rfqs.where((rfq) {
      if (_selectedStatus == 'All') return true;
      return rfq.status == _selectedStatus;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('09. Inquiries & RFQs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Pipeline Summary Counters Strip
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: _buildPipelineTile('Open', '7', AppColors.tradeTeal, AppColors.tealTint),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPipelineTile('Quoted', '12', AppColors.gold, AppColors.goldTint),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPipelineTile('Won', '31', AppColors.successGreen, AppColors.greenTint),
                ),
              ],
            ),
          ),

          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusChip('All (${state.rfqs.length})', 'All'),
                  const SizedBox(width: 8),
                  _buildStatusChip('Open', 'Open'),
                  const SizedBox(width: 8),
                  _buildStatusChip('Quoted', 'Quoted'),
                  const SizedBox(width: 8),
                  _buildStatusChip('Won', 'Won'),
                ],
              ),
            ),
          ),

          // Inquiries List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredRfqs.length,
              itemBuilder: (context, index) {
                final rfq = filteredRfqs[index];
                return _buildRfqCard(context, rfq);
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

  Widget _buildRfqCard(BuildContext context, RfqModel rfq) {
    final isCritical = rfq.urgency == 'Critical';
    final isHigh = rfq.urgency == 'High';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isCritical
                      ? AppColors.redTint
                      : isHigh
                          ? AppColors.goldTint
                          : AppColors.blueTint,
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
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
          ),
          const SizedBox(height: 3),
          Text(
            'Target Volume: ${rfq.targetQuantity} • Buyer: ${rfq.buyerName}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
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
