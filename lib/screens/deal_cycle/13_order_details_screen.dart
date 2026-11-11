import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../logistics/14_shipment_tracking_screen.dart';
import '../../widgets/theme_toggle_button.dart';

class OrderDetailsScreen extends StatelessWidget {
  final TradeOrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
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
        title: Text(order.orderNumber),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.orderNumber,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: context.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order.productSummary,
                            style: TextStyle(fontSize: 12, color: context.textSecondary),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: order.status == 'Delivered'
                              ? AppColors.greenTint
                              : order.status == 'Shipped'
                                  ? AppColors.blueTint
                                  : AppColors.goldTint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: order.status == 'Delivered'
                                ? AppColors.successGreen
                                : order.status == 'Shipped'
                                    ? AppColors.oceanBlue
                                    : AppColors.gold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(height: 1, color: context.borderColor),
                  const SizedBox(height: 14),

                  // Financials: Order Value & My Commission
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          'Order Value',
                          '\$${order.orderValue.toStringAsFixed(0)}',
                          isDark ? const Color(0xFF38BDF8) : AppColors.deepNavy,
                          context,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricTile(
                          'My Commission (3%)',
                          '\$${order.agentCommission.toStringAsFixed(0)}',
                          AppColors.tradeTeal,
                          context,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Parties: Buyer & Seller
                  _buildPartyRow('Buyer (Importer):', order.buyerName, Icons.flight_land, context),
                  const SizedBox(height: 6),
                  _buildPartyRow('Seller (Exporter):', order.sellerName, Icons.factory_outlined, context),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Mandatory 6-Step Order Timeline
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '6-Step Order Execution Timeline',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.textPrimary),
                      ),
                      Text(
                        '${order.progressPct}% Done',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Timeline Steps
                  ...order.milestones.map((m) => _buildTimelineStep(m, order.milestones.last == m, context, isDark)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      state.advanceOrderMilestone(order.orderId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Advanced order execution to next milestone!')),
                      );
                    },
                    icon: const Icon(Icons.update, size: 18),
                    label: const Text('Update Status'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: isDark ? AppColors.tradeTeal : AppColors.deepNavy),
                      foregroundColor: isDark ? AppColors.tradeTeal : AppColors.deepNavy,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ShipmentTrackingScreen()),
                      );
                    },
                    icon: const Icon(Icons.directions_boat, size: 18),
                    label: const Text('Track Shipment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tradeTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, Color color, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: context.textSecondary)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyRow(String label, String value, IconData icon, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.textSecondary),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: context.textSecondary)),
        const SizedBox(width: 6),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textPrimary)),
      ],
    );
  }

  Widget _buildTimelineStep(OrderMilestone m, bool isLast, BuildContext context, bool isDark) {
    final isDone = m.isCompleted;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Icon & Line
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isDone ? AppColors.tradeTeal : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                  shape: BoxShape.circle,
                  border: isDone ? null : Border.all(color: context.borderColor),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text(
                          '${m.step}',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.textSecondary),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? AppColors.tradeTeal : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Title & Date
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        m.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDone ? context.textPrimary : context.textSecondary,
                        ),
                      ),
                      Text(
                        m.dateText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDone ? AppColors.tradeTeal : context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    m.remarks,
                    style: TextStyle(fontSize: 11, color: context.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
