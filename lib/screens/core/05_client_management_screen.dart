import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '06_client_profile_screen.dart';

class ClientManagementScreen extends StatefulWidget {
  const ClientManagementScreen({super.key});

  @override
  State<ClientManagementScreen> createState() => _ClientManagementScreenState();
}

class _ClientManagementScreenState extends State<ClientManagementScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

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
              onPressed: () {
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
                  state.addClient(newClient);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${newClient.companyName} added successfully')),
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
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('Client Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClientDialog,
        backgroundColor: AppColors.tradeTeal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search by client, country, or company...',
                    prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondaryLight),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Filter Chips Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All (${state.clients.length})', 'All'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Importers', 'Importers'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Exporters', 'Exporters'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Active Only', 'Active'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Client List
          Expanded(
            child: filteredClients.isEmpty
                ? const Center(
                    child: Text('No clients match your filter criteria.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = filteredClients[index];
                      return _buildClientCard(context, client);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String key) {
    final isSelected = _selectedFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepNavy : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.deepNavy : const Color(0xFFCBD5E1),
          ),
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

  Widget _buildClientCard(BuildContext context, ClientModel client) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepNavy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondaryLight),
                            const SizedBox(width: 3),
                            Text(
                              client.country,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: client.status == 'Active' ? AppColors.greenTint : AppColors.goldTint,
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
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
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
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          client.role,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${client.totalDeals} Deals',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${(client.tradeVolumeUsd / 1000).toStringAsFixed(0)}K Volume',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondaryLight),
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
