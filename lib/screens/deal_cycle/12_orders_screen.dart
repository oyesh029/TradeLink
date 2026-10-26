import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '13_order_details_screen.dart';

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

    final filteredOrders = state.orders.where((o) {
      if (_selectedStatus == 'All') return true;
      return o.status == _selectedStatus;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('12. Confirmed Orders'),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusChip('All (${state.orders.length})', 'All'),
                  const SizedBox(width: 8),
                  _buildStatusChip('Processing', 'Processing'),
                  const SizedBox(width: 8),
                  _buildStatusChip('Shipped', 'Shipped'),
                  const SizedBox(width: 8),
                  _buildStatusChip('Delivered', 'Delivered'),
                ],
              ),
            ),
          ),

          // Orders List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return _buildOrderCard(context, order);
              },
            ),
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

  Widget _buildOrderCard(BuildContext context, TradeOrderModel order) {
    Color statusColor;
    Color statusTint;
    if (order.status == 'Delivered') {
      statusColor = AppColors.successGreen;
      statusTint = AppColors.greenTint;
    } else if (order.status == 'Shipped') {
      statusColor = AppColors.oceanBlue;
      statusTint = AppColors.blueTint;
    } else {
      statusColor = AppColors.gold;
      statusTint = AppColors.goldTint;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Buyer: ${order.buyerName}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
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
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Value: \$${order.orderValue.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                  ),
                  Text(
                    'Commission: \$${order.agentCommission.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.tradeTeal),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Execution Progress', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
                      Text('${order.progressPct}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tradeTeal)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: order.progressPct / 100,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        order.progressPct == 100 ? AppColors.successGreen : AppColors.tradeTeal,
                      ),
                      minHeight: 6,
                    ),
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
