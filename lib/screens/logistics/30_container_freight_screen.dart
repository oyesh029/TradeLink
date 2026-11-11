import 'package:flutter/material.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class ContainerFreightScreen extends StatefulWidget {
  const ContainerFreightScreen({super.key});

  @override
  State<ContainerFreightScreen> createState() => _ContainerFreightScreenState();
}

class _ContainerFreightScreenState extends State<ContainerFreightScreen> {
  // Cargo Dimensions for CBM calculation
  double _lengthCm = 60;
  double _widthCm = 40;
  double _heightCm = 40;
  double _packageCount = 150;
  double _grossWeightPerCartonKg = 18;

  String _selectedIncoterm = 'CIF';

  final Map<String, String> _incotermDescriptions = {
    'EXW': 'Ex Works: Buyer assumes all risks and costs from factory floor to destination.',
    'FOB': 'Free On Board: Seller pays inland transit & loading onto vessel. Buyer pays ocean freight & insurance.',
    'CFR': 'Cost and Freight: Seller pays ocean freight to destination port. Buyer procures marine cargo insurance.',
    'CIF': 'Cost, Insurance and Freight: Seller covers ocean freight and minimum marine cargo insurance (Clause C).',
    'DAP': 'Delivered At Place: Seller bears all costs to destination warehouse prior to import customs clearance.',
    'DDP': 'Delivered Duty Paid: Maximum seller responsibility including import duties, taxes, and final doorstep delivery.',
  };

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final totalCbm = (_lengthCm * _widthCm * _heightCm * _packageCount) / 1000000.0;
    final totalWeightKg = _packageCount * _grossWeightPerCartonKg;
    final volumetricAirWeightKg = (_lengthCm * _widthCm * _heightCm * _packageCount) / 6000.0;

    String containerRecommendation;
    Color recColor;
    if (totalCbm < 15) {
      containerRecommendation = 'LCL Consolidation (Less than Container Load)';
      recColor = AppColors.oceanBlue;
    } else if (totalCbm <= 33 && totalWeightKg <= 28000) {
      containerRecommendation = '1x 20ft Standard Container (Capacity: 33 CBM)';
      recColor = AppColors.successGreen;
    } else if (totalCbm <= 67 && totalWeightKg <= 28500) {
      containerRecommendation = '1x 40ft Standard Container (Capacity: 67 CBM)';
      recColor = AppColors.gold;
    } else {
      containerRecommendation = '1x 40ft High Cube (HC) Container (Capacity: 76 CBM)';
      recColor = AppColors.tradeTeal;
    }

    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: AppBar(
        title: const Text('Container Freight & Incoterms 2020'),
        actions: const [
          ThemeToggleButton(transparentBackground: true),
          SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // CBM Calculator Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.tradeTeal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.view_in_ar, color: AppColors.tradeTeal, size: 22),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'CBM & Volumetric Cargo Calculator',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Dimension Sliders
                _buildSliderRow(
                  label: 'Length',
                  value: _lengthCm,
                  unit: 'cm',
                  min: 10,
                  max: 200,
                  onChanged: (v) => setState(() => _lengthCm = v),
                ),
                _buildSliderRow(
                  label: 'Width',
                  value: _widthCm,
                  unit: 'cm',
                  min: 10,
                  max: 150,
                  onChanged: (v) => setState(() => _widthCm = v),
                ),
                _buildSliderRow(
                  label: 'Height',
                  value: _heightCm,
                  unit: 'cm',
                  min: 10,
                  max: 150,
                  onChanged: (v) => setState(() => _heightCm = v),
                ),
                _buildSliderRow(
                  label: 'Packages',
                  value: _packageCount,
                  unit: 'cartons',
                  min: 1,
                  max: 500,
                  onChanged: (v) => setState(() => _packageCount = v),
                ),
                _buildSliderRow(
                  label: 'Weight/Carton',
                  value: _grossWeightPerCartonKg,
                  unit: 'kg',
                  min: 1,
                  max: 60,
                  onChanged: (v) => setState(() => _grossWeightPerCartonKg = v),
                ),

                const SizedBox(height: 12),
                // Computed Output Pill
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
                          _buildStatUnit('Total Volume', '${totalCbm.toStringAsFixed(2)} CBM'),
                          _buildStatUnit('Total Weight', '${totalWeightKg.toStringAsFixed(0)} kg'),
                          _buildStatUnit('Air Volumetric', '${volumetricAirWeightKg.toStringAsFixed(0)} kg'),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Icon(Icons.directions_boat, size: 18, color: recColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recommended Stowage Mode:',
                                  style: TextStyle(fontSize: 10, color: context.textSecondary),
                                ),
                                Text(
                                  containerRecommendation,
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: recColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Incoterms 2020 Rules Section
          Text(
            'Incoterms 2020 Rules Matrix',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.textPrimary),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['EXW', 'FOB', 'CFR', 'CIF', 'DAP', 'DDP'].map((term) {
                final isSel = _selectedIncoterm == term;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(term),
                    selected: isSel,
                    selectedColor: AppColors.deepNavy,
                    backgroundColor: context.surfaceColor,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                      color: isSel ? Colors.white : context.textPrimary,
                    ),
                    side: BorderSide(color: isSel ? AppColors.deepNavy : context.borderColor),
                    onSelected: (_) => setState(() => _selectedIncoterm = term),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.tradeTeal.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _selectedIncoterm,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.tradeTeal),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Official ICC Incoterm Clause', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _incotermDescriptions[_selectedIncoterm] ?? '',
                  style: TextStyle(fontSize: 12, color: context.textPrimary, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Freight Benchmarks Section
          Text(
            'Live Freight Rate Benchmarks',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.textPrimary),
          ),
          const SizedBox(height: 10),
          ...state.freightRoutes.map((route) {
            final isAir = route.mode.contains('Air');
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isAir ? AppColors.oceanBlue : AppColors.deepNavy).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isAir ? Icons.airplanemode_active : Icons.directions_boat,
                      color: isAir ? AppColors.oceanBlue : AppColors.deepNavy,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${route.origin} → ${route.destination}',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: context.textPrimary),
                        ),
                        Text(
                          '${route.carrier} • ${route.transitDays}d transit • ${route.mode}',
                          style: TextStyle(fontSize: 11, color: context.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isAir ? '\$${route.ratePerTeu.toStringAsFixed(2)}/kg' : '\$${route.ratePerTeu.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: isAir ? AppColors.oceanBlue : AppColors.successGreen,
                        ),
                      ),
                      Text(
                        isAir ? 'Express' : 'Per TEU',
                        style: TextStyle(fontSize: 10, color: context.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required String unit,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.textSecondary)),
            Text('${value.toInt()} $unit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: context.textPrimary)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.tradeTeal,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildStatUnit(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: context.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.textPrimary)),
      ],
    );
  }
}
