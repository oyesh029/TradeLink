import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';

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
        title: const Text('Currency Rates & FX'),
        actions: [
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Live Trade Currency Converter',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      // Base USD Input
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('From (USD)', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.attach_money, size: 18),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                            const Text('To Currency', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: _targetCurrency,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                  const Divider(height: 1),
                  const SizedBox(height: 14),

                  // Converted Result Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Converted Amount', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                          const SizedBox(height: 2),
                          Text(
                            '${convertedAmount.toStringAsFixed(2)} $_targetCurrency',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.tradeTeal),
                          ),
                        ],
                      ),
                      Text(
                        '1 USD = ${selectedRateObj.rateToUsd} $_targetCurrency',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
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
                const Text('Live Exchange Rates (Base USD)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                Text(
                  'Updated Just Now',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
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
                return _buildRateCard(rate);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateCard(CurrencyRateModel r) {
    final isPositive = r.dailyChangePct >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // Flag / Currency Code Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.navyTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                r.code,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name & Base
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
                const SizedBox(height: 2),
                Text('1 USD = ${r.rateToUsd} ${r.code}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
              ],
            ),
          ),

          // Mini Sparkline Graphic
          SizedBox(
            width: 50,
            height: 24,
            child: CustomPaint(
              painter: _SparklinePainter(isPositive: isPositive),
            ),
          ),
          const SizedBox(width: 12),

          // Rate Change %
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: isPositive ? AppColors.greenTint : AppColors.redTint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${isPositive ? '+' : ''}${r.dailyChangePct.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isPositive ? AppColors.successGreen : AppColors.alertRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final bool isPositive;

  _SparklinePainter({required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPositive ? AppColors.successGreen : AppColors.alertRed
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * (isPositive ? 0.8 : 0.2));
    path.lineTo(size.width * 0.25, size.height * 0.6);
    path.lineTo(size.width * 0.5, size.height * 0.7);
    path.lineTo(size.width * 0.75, size.height * 0.3);
    path.lineTo(size.width, size.height * (isPositive ? 0.1 : 0.9));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
