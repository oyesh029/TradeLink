import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {
  String _selectedPeriod = 'Month';

  void _exportAnalytics() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export Trade Intelligence Report'),
        content: const Text('Generate aggregated business intelligence analytics covering conversion rate, country volume distribution, and broker earnings.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported Excel (.xlsx) analytics dataset!')));
            },
            child: const Text('Excel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported Executive Trade PDF Report!')));
            },
            child: const Text('PDF Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: _exportAnalytics,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildPeriodTab('Week'),
                  _buildPeriodTab('Month'),
                  _buildPeriodTab('Quarter'),
                  _buildPeriodTab('Year'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Top KPI Cards Row (Conversion, Avg Commission, Top Client)
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    'Conversion Rate',
                    '64%',
                    '+6% vs Q2',
                    Icons.trending_up,
                    AppColors.tradeTeal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile(
                    'Avg. Commission',
                    '3.2%',
                    'Target 3.0%',
                    Icons.percent,
                    AppColors.gold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Top Client Tile
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.military_tech, color: AppColors.gold, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Top Client Organization', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                        Text('Al Noor Traders LLC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                      ],
                    ),
                  ),
                  Text('\$240K GMV', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.tradeTeal)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Deal Volume by Month Bar Chart
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
                  const Text('Deal Volume by Month (Units)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBar('May', 0.5, '18'),
                        _buildBar('Jun', 0.65, '24'),
                        _buildBar('Jul', 0.6, '22'),
                        _buildBar('Aug', 0.85, '31'),
                        _buildBar('Sep', 0.9, '35'),
                        _buildBar('Oct', 1.0, '48', isHighlight: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Trade Distribution by Country Donut Chart
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trade Volume by Country', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                      Text('48 Deals Total', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CustomPaint(
                          painter: _CountryDonutPainter(),
                          child: const Center(
                            child: Icon(Icons.public, color: AppColors.deepNavy, size: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          children: [
                            _buildCountryRow('UAE (Dubai)', '38%', AppColors.deepNavy),
                            const SizedBox(height: 6),
                            _buildCountryRow('China (Shenzhen)', '26%', AppColors.tradeTeal),
                            const SizedBox(height: 6),
                            _buildCountryRow('Germany (Hamburg)', '20%', AppColors.gold),
                            const SizedBox(height: 6),
                            _buildCountryRow('Others (KSA, Turkey)', '16%', AppColors.oceanBlue),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _exportAnalytics,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepNavy,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.ios_share, color: Colors.white, size: 18),
              label: const Text('Export Analytics Dossier', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodTab(String period) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.deepNavy : AppColors.textSecondaryLight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.successGreen, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildBar(String month, double factor, String value, {bool isHighlight = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(value, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isHighlight ? AppColors.tradeTeal : AppColors.textSecondaryLight)),
        const SizedBox(height: 4),
        Container(
          width: 26,
          height: 70 * factor,
          decoration: BoxDecoration(
            color: isHighlight ? AppColors.tradeTeal : const Color(0xFFCBD5E1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
        const SizedBox(height: 4),
        Text(month, style: const TextStyle(fontSize: 11, color: AppColors.deepNavy, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildCountryRow(String country, String pct, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(child: Text(country, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
        Text(pct, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
      ],
    );
  }
}

class _CountryDonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 14.0;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final paints = [
      Paint()..color = AppColors.deepNavy..style = PaintingStyle.stroke..strokeWidth = strokeWidth,
      Paint()..color = AppColors.tradeTeal..style = PaintingStyle.stroke..strokeWidth = strokeWidth,
      Paint()..color = AppColors.gold..style = PaintingStyle.stroke..strokeWidth = strokeWidth,
      Paint()..color = AppColors.oceanBlue..style = PaintingStyle.stroke..strokeWidth = strokeWidth,
    ];

    // Sweep Angles: UAE 38% (2.39 rad), China 26% (1.63 rad), Germany 20% (1.26 rad), Others 16% (1.00 rad)
    double startAngle = -1.57;
    canvas.drawArc(rect, startAngle, 2.39, false, paints[0]);
    startAngle += 2.39;
    canvas.drawArc(rect, startAngle, 1.63, false, paints[1]);
    startAngle += 1.63;
    canvas.drawArc(rect, startAngle, 1.26, false, paints[2]);
    startAngle += 1.26;
    canvas.drawArc(rect, startAngle, 1.00, false, paints[3]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
