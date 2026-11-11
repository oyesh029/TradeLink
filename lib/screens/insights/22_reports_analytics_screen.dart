import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

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
        backgroundColor: context.cardColor,
        title: Text(
          'Export Trade Intelligence Report',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary),
        ),
        content: Text(
          'Generate aggregated business intelligence analytics covering conversion rate, country volume distribution, and broker earnings.',
          style: TextStyle(fontSize: 13, color: context.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: context.textSecondary)),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported Excel (.xlsx) analytics dataset!')));
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: context.borderColor),
              foregroundColor: context.textPrimary,
            ),
            child: const Text('Excel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported Executive Trade PDF Report!')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tradeTeal,
              foregroundColor: Colors.white,
            ),
            child: const Text('PDF Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Reports & Analytics'),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
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
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildPeriodTab('Week', isDark),
                  _buildPeriodTab('Month', isDark),
                  _buildPeriodTab('Quarter', isDark),
                  _buildPeriodTab('Year', isDark),
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
                    context,
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
                    context,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Top Client Tile
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.borderColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.military_tech, color: AppColors.gold, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Top Client Organization', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                        Text('Al Noor Traders LLC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.textPrimary)),
                      ],
                    ),
                  ),
                  const Text('\$240K GMV', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.tradeTeal)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Deal Volume by Month Bar Chart
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
                  Text('Deal Volume by Month (Units)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.textPrimary)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBar('May', 0.5, '18', context, isDark),
                        _buildBar('Jun', 0.65, '24', context, isDark),
                        _buildBar('Jul', 0.6, '22', context, isDark),
                        _buildBar('Aug', 0.85, '31', context, isDark),
                        _buildBar('Sep', 0.9, '35', context, isDark),
                        _buildBar('Oct', 1.0, '48', context, isDark, isHighlight: true),
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
                      Text('Trade Volume by Country', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.textPrimary)),
                      Text('48 Deals Total', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CustomPaint(
                          painter: _CountryDonutPainter(isDark: isDark),
                          child: Center(
                            child: Icon(Icons.public, color: isDark ? const Color(0xFF38BDF8) : AppColors.deepNavy, size: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          children: [
                            _buildCountryRow('UAE (Dubai)', '38%', isDark ? const Color(0xFF38BDF8) : AppColors.deepNavy, context, isDark),
                            const SizedBox(height: 6),
                            _buildCountryRow('China (Shenzhen)', '26%', AppColors.tradeTeal, context, isDark),
                            const SizedBox(height: 6),
                            _buildCountryRow('Germany (Hamburg)', '20%', AppColors.gold, context, isDark),
                            const SizedBox(height: 6),
                            _buildCountryRow('Others (KSA, Turkey)', '16%', AppColors.oceanBlue, context, isDark),
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
                backgroundColor: isDark ? AppColors.tradeTeal : AppColors.deepNavy,
                foregroundColor: Colors.white,
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

  Widget _buildPeriodTab(String period, bool isDark) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? AppColors.cardDark : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? Colors.white : AppColors.deepNavy)
                  : (isDark ? const Color(0xFF94A3B8) : AppColors.textSecondaryLight),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, String sub, IconData icon, Color color, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
              Text(label, style: TextStyle(fontSize: 11, color: context.textSecondary)),
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

  Widget _buildBar(String month, double factor, String value, BuildContext context, bool isDark, {bool isHighlight = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isHighlight ? AppColors.tradeTeal : context.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 26,
          height: 70 * factor,
          decoration: BoxDecoration(
            color: isHighlight
                ? AppColors.tradeTeal
                : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
        const SizedBox(height: 4),
        Text(month, style: TextStyle(fontSize: 11, color: context.textPrimary, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildCountryRow(String country, String pct, Color color, BuildContext context, bool isDark) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(child: Text(country, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: context.textPrimary))),
        Text(
          pct,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isDark ? const Color(0xFF38BDF8) : AppColors.deepNavy,
          ),
        ),
      ],
    );
  }
}

class _CountryDonutPainter extends CustomPainter {
  final bool isDark;
  _CountryDonutPainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 14.0;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final paints = [
      Paint()..color = (isDark ? const Color(0xFF38BDF8) : AppColors.deepNavy)..style = PaintingStyle.stroke..strokeWidth = strokeWidth,
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
