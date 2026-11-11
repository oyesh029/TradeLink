import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.tealTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.calculate_outlined, color: AppColors.tradeTeal, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Attach to Quotation', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                      Text('${product.productName} • HS ${product.hsCode}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Indicative Rate: \$${product.indicativePrice.toStringAsFixed(2)} / ${product.unit}\nDirect Supplier: ${product.supplierName}',
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tradeTeal,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Open Quotation Builder (CIF / FOB)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.deepNavy;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final surfaceBg = isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9);

    final filteredProducts = state.products.where((p) {
      final matchesSearch = p.productName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.hsCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;
      if (_selectedCategory == 'All') return true;
      return p.category == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
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
        title: const Text('Traded Products Catalog'),
        actions: const [
          ThemeToggleButton(transparentBackground: true),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search & Category Bar
          Container(
            color: cardBg,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search product name, SKU, or HS code...',
                    hintStyle: TextStyle(color: textSecondary),
                    prefixIcon: Icon(Icons.search, size: 20, color: textSecondary),
                    filled: true,
                    fillColor: surfaceBg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCatChip('All', cardBg, borderColor, textSecondary),
                      const SizedBox(width: 8),
                      _buildCatChip('Electronics', cardBg, borderColor, textSecondary),
                      const SizedBox(width: 8),
                      _buildCatChip('Textiles', cardBg, borderColor, textSecondary),
                      const SizedBox(width: 8),
                      _buildCatChip('Food', cardBg, borderColor, textSecondary),
                      const SizedBox(width: 8),
                      _buildCatChip('Steel', cardBg, borderColor, textSecondary),
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
                return _buildProductCard(product, cardBg, borderColor, textPrimary, textSecondary);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatChip(String label, Color cardBg, Color borderColor, Color textSecondary) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tradeTeal : cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.tradeTeal : borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel p, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
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
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
                ),
                const SizedBox(height: 3),
                Text(
                  p.supplierName,
                  style: TextStyle(fontSize: 10, color: textSecondary),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Indicative Price', style: TextStyle(fontSize: 9, color: textSecondary)),
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
