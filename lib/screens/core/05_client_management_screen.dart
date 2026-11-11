import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '06_client_profile_screen.dart';
import '07_supplier_directory_screen.dart';
import '08_product_catalog_screen.dart';

class ClientManagementScreen extends StatefulWidget {
  const ClientManagementScreen({super.key});

  @override
  State<ClientManagementScreen> createState() => _ClientManagementScreenState();
}

class _ClientManagementScreenState extends State<ClientManagementScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  void _confirmDeleteClient(BuildContext context, ClientModel client, TradeState state) {
    final isDark = state.isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.redTint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_forever_rounded, color: AppColors.alertRed, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Remove Trader?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.deepNavy,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to remove "${client.companyName}" (${client.role}) from the local SQLite database? All linked trade volume records will be permanently removed.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await state.removeClient(client.clientId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('${client.companyName} removed from database.'),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.alertRed,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.alertRed),
            child: const Text('Remove from DB'),
          ),
        ],
      ),
    );
  }

  void _showAddClientDialog() {
    final companyController = TextEditingController();
    final countryController = TextEditingController();
    final contactController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    String role = 'Importer';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Onboard New Client Organization'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(labelText: 'Company Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: countryController,
                  decoration: const InputDecoration(labelText: 'Country & City (e.g. Dubai, UAE)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(labelText: 'Client Role', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'Importer', child: Text('Importer (Buyer)')),
                    DropdownMenuItem(value: 'Exporter', child: Text('Exporter (Seller)')),
                  ],
                  onChanged: (val) => setDialogState(() => role = val!),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: 'Contact Person Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (companyController.text.isNotEmpty) {
                  final newClient = ClientModel(
                    clientId: 'cli-${DateTime.now().millisecondsSinceEpoch}',
                    companyName: companyController.text.trim(),
                    country: countryController.text.trim(),
                    countryCode: 'XX',
                    role: role,
                    status: 'Active',
                    contactPerson: contactController.text.trim(),
                    email: emailController.text.trim(),
                    phone: phoneController.text.trim(),
                    tradeLicense: 'LIC-${DateTime.now().millisecondsSinceEpoch % 100000}',
                    paymentTerms: 'LC at sight / 30 days',
                    totalDeals: 1,
                    tradeVolumeUsd: 15000.0,
                    rating: 5.0,
                    notes: ['Newly onboarded client.'],
                  );
                  final state = TradeStateInherited.of(context);
                  await state.addClient(newClient);
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                  }
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('${newClient.companyName} added and saved to database!'),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.successGreen,
                    ),
                  );
                }
              },
              child: const Text('Onboard Client'),
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

    final filteredClients = state.clients.where((client) {
      final matchesSearch = client.companyName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          client.country.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          client.contactPerson.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_selectedFilter == 'Importers') return client.role == 'Importer';
      if (_selectedFilter == 'Exporters') return client.role == 'Exporter';
      if (_selectedFilter == 'Active') return client.status == 'Active';
      return true;
    }).toList();

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
        title: const Text('Clients & Partners'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: 'Supplier Directory & Map',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SupplierDirectoryScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'Product Catalog',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductCatalogScreen()),
            ),
          ),
          const ThemeToggleButton(transparentBackground: true),
          const SizedBox(width: 6),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClientDialog,
        backgroundColor: AppColors.tradeTeal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Domain Feature Sub-Navigation
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.deepNavy,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Clients',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SupplierDirectoryScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Suppliers & Map',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProductCatalogScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: surfaceBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Products',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search & Filter Header
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search by client, country, or company...',
                    hintStyle: TextStyle(color: textSecondary),
                    prefixIcon: Icon(Icons.search, size: 20, color: textSecondary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: 18, color: textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: surfaceBg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Filter Chips Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All (${state.clients.length})', 'All', cardBg, borderColor, textPrimary, textSecondary),
                      const SizedBox(width: 8),
                      _buildFilterChip('Importers', 'Importers', cardBg, borderColor, textPrimary, textSecondary),
                      const SizedBox(width: 8),
                      _buildFilterChip('Exporters', 'Exporters', cardBg, borderColor, textPrimary, textSecondary),
                      const SizedBox(width: 8),
                      _buildFilterChip('Active Only', 'Active', cardBg, borderColor, textPrimary, textSecondary),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Client List
          Expanded(
            child: filteredClients.isEmpty
                ? Center(
                    child: Text(
                      'No clients match your filter criteria.',
                      style: TextStyle(color: textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = filteredClients[index];
                      return _buildClientCard(context, client, cardBg, borderColor, textPrimary, textSecondary, surfaceBg);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String key, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary) {
    final isSelected = _selectedFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tradeTeal : cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.tradeTeal : borderColor,
          ),
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

  Widget _buildClientCard(
    BuildContext context,
    ClientModel client,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    Color surfaceBg,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClientProfileScreen(client: client),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Logo, Name, Role Badge, Status Badge
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: client.role == 'Importer' ? AppColors.navyTint : AppColors.tealTint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        client.companyName.substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: client.role == 'Importer' ? AppColors.deepNavy : AppColors.tradeTeal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.companyName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: textSecondary),
                            const SizedBox(width: 3),
                            Text(
                              client.country,
                              style: TextStyle(fontSize: 12, color: textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: client.status == 'Active'
                          ? AppColors.successGreen.withValues(alpha: 0.15)
                          : AppColors.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      client.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: client.status == 'Active' ? AppColors.successGreen : AppColors.gold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.alertRed),
                    tooltip: 'Remove Trader from Database',
                    onPressed: () {
                      final state = TradeStateInherited.of(context);
                      _confirmDeleteClient(context, client, state);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: borderColor),
              const SizedBox(height: 12),

              // Row 2: Metrics Strip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: surfaceBg,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          client.role,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textPrimary),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${client.totalDeals} Deals',
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${(client.tradeVolumeUsd / 1000).toStringAsFixed(0)}K Volume',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.chevron_right, size: 18, color: textSecondary),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
