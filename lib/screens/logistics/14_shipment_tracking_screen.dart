import 'package:flutter/material.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '15_documents_screen.dart';
import '16_customs_hs_screen.dart';
import '27_maritime_weather_radar_screen.dart';
import '28_sanctions_compliance_screen.dart';
import '30_container_freight_screen.dart';

class ShipmentTrackingScreen extends StatefulWidget {
  const ShipmentTrackingScreen({super.key});

  @override
  State<ShipmentTrackingScreen> createState() => _ShipmentTrackingScreenState();
}

class _ShipmentTrackingScreenState extends State<ShipmentTrackingScreen> {
  final _searchController = TextEditingController(text: 'MSKU-7781452');

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final shipment = state.activeShipment;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.deepNavy;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final surfaceBg = isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
                tooltip: 'Back',
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('Logistics & Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_shared_outlined),
            tooltip: 'Trade Documents Vault',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DocumentsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.policy_outlined),
            tooltip: 'Customs & HS Tariff',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomsHsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.waves),
            tooltip: 'Maritime Radar & Congestion',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MaritimeWeatherRadarScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.security),
            tooltip: 'Sanctions & AML Compliance',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SanctionsComplianceScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.view_in_ar_rounded),
            tooltip: 'Container Freight & Incoterms',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContainerFreightScreen()),
            ),
          ),
          const ThemeToggleButton(transparentBackground: true),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // Logistics Domain Feature Sub-Navigation
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.deepNavy,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Live Tracking',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DocumentsScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const Icon(Icons.folder_shared_outlined, size: 14, color: AppColors.gold),
                          const SizedBox(width: 5),
                          Text(
                            'Documents Vault',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CustomsHsScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const Icon(Icons.policy_outlined, size: 14, color: AppColors.oceanBlue),
                          const SizedBox(width: 5),
                          Text(
                            'Customs Tariff',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MaritimeWeatherRadarScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const Icon(Icons.waves, size: 14, color: AppColors.tradeTeal),
                          const SizedBox(width: 5),
                          Text(
                            'Port & Weather Radar',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SanctionsComplianceScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const Icon(Icons.security, size: 14, color: AppColors.successGreen),
                          const SizedBox(width: 5),
                          Text(
                            'Sanctions & AML',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ContainerFreightScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const Icon(Icons.view_in_ar_rounded, size: 14, color: AppColors.tradeTeal),
                          const SizedBox(width: 5),
                          Text(
                            'Freight & CBM',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Search & Container Header
          Container(
            color: cardBg,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Enter Container No. or B/L No.',
                      hintStyle: TextStyle(color: textSecondary),
                      prefixIcon: Icon(Icons.search, size: 20, color: textSecondary),
                      filled: true,
                      fillColor: surfaceBg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tracking telemetry synced for ${_searchController.text}')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tradeTeal,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  child: const Text('Track'),
                ),
              ],
            ),
          ),

          // Maritime Route Map Visualization Canvas
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A2240), Color(0xFF163E6E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Stylized Sea Waves / Ocean Texture
                Positioned.fill(
                  child: CustomPaint(
                    painter: _OceanRoutePainter(),
                  ),
                ),

                // Departure Port Marker (Karachi)
                const Positioned(
                  top: 40,
                  left: 36,
                  child: Column(
                    children: [
                      Icon(Icons.anchor, color: Colors.white, size: 24),
                      SizedBox(height: 2),
                      Text(
                        'Karachi (PKKHI)\nDep: 12 Oct',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                // Current Vessel Position Marker (At Sea)
                Positioned(
                  top: 90,
                  left: MediaQuery.of(context).size.width * 0.45,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.tradeTeal,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.tradeTeal.withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 2),
                          ],
                        ),
                        child: const Icon(Icons.directions_boat, color: Colors.white, size: 22),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'MV Ocean Star\nArabian Sea corridor',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrival Port Marker (Jebel Ali)
                const Positioned(
                  bottom: 30,
                  right: 36,
                  child: Column(
                    children: [
                      Icon(Icons.location_on, color: AppColors.gold, size: 26),
                      SizedBox(height: 2),
                      Text(
                        'Jebel Ali (AEJEA)\nETA: 18 Oct',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Shipment Meta & Milestone Card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vessel & Container Details Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.view_in_ar, color: AppColors.tradeTeal, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  shipment.containerNumber,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.oceanBlue.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                shipment.status,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.oceanBlue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(height: 1, color: borderColor),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMetaCol('Vessel', shipment.vesselName, textPrimary, textSecondary),
                            _buildMetaCol('Type', shipment.containerType, textPrimary, textSecondary),
                            _buildMetaCol('B/L Ref', shipment.blNumber, textPrimary, textSecondary),
                            _buildMetaCol('ETA', shipment.etaDate, textPrimary, textSecondary),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Voyage Milestone Timeline
                  Text(
                    'Voyage Milestones & Checkpoints',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: shipment.routeCheckpoints.asMap().entries.map((entry) {
                        final index = entry.key;
                        final checkpoint = entry.value;
                        final isPassed = index <= 1;
                        final isLast = index == shipment.routeCheckpoints.length - 1;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: isPassed ? AppColors.tradeTeal : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: isPassed ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                                ),
                                if (!isLast)
                                  Container(
                                    width: 2,
                                    height: 36,
                                    color: isPassed ? AppColors.tradeTeal : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: Text(
                                  checkpoint,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isPassed ? FontWeight.w700 : FontWeight.w500,
                                    color: isPassed ? textPrimary : textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCol(String label, String value, Color textPrimary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
        ),
      ],
    );
  }
}

class _OceanRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 5; i++) {
      final path = Path();
      path.moveTo(0, size.height * (0.2 + i * 0.15));
      path.quadraticBezierTo(
        size.width * 0.5,
        size.height * (0.15 + i * 0.15),
        size.width,
        size.height * (0.25 + i * 0.15),
      );
      canvas.drawPath(path, wavePaint);
    }

    final routePaint = Paint()
      ..color = AppColors.tradeTeal.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final routePath = Path();
    routePath.moveTo(50, 70);
    routePath.quadraticBezierTo(size.width * 0.45, size.height * 0.55, size.width - 50, size.height - 50);
    canvas.drawPath(routePath, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
