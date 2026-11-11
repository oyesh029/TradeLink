import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class CurrencyRatesScreen extends StatefulWidget {
  const CurrencyRatesScreen({super.key});

  @override
  State<CurrencyRatesScreen> createState() => _CurrencyRatesScreenState();
}

class _CurrencyRatesScreenState extends State<CurrencyRatesScreen> {
  final _amountController = TextEditingController(text: '1000');
  String _targetCurrency = 'PKR';

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final inputUsd = double.tryParse(_amountController.text) ?? 1000.0;
    final selectedRateObj = state.currencyRates.firstWhere(
      (r) => r.code == _targetCurrency,
      orElse: () => state.currencyRates.first,
    );
    final convertedAmount = inputUsd * selectedRateObj.rateToUsd;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.deepNavy;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final surfaceBg = isDark ? AppColors.surfaceDark : const Color(0xFFF8FAFC);

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
        title: const Text('Currency Rates & FX'),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Sync Live FX',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rates synced with international interbank FX feed')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Currency Converter Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live Trade Currency Converter',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      // Base USD Input
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('From (USD)', style: TextStyle(fontSize: 11, color: textSecondary)),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.attach_money, size: 18),
                                filled: true,
                                fillColor: surfaceBg,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Icon(Icons.swap_horiz, color: AppColors.tradeTeal, size: 28),
                      ),

                      // Target Currency Select
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('To Currency', style: TextStyle(fontSize: 11, color: textSecondary)),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: _targetCurrency,
                              dropdownColor: cardBg,
                              style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: surfaceBg,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                              ),
                              items: state.currencyRates.map((r) => DropdownMenuItem(value: r.code, child: Text(r.code))).toList(),
                              onChanged: (val) => setState(() => _targetCurrency = val!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(height: 1, color: borderColor),
                  const SizedBox(height: 14),

                  // Converted Result Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Converted Amount', style: TextStyle(fontSize: 11, color: textSecondary)),
                          const SizedBox(height: 2),
                          Text(
                            '${convertedAmount.toStringAsFixed(2)} $_targetCurrency',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.tradeTeal),
                          ),
                        ],
                      ),
                      Text(
                        '1 USD = ${selectedRateObj.rateToUsd} $_targetCurrency',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Live Board Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Live Exchange Rates (Base USD)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimary)),
                Text(
                  'Updated Just Now',
                  style: TextStyle(fontSize: 11, color: textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Rates Board Grid
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.currencyRates.length,
              itemBuilder: (context, index) {
                final rate = state.currencyRates[index];
                return _buildRateCard(rate, cardBg, borderColor, textPrimary, textSecondary, surfaceBg);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateCard(CurrencyRateModel r, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary, Color surfaceBg) {
    final isPositive = r.dailyChangePct >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // Flag / Currency Code Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: surfaceBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Center(
              child: Text(
                r.symbol,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.tradeTeal),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Currency Name and Code
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(r.code, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textPrimary)),
                    const SizedBox(width: 6),
                    Text('• ${r.name}', style: TextStyle(fontSize: 12, color: textSecondary)),
                  ],
                ),
                const SizedBox(height: 2),
                Text('1 USD = ${r.rateToUsd} ${r.code}', style: TextStyle(fontSize: 11, color: textSecondary)),
              ],
            ),
          ),

          // Daily Delta Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive ? AppColors.greenTint : AppColors.redTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 16,
                  color: isPositive ? AppColors.successGreen : AppColors.alertRed,
                ),
                Text(
                  '${isPositive ? '+' : ''}${r.dailyChangePct.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isPositive ? AppColors.successGreen : AppColors.alertRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
