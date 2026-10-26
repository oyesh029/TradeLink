import 'package:flutter/material.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';

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

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('14. Container Shipment Tracking'),
      ),
      body: Column(
        children: [
          // Search & Container Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter Container No. or B/L No.',
                      prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondaryLight),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
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
                    backgroundColor: AppColors.deepNavy,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
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
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.blueTint,
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
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMetaCol('Vessel', shipment.vesselName),
                            _buildMetaCol('Type', shipment.containerType),
                            _buildMetaCol('B/L Ref', shipment.blNumber),
                            _buildMetaCol('ETA', shipment.etaDate),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Voyage Milestone Timeline
                  const Text(
                    'Voyage Milestones & Checkpoints',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
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
                                    color: isPassed ? AppColors.tradeTeal : const Color(0xFFE2E8F0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: isPassed ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                                ),
                                if (!isLast)
                                  Container(
                                    width: 2,
                                    height: 32,
                                    color: isPassed ? AppColors.tradeTeal : const Color(0xFFCBD5E1),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                checkpoint,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isPassed ? FontWeight.w700 : FontWeight.w500,
                                  color: isPassed ? AppColors.deepNavy : AppColors.textSecondaryLight,
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

  Widget _buildMetaCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
      ],
    );
  }
}

class _OceanRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.tradeTeal.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();
    path.moveTo(60, 60);
    path.cubicTo(size.width * 0.35, 120, size.width * 0.6, 90, size.width - 60, size.height - 40);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
