import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class CommissionCalculatorScreen extends StatefulWidget {
  const CommissionCalculatorScreen({super.key});

  @override
  State<CommissionCalculatorScreen> createState() => _CommissionCalculatorScreenState();
}

class _CommissionCalculatorScreenState extends State<CommissionCalculatorScreen> {
  final _dealValueController = TextEditingController(text: '48000');
  double _sliderRate = 2.5;
  String _selectedModel = 'Percentage';

  void _applyPreset(double rate) {
    setState(() => _sliderRate = rate);
  }

  @override
  Widget build(BuildContext context) {
    final dealValue = double.tryParse(_dealValueController.text) ?? 0.0;
    final grossCommission = dealValue * (_sliderRate / 100);
    final platformFee = grossCommission * 0.10; // 10% TradeLink broker split
    final taxWithheld = 0.0; // 0% cross-border export exemption
    final netCommission = grossCommission - platformFee - taxWithheld;

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
        title: const Text('Commission Calculator'),
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
            // Deal Value & Model Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter Total Deal Value (USD)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dealValueController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.attach_money, color: AppColors.tradeTeal),
                      filled: true,
                      fillColor: surfaceBg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Model Selection Chips
                  Text('Commission Pricing Model',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildModelChip('Percentage', cardBg, borderColor, textPrimary, textSecondary),
                      const SizedBox(width: 8),
                      _buildModelChip('Fixed Flat', cardBg, borderColor, textPrimary, textSecondary),
                      const SizedBox(width: 8),
                      _buildModelChip('Tiered Volume', cardBg, borderColor, textPrimary, textSecondary),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Interactive Rate Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Commission Rate', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary)),
                      Text('${_sliderRate.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.tradeTeal)),
                    ],
                  ),
                  Slider(
                    value: _sliderRate,
                    min: 1.0,
                    max: 10.0,
                    divisions: 18,
                    activeColor: AppColors.tradeTeal,
                    inactiveColor: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    onChanged: (val) => setState(() => _sliderRate = val),
                  ),

                  // Quick Preset Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPresetBtn(1.0, cardBg, borderColor, textPrimary),
                      _buildPresetBtn(2.0, cardBg, borderColor, textPrimary),
                      _buildPresetBtn(3.0, cardBg, borderColor, textPrimary),
                      _buildPresetBtn(5.0, cardBg, borderColor, textPrimary),
                      _buildPresetBtn(7.5, cardBg, borderColor, textPrimary),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Visual Fee Breakdown & Donut Chart
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fee Breakdown & Payout',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimary)),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      // Donut Chart Graphic
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CustomPaint(
                          painter: _DonutChartPainter(),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('90%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.tradeTeal)),
                                Text('Net', style: TextStyle(fontSize: 10, color: textSecondary)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Itemized Breakdown Rows
                      Expanded(
                        child: Column(
                          children: [
                            _buildBreakdownRow('Gross Commission', '\$${grossCommission.toStringAsFixed(2)}', textPrimary),
                            const SizedBox(height: 6),
                            _buildBreakdownRow('Platform Fee (10%)', '-\$${platformFee.toStringAsFixed(2)}', AppColors.alertRed),
                            const SizedBox(height: 6),
                            _buildBreakdownRow('Tax Withheld (0%)', '\$${taxWithheld.toStringAsFixed(2)}', textSecondary),
                            Divider(height: 16, color: borderColor),
                            _buildBreakdownRow('Net Payout (90%)', '\$${netCommission.toStringAsFixed(2)}', AppColors.tradeTeal, isBold: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save to Deal Action
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Saved ${_sliderRate.toStringAsFixed(1)}% commission calculation to deal!'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tradeTeal,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.bookmark_add_outlined, color: Colors.white),
              label: const Text('Save Calculation Directly to Deal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelChip(String model, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary) {
    final isSelected = _selectedModel == model;
    return GestureDetector(
      onTap: () => setState(() => _selectedModel = model),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tradeTeal : cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.tradeTeal : borderColor),
        ),
        child: Text(
          model,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildPresetBtn(double rate, Color cardBg, Color borderColor, Color textPrimary) {
    final isSelected = _sliderRate == rate;
    return InkWell(
      onTap: () => _applyPreset(rate),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tradeTeal : cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppColors.tradeTeal : borderColor),
        ),
        child: Text(
          '${rate.toStringAsFixed(rate % 1 == 0 ? 0 : 1)}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, Color valColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: valColor,
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 14.0;

    final bgPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final netPaint = Paint()
      ..color = AppColors.tradeTeal
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final feePaint = Paint()
      ..color = AppColors.alertRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // 90% Net Slice (324 degrees)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // Start at -90 deg (12 o'clock)
      5.6548,  // 0.90 * 2 * pi
      false,
      netPaint,
    );

    // 10% Fee Slice
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708 + 5.6548,
      0.6283, // 0.10 * 2 * pi
      false,
      feePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
