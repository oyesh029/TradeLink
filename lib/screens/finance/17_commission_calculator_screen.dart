import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CommissionCalculatorScreen extends StatefulWidget {
  const CommissionCalculatorScreen({super.key});

  @override
  State<CommissionCalculatorScreen> createState() => _CommissionCalculatorScreenState();
}

class _CommissionCalculatorScreenState extends State<CommissionCalculatorScreen> {
  final _dealValueController = TextEditingController(text: '42000');
  double _sliderRate = 3.0;
  String _selectedModel = 'Percentage';

  void _applyPreset(double rate) {
    setState(() {
      _sliderRate = rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dealValue = double.tryParse(_dealValueController.text) ?? 42000.0;
    final grossCommission = dealValue * (_sliderRate / 100);
    final platformFee = grossCommission * 0.10;
    const taxWithheld = 0.0;
    final netCommission = grossCommission - platformFee - taxWithheld;

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('17. Commission Calculator'),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter Total Deal Value (USD)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dealValueController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.attach_money, color: AppColors.tradeTeal),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Model Selection Chips
                  const Text('Commission Pricing Model',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.deepNavy)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildModelChip('Percentage'),
                      const SizedBox(width: 8),
                      _buildModelChip('Fixed Flat'),
                      const SizedBox(width: 8),
                      _buildModelChip('Tiered Volume'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Interactive Rate Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Commission Rate', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                    onChanged: (val) => setState(() => _sliderRate = val),
                  ),

                  // Quick Preset Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPresetBtn(1.0),
                      _buildPresetBtn(2.0),
                      _buildPresetBtn(3.0),
                      _buildPresetBtn(5.0),
                      _buildPresetBtn(7.5),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fee Breakdown & Payout',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      // Donut Chart Graphic
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CustomPaint(
                          painter: _DonutChartPainter(),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('90%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.tradeTeal)),
                                Text('Net', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
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
                            _buildBreakdownRow('Gross Commission', '\$${grossCommission.toStringAsFixed(2)}', AppColors.deepNavy),
                            const SizedBox(height: 6),
                            _buildBreakdownRow('Platform Fee (10%)', '-\$${platformFee.toStringAsFixed(2)}', AppColors.alertRed),
                            const SizedBox(height: 6),
                            _buildBreakdownRow('Tax Withheld (0%)', '\$${taxWithheld.toStringAsFixed(2)}', AppColors.textSecondaryLight),
                            const Divider(height: 16),
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

  Widget _buildModelChip(String model) {
    final isSelected = _selectedModel == model;
    return GestureDetector(
      onTap: () => setState(() => _selectedModel = model),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepNavy : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          model,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildPresetBtn(double rate) {
    final isSelected = _sliderRate == rate;
    return InkWell(
      onTap: () => _applyPreset(rate),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tradeTeal : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${rate.toStringAsFixed(rate == 7.5 ? 1 : 0)}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.deepNavy,
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isBold ? 13 : 11, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500)),
        Text(value, style: TextStyle(fontSize: isBold ? 14 : 12, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final netPaint = Paint()
      ..color = AppColors.tradeTeal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final feePaint = Paint()
      ..color = AppColors.alertRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    // 90% net arc (324 degrees = 5.65 radians)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 7),
      -1.57,
      5.65,
      false,
      netPaint,
    );

    // 10% fee arc (36 degrees = 0.63 radians)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 7),
      4.08,
      0.63,
      false,
      feePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
