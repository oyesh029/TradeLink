import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';

class SupplierDirectoryScreen extends StatefulWidget {
  const SupplierDirectoryScreen({super.key});

  @override
  State<SupplierDirectoryScreen> createState() => _SupplierDirectoryScreenState();
}

class _SupplierDirectoryScreenState extends State<SupplierDirectoryScreen> {
  String _selectedCategory = 'All';
  bool _isMapView = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);

    final filteredSuppliers = state.suppliers.where((sup) {
      final matchesSearch = sup.companyName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sup.mainProducts.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sup.country.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;
      if (_selectedCategory == 'All') return true;
      return sup.category == _selectedCategory;
    }).toList();

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
        title: const Text('Supplier Directory'),
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.view_list_outlined : Icons.map_outlined),
            tooltip: _isMapView ? 'List View' : 'Map View',
            onPressed: () => setState(() => _isMapView = !_isMapView),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Search Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search verified manufacturers, cities, or goods...',
                    prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondaryLight),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCatChip('All'),
                      const SizedBox(width: 8),
                      _buildCatChip('Electronics'),
                      const SizedBox(width: 8),
                      _buildCatChip('Textiles'),
                      const SizedBox(width: 8),
                      _buildCatChip('Food'),
                      const SizedBox(width: 8),
                      _buildCatChip('Steel'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body: List or Interactive Map View
          Expanded(
            child: _isMapView
                ? _buildInteractiveMapView(filteredSuppliers)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    itemCount: filteredSuppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = filteredSuppliers[index];
                      return _buildSupplierCard(supplier);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatChip(String label) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tradeTeal : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.tradeTeal : const Color(0xFFCBD5E1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildSupplierCard(SupplierModel sup) {
    final isGold = sup.badge == 'GOLD';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isGold ? AppColors.goldTint : AppColors.tealTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.precision_manufacturing_outlined,
                  color: isGold ? AppColors.gold : AppColors.tradeTeal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sup.companyName,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${sup.city}, ${sup.country} • ${sup.category}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isGold ? AppColors.goldTint : AppColors.tealTint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isGold ? AppColors.gold : AppColors.tradeTeal, width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isGold ? Icons.workspace_premium : Icons.verified,
                      size: 13,
                      color: isGold ? AppColors.gold : AppColors.tradeTeal,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      sup.badge,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isGold ? AppColors.gold : AppColors.tradeTeal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            sup.mainProducts,
            style: const TextStyle(fontSize: 13, color: AppColors.deepNavy, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: AppColors.gold),
                  const SizedBox(width: 4),
                  Text(
                    '${sup.rating}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${sup.reviewsCount} reviews)',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                  ),
                ],
              ),
              Text(
                'Min. Order: \$${(sup.minOrderValue / 1000).toStringAsFixed(0)}K • Lead: ${sup.leadTimeDays}d',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.tradeTeal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveMapView(List<SupplierModel> suppliers) {
    return Container(
      color: const Color(0xFFE2E8F0),
      child: Stack(
        children: [
          // Simulated Stylized Vector Map Canvas
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                center: Alignment.center,
                radius: 1.2,
              ),
            ),
            child: Center(
              child: Opacity(
                opacity: 0.25,
                child: Icon(
                  Icons.public,
                  size: MediaQuery.of(context).size.width * 0.8,
                  color: AppColors.deepNavy,
                ),
              ),
            ),
          ),

          // Supplier Location Geo Pins
          Positioned(
            top: 100,
            left: 80,
            child: _buildMapPin(
              'Istanbul Steel A.S.',
              'Turkey',
              AppColors.gold,
            ),
          ),
          Positioned(
            top: 140,
            right: 90,
            child: _buildMapPin(
              'Shenzhen Tech Ltd',
              'China (Gold Tier)',
              AppColors.gold,
            ),
          ),
          Positioned(
            bottom: 180,
            left: 120,
            child: _buildMapPin(
              'Faisalabad Fabrics',
              'Pakistan',
              AppColors.tradeTeal,
            ),
          ),
          Positioned(
            bottom: 140,
            right: 140,
            child: _buildMapPin(
              'Mumbai Spices Co.',
              'India',
              AppColors.tradeTeal,
            ),
          ),

          // Bottom Sheet Card Preview
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_city, color: AppColors.tradeTeal, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Showing 4 Global Hubs',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                        ),
                        Text(
                          'Shenzhen, Faisalabad, Istanbul, Mumbai manufacturing facilities',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _isMapView = false),
                    child: const Text('View List', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(String name, String country, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.deepNavy,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$name\n$country',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        Icon(Icons.location_pin, color: color, size: 34),
      ],
    );
  }
}
