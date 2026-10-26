import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../deal_cycle/10_quotation_builder_screen.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  void _attachToQuotation(ProductModel product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add to Active Quotation?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.productName,
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.deepNavy),
            ),
            const SizedBox(height: 6),
            Text(
              'HS Code: ${product.hsCode} • Indicative: \$${product.indicativePrice.toStringAsFixed(2)}/${product.unit}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 12),
            const Text(
              'Attach item directly to active draft Quotation Q-1042?',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.productName} added to Quotation Q-1042 line items!'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            child: const Text('Add to Quote'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);

    final filteredProducts = state.products.where((p) {
      final matchesSearch = p.productName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.hsCode.contains(_searchQuery) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;
      if (_selectedCategory == 'All') return true;
      return p.category == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('Traded Products Catalog'),
      ),
      body: Column(
        children: [
          // Search & Category Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search product name, SKU, or HS code...',
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

          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return _buildProductCard(product);
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
          color: isSelected ? AppColors.deepNavy : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.deepNavy : const Color(0xFFCBD5E1)),
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

  Widget _buildProductCard(ProductModel p) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual Tile with Category & HS Badge
          Container(
            height: 95,
            decoration: BoxDecoration(
              color: p.cardTint,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    p.category == 'Electronics'
                        ? Icons.lightbulb_outline
                        : p.category == 'Food'
                            ? Icons.rice_bowl_outlined
                            : p.category == 'Textiles'
                                ? Icons.style_outlined
                                : Icons.foundation_outlined,
                    size: 42,
                    color: AppColors.deepNavy.withValues(alpha: 0.6),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'HS ${p.hsCode}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                ),
                const SizedBox(height: 3),
                Text(
                  p.supplierName,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Indicative Price', style: TextStyle(fontSize: 9, color: AppColors.textSecondaryLight)),
                        Text(
                          '\$${p.indicativePrice.toStringAsFixed(2)}/${p.unit}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.tradeTeal),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => _attachToQuotation(p),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.tealTint,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add_shopping_cart, size: 16, color: AppColors.tradeTeal),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
