import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '09_inquiries_rfq_screen.dart';
import '10_quotation_builder_screen.dart';
import '11_negotiation_chat_screen.dart';
import '13_order_details_screen.dart';
import '26_dispute_arbitration_screen.dart';
import '31_quality_inspection_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.deepNavy;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final surfaceBg = isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9);

    final filteredOrders = state.orders.where((o) {
      if (_selectedStatus == 'All') return true;
      return o.status == _selectedStatus;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
                tooltip: 'Back',
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('Deals & Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_unread_outlined),
            tooltip: 'Inquiries / RFQ Pipeline',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InquiriesRfqScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calculate_outlined),
            tooltip: 'Quotation Builder',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            tooltip: 'Negotiation Chat',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NegotiationChatScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.balance_rounded),
            tooltip: 'Dispute & Arbitration',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DisputeArbitrationScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.fact_check_outlined),
            tooltip: 'PSI Quality Audits',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QualityInspectionScreen()),
            ),
          ),
          const ThemeToggleButton(transparentBackground: true),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // Deal Cycle Domain Feature Sub-Navigation
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.deepNavy,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Orders (${state.orders.length})',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const InquiriesRfqScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mark_email_unread_outlined, size: 14, color: AppColors.gold),
                          const SizedBox(width: 5),
                          Text(
                            'Inquiries / RFQ',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calculate_outlined, size: 14, color: AppColors.tradeTeal),
                          const SizedBox(width: 5),
                          Text(
                            'Quotation Builder',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NegotiationChatScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_outlined, size: 14, color: AppColors.oceanBlue),
                          const SizedBox(width: 5),
                          Text(
                            'Negotiations',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DisputeArbitrationScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.balance_rounded, size: 14, color: AppColors.alertRed),
                          const SizedBox(width: 5),
                          Text(
                            'Dispute Center (${state.disputes.length})',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QualityInspectionScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.fact_check_outlined, size: 14, color: AppColors.successGreen),
                          const SizedBox(width: 5),
                          Text(
                            'PSI Quality Audits (${state.qualityInspections.length})',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Filter Tabs
          Container(
            color: cardBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusChip('All (${state.orders.length})', 'All', cardBg, borderColor, textPrimary, textSecondary),
                  const SizedBox(width: 8),
                  _buildStatusChip('Processing', 'Processing', cardBg, borderColor, textPrimary, textSecondary),
                  const SizedBox(width: 8),
                  _buildStatusChip('Shipped', 'Shipped', cardBg, borderColor, textPrimary, textSecondary),
                  const SizedBox(width: 8),
                  _buildStatusChip('Delivered', 'Delivered', cardBg, borderColor, textPrimary, textSecondary),
                ],
              ),
            ),
          ),

          // Orders List
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Text('No orders match this status filter.', style: TextStyle(color: textSecondary)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _buildOrderCard(context, order, cardBg, borderColor, textPrimary, textSecondary, surfaceBg);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String key, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary) {
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

  Widget _buildOrderCard(
    BuildContext context,
    TradeOrderModel order,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    Color surfaceBg,
  ) {
    Color statusColor;
    Color statusTint;
    if (order.status == 'Delivered') {
      statusColor = AppColors.successGreen;
      statusTint = AppColors.successGreen.withValues(alpha: 0.15);
    } else if (order.status == 'Shipped') {
      statusColor = AppColors.oceanBlue;
      statusTint = AppColors.oceanBlue.withValues(alpha: 0.15);
    } else {
      statusColor = AppColors.gold;
      statusTint = AppColors.gold.withValues(alpha: 0.15);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Code, Buyer & Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderNumber,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Buyer: ${order.buyerName}',
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Product Summary & Value
              Text(
                order.productSummary,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Value: \$${order.orderValue.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                  Text(
                    'Commission: \$${order.agentCommission.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Milestone Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: order.progressPct / 100,
                  minHeight: 6,
                  backgroundColor: surfaceBg,
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Milestone ${order.milestones.where((m) => m.isCompleted).length} of 6 Completed',
                    style: TextStyle(fontSize: 11, color: textSecondary),
                  ),
                  Text(
                    '${order.progressPct}%',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
