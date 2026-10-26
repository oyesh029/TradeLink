import 'package:flutter/material.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String _selectedMethod = 'Escrow Payment';

  void _confirmEncryptedPayment() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.shield_outlined, color: AppColors.tradeTeal, size: 24),
            SizedBox(width: 8),
            Text('256-Bit Encrypted Transfer'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm \$32,445.00 Escrow Deposit',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.deepNavy),
            ),
            SizedBox(height: 6),
            Text(
              'Funds are held securely in TradeLink Escrow Vault (HSBC / Emirates NBD). 50% advance released on Bill of Lading verification; 50% released on port customs arrival confirmation.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment confirmed! Funds secured in Escrow Vault.'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            child: const Text('Authorize Wire'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('20. Cross-Border Payments & Escrow'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Escrow Protection Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.deepNavy, Color(0xFF133B6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.shield, color: AppColors.tradeTeal, size: 20),
                          SizedBox(width: 8),
                          Text('Protected Escrow Vault', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.tradeTeal.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(12)),
                        child: const Text('256-Bit Encrypted', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.tradeTeal)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '\$${state.escrowBalance.toStringAsFixed(2)} Protected',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 12),

                  // Staged Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: state.escrowReleasedPct / 100,
                      backgroundColor: const Color(0xFF2E466E),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.tradeTeal),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${state.escrowReleasedPct.toInt()}% Released on B/L',
                          style: const TextStyle(fontSize: 11, color: AppColors.tradeTeal, fontWeight: FontWeight.w700)),
                      Text('${state.escrowHeldPct.toInt()}% Retained until Delivery',
                          style: const TextStyle(fontSize: 11, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w600)),
                    ],
                  ),

                  if (state.escrowHeldPct > 0) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          state.releaseEscrowMilestone();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Final 50% milestone released upon confirmed delivery!')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: AppColors.tradeTeal),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text('Release Final 50% Milestone Payout', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Select Settlement Method
            const Text('Select Settlement Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
            const SizedBox(height: 10),

            _buildMethodOption(
              title: 'Escrow Payment (Staged Release)',
              subtitle: '50% released on B/L verification, 50% on customs arrival',
              icon: Icons.lock_outline,
              key: 'Escrow Payment',
            ),
            _buildMethodOption(
              title: 'Letter of Credit (LC at Sight)',
              subtitle: 'Documentary credit confirmed by Emirates NBD / HBL',
              icon: Icons.account_balance_outlined,
              key: 'Letter of Credit',
            ),
            _buildMethodOption(
              title: 'Telegraphic Transfer (TT 30/70)',
              subtitle: '30% swift advance deposit, 70% against shipping manifest',
              icon: Icons.swap_horiz_outlined,
              key: 'Telegraphic Transfer',
            ),
            const SizedBox(height: 16),

            // Charges & Breakdown Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildPaymentRow('Merchandise Deal Value', '\$32,400.00'),
                  const SizedBox(height: 6),
                  _buildPaymentRow('Bank Wire / LC Charges', '\$45.00'),
                  const SizedBox(height: 6),
                  _buildPaymentRow('Platform Escrow Protection Fee', '\$0.00 (Waived)'),
                  const Divider(height: 16),
                  _buildPaymentRow('Total Payable (USD)', '\$32,445.00', isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _confirmEncryptedPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepNavy,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.lock, size: 18, color: Colors.white),
              label: const Text('Confirm 256-Bit Encrypted Payment', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodOption({required String title, required String subtitle, required IconData icon, required String key}) {
    final isSelected = _selectedMethod == key;

    return InkWell(
      onTap: () => setState(() => _selectedMethod = key),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.tradeTeal : const Color(0xFFE2E8F0), width: isSelected ? 1.8 : 1),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? AppColors.tradeTeal : const Color(0xFFCBD5E1), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isBold ? 14 : 12, fontWeight: isBold ? FontWeight.w800 : FontWeight.w500, color: AppColors.deepNavy)),
        Text(value, style: TextStyle(fontSize: isBold ? 16 : 13, fontWeight: isBold ? FontWeight.w900 : FontWeight.w700, color: isBold ? AppColors.tradeTeal : AppColors.deepNavy)),
      ],
    );
  }
}
