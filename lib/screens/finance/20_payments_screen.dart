import 'package:flutter/material.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '29_letter_of_credit_screen.dart';

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
        title: const Text('Confirm Staged Payment Wire?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transacting via 256-Bit Encrypted Interbank Escrow:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 8),
            Text(
              'Method: $_selectedMethod\nInitial 50% Deposit: \$16,200.00\nBeneficiary: Shenzhen Tech Ltd (Escrow Account)',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final state = TradeStateInherited.of(context);
              state.releaseEscrowMilestone();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Initial 50% escrow deposit funded and verified on blockchain!'),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.deepNavy;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

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
        title: const Text('Payments & Escrow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance, color: Colors.white),
            tooltip: 'Letter of Credit (LC) Advisor',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LetterOfCreditScreen()),
            ),
          ),
          const ThemeToggleButton(transparentBackground: true),
          const SizedBox(width: 8),
        ],
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
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF0F1E36), const Color(0xFF162B4D)]
                      : [AppColors.deepNavy, const Color(0xFF133B6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF2B4365) : Colors.transparent),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.15),
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
            Text('Select Settlement Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textPrimary)),
            const SizedBox(height: 10),

            _buildMethodOption(
              title: 'Escrow Payment (Staged Release)',
              subtitle: '50% released on B/L verification, 50% on customs arrival',
              icon: Icons.lock_outline,
              key: 'Escrow Payment',
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            _buildMethodOption(
              title: 'Letter of Credit (LC at Sight)',
              subtitle: 'Documentary credit confirmed by Emirates NBD / HBL',
              icon: Icons.account_balance_outlined,
              key: 'Letter of Credit',
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            _buildMethodOption(
              title: 'Telegraphic Transfer (TT 30/70)',
              subtitle: '30% swift advance deposit, 70% against shipping manifest',
              icon: Icons.swap_horiz_outlined,
              key: 'Telegraphic Transfer',
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 16),

            // Charges & Breakdown Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildPaymentRow('Merchandise Deal Value', '\$32,400.00', textPrimary, textSecondary),
                  const SizedBox(height: 6),
                  _buildPaymentRow('Bank Wire / LC Charges', '\$45.00', textPrimary, textSecondary),
                  const SizedBox(height: 6),
                  _buildPaymentRow('Platform Escrow Protection Fee', '\$0.00 (Waived)', textPrimary, textSecondary),
                  Divider(height: 16, color: borderColor),
                  _buildPaymentRow('Total Payable (USD)', '\$32,445.00', textPrimary, textSecondary, isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _confirmEncryptedPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tradeTeal,
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

  Widget _buildMethodOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String key,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final isSelected = _selectedMethod == key;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = key),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.tradeTeal : borderColor,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.tealTint : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF131A2E) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isSelected ? AppColors.tradeTeal : textSecondary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: textSecondary)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.tradeTeal : textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, Color textPrimary, Color textSecondary, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 13 : 12,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: isBold ? textPrimary : textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 15 : 12,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: textPrimary,
          ),
        ),
      ],
    );
  }
}
