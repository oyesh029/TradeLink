import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class MaritimeWeatherRadarScreen extends StatefulWidget {
  const MaritimeWeatherRadarScreen({super.key});

  @override
  State<MaritimeWeatherRadarScreen> createState() => _MaritimeWeatherRadarScreenState();
}

class _MaritimeWeatherRadarScreenState extends State<MaritimeWeatherRadarScreen> {
  String _selectedRegion = 'All';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  // Demurrage Estimator State
  double _containerCount = 4;
  double _freeDays = 7;
  double _expectedDwellDays = 11;
  double _dailyRate = 140;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showDemurrageModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final excessDays = (_expectedDwellDays - _freeDays).clamp(0, 30).toDouble();
          final totalCost = excessDays * _containerCount * _dailyRate;

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.alertRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.timer_off_outlined, color: AppColors.alertRed, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Demurrage & Detention Calculator',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: context.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Estimate carrier container detention fines before cargo reaches free-time threshold.',
                  style: TextStyle(fontSize: 12, color: context.textSecondary),
                ),
                const SizedBox(height: 16),

                // Sliders
                Text(
                  'Containers: ${_containerCount.toInt()} units (40ft HC)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textPrimary),
                ),
                Slider(
                  value: _containerCount,
                  min: 1,
                  max: 20,
                  divisions: 19,
                  activeColor: AppColors.primaryNavy,
                  onChanged: (val) {
                    setSheetState(() => _containerCount = val);
                    setState(() {});
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Port Free Time: ${_freeDays.toInt()} Days',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textPrimary),
                    ),
                    Text(
                      'Est. Port Dwell: ${_expectedDwellDays.toInt()} Days',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textPrimary),
                    ),
                  ],
                ),
                Slider(
                  value: _freeDays,
                  min: 3,
                  max: 14,
                  divisions: 11,
                  activeColor: AppColors.oceanBlue,
                  onChanged: (val) {
                    setSheetState(() => _freeDays = val);
                    setState(() {});
                  },
                ),
                Slider(
                  value: _expectedDwellDays,
                  min: 1,
                  max: 25,
                  divisions: 24,
                  activeColor: AppColors.tradeTeal,
                  onChanged: (val) {
                    setSheetState(() => _expectedDwellDays = val);
                    setState(() {});
                  },
                ),

                Text(
                  'Daily Demurrage Tariff: \$${_dailyRate.toInt()} / container / day',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textPrimary),
                ),
                Slider(
                  value: _dailyRate,
                  min: 50,
                  max: 350,
                  divisions: 30,
                  activeColor: AppColors.gold,
                  onChanged: (val) {
                    setSheetState(() => _dailyRate = val);
                    setState(() {});
                  },
                ),

                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: excessDays > 0
                        ? AppColors.alertRed.withValues(alpha: 0.1)
                        : AppColors.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: excessDays > 0 ? AppColors.alertRed : AppColors.successGreen,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            excessDays > 0 ? 'Fines Accruing (+$excessDays days)' : 'Zero Demurrage Risk',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: excessDays > 0 ? AppColors.alertRed : AppColors.successGreen,
                            ),
                          ),
                          Text(
                            '${_containerCount.toInt()} units × \$${_dailyRate.toInt()}/day',
                            style: TextStyle(fontSize: 11, color: context.textSecondary),
                          ),
                        ],
                      ),
                      Text(
                        '\$${totalCost.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: excessDays > 0 ? AppColors.alertRed : AppColors.successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Official demurrage mitigation waiver dispatched to carrier terminal.'),
                          backgroundColor: AppColors.primaryNavy,
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                    label: const Text(
                      'Dispatch Port Waiver Request',
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPortDetailModal(PortCongestionModel port) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryNavy.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        port.portCode,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          port.portName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: context.textPrimary,
                          ),
                        ),
                        Text(
                          port.country,
                          style: TextStyle(fontSize: 12, color: context.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildCongestionBadge(port.congestionLevel),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailStat('Average Dwell Time', '${port.dwellDays} Days', Icons.hourglass_bottom),
                      _buildDetailStat('Berth Wait Queue', '${port.berthQueueCount} Vessels', Icons.directions_boat),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailStat('VLSFO Bunker Price', '\$${port.bunkerFuelPrice.toStringAsFixed(0)} / MT', Icons.local_gas_station),
                      _buildDetailStat('Weather Advisory', port.weatherWarning, Icons.storm),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showDemurrageModal();
                    },
                    icon: const Icon(Icons.calculate, size: 18),
                    label: const Text('Demurrage Check'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.borderColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vessel anchorage ETA alert set for ${port.portName}.'),
                          backgroundColor: AppColors.successGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_active, size: 18, color: Colors.white),
                    label: const Text('Subscribe Radar', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tradeTeal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.tradeTeal),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: context.textSecondary)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCongestionBadge(String level) {
    Color bg;
    Color fg;
    switch (level) {
      case 'Optimal':
        bg = AppColors.successGreen.withValues(alpha: 0.15);
        fg = AppColors.successGreen;
        break;
      case 'Normal':
        bg = AppColors.infoBlue.withValues(alpha: 0.15);
        fg = AppColors.infoBlue;
        break;
      case 'Moderate':
        bg = AppColors.gold.withValues(alpha: 0.15);
        fg = AppColors.gold;
        break;
      case 'Severe':
      default:
        bg = AppColors.alertRed.withValues(alpha: 0.15);
        fg = AppColors.alertRed;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            level,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: fg),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final ports = state.ports.where((p) {
      final matchesQuery = _searchQuery.isEmpty ||
          p.portName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.portCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.country.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesQuery) return false;
      if (_selectedRegion == 'All') return true;
      if (_selectedRegion == 'Asia-Pacific') {
        return p.country == 'Pakistan' || p.country == 'China';
      }
      if (_selectedRegion == 'Middle East') {
        return p.country == 'UAE';
      }
      if (_selectedRegion == 'Europe') {
        return p.country == 'Germany' || p.country == 'Netherlands';
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: AppBar(
        title: const Text('Maritime Weather & Port Radar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate_outlined, color: Colors.white),
            tooltip: 'Demurrage Calculator',
            onPressed: _showDemurrageModal,
          ),
          const ThemeToggleButton(transparentBackground: true),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Weather Storm Ticker Alert
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: context.isDark ? 0.35 : 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.warning_amber_rounded, color: AppColors.gold, size: 18),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'LIVE MARITIME WEATHER ADVISORY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.gold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.alertRed.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '2 ACTIVE ALERTS',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppColors.alertRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Typhoon Alert: South China Sea anchorage dwell times delayed by +36h near Shanghai/Ningbo. Arabian Sea corridor experiencing 2.8m seasonal monsoonal swell.',
                    style: const TextStyle(fontSize: 12, color: Color(0xFFE2E8F0), height: 1.4),
                  ),
                ],
              ),
            ),
          ),

          // Bunker Fuel Indices Strip
          SliverToBoxAdapter(
            child: Container(
              height: 70,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildBunkerCard('Rotterdam VLSFO', '\$585.00/t', '-1.2%', false),
                  const SizedBox(width: 10),
                  _buildBunkerCard('Singapore MGO', '\$620.00/t', '+0.8%', true),
                  const SizedBox(width: 10),
                  _buildBunkerCard('Fujairah 0.5%', '\$615.00/t', '+1.5%', true),
                  const SizedBox(width: 10),
                  _buildBunkerCard('Houston Bunker', '\$595.00/t', '-0.5%', false),
                ],
              ),
            ),
          ),

          // Search & Region Filter Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: TextStyle(fontSize: 13, color: context.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search port name, LOCODE (e.g. PKKHI, CNSHA), or country...',
                      hintStyle: TextStyle(fontSize: 13, color: context.textSecondary),
                      prefixIcon: Icon(Icons.search, size: 20, color: context.textSecondary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: context.cardColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: context.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.tradeTeal, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Asia-Pacific', 'Middle East', 'Europe'].map((r) {
                        final isSel = _selectedRegion == r;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(r),
                            selected: isSel,
                            selectedColor: AppColors.primaryNavy,
                            backgroundColor: context.surfaceColor,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              color: isSel ? Colors.white : context.textPrimary,
                            ),
                            side: BorderSide(
                              color: isSel ? AppColors.primaryNavy : context.borderColor,
                            ),
                            onSelected: (_) => setState(() => _selectedRegion = r),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Ports List
          ports.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        'No maritime ports match your filter criteria.',
                        style: TextStyle(color: context.textSecondary),
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, idx) {
                      final port = ports[idx];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: context.borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => _showPortDetailModal(port),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryNavy.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              port.portCode,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                                color: AppColors.primaryNavy,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            port.portName,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: context.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      _buildCongestionBadge(port.congestionLevel),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    port.country,
                                    style: TextStyle(fontSize: 12, color: context.textSecondary),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildMetricMini('Dwell Time', '${port.dwellDays}d avg', Icons.schedule),
                                      _buildMetricMini('Queue Wait', '${port.berthQueueCount} vessels', Icons.anchor),
                                      _buildMetricMini('Bunker Rate', '\$${port.bunkerFuelPrice.toInt()}/t', Icons.local_gas_station),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: context.surfaceColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.waves, size: 14, color: AppColors.tradeTeal),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            port.weatherWarning,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontStyle: FontStyle.italic,
                                              color: context.textSecondary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right, size: 16, color: AppColors.tradeTeal),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: ports.length,
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildBunkerCard(String title, String price, String change, bool isPositive) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 10, color: context.textSecondary), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  price,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: context.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isPositive ? AppColors.alertRed : AppColors.successGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricMini(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.tradeTeal),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 9, color: context.textSecondary)),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
