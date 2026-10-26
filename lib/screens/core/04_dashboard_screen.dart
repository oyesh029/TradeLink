import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../access/01_splash_screen.dart';
import '../access/02_login_screen.dart';
import '../access/03_registration_screen.dart';
import '05_client_management_screen.dart';
import '06_client_profile_screen.dart';
import '07_supplier_directory_screen.dart';
import '08_product_catalog_screen.dart';
import '../deal_cycle/09_inquiries_rfq_screen.dart';
import '../deal_cycle/10_quotation_builder_screen.dart';
import '../deal_cycle/11_negotiation_chat_screen.dart';
import '../deal_cycle/12_orders_screen.dart';
import '../deal_cycle/13_order_details_screen.dart';
import '../logistics/14_shipment_tracking_screen.dart';
import '../logistics/15_documents_screen.dart';
import '../logistics/16_customs_hs_screen.dart';
import '../finance/17_commission_calculator_screen.dart';
import '../finance/18_earnings_ledger_screen.dart';
import '../finance/19_invoices_screen.dart';
import '../finance/20_payments_screen.dart';
import '../finance/21_currency_rates_screen.dart';
import '../insights/22_reports_analytics_screen.dart';
import '../insights/23_notifications_screen.dart';
import '../insights/24_calendar_tasks_screen.dart';
import '../insights/25_settings_profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedCategory = 'All';
  String _searchModuleQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final user = state.currentUser;

    // Build the master list of all 25 modules
    final allModules = [
      _ModuleItem(
        num: '01',
        title: 'Splash Screen',
        category: 'Access & Onboarding',
        desc: 'Animated branding, token check & startup sequence',
        icon: Icons.launch_rounded,
        iconColor: AppColors.deepNavy,
        tint: const Color(0xFFF1F5F9),
        builder: (_) => const SplashScreen(),
      ),
      _ModuleItem(
        num: '02',
        title: 'Login & Authentication',
        category: 'Access & Onboarding',
        desc: 'Role switcher (Agent / Importer / Exporter) & Biometric Face ID',
        icon: Icons.lock_open_rounded,
        iconColor: AppColors.deepNavy,
        tint: const Color(0xFFF1F5F9),
        builder: (_) => const LoginScreen(),
      ),
      _ModuleItem(
        num: '03',
        title: 'User Registration',
        category: 'Access & Onboarding',
        desc: 'Onboard broker agency or corporate trading entity',
        icon: Icons.person_add_rounded,
        iconColor: AppColors.deepNavy,
        tint: const Color(0xFFF1F5F9),
        builder: (_) => const RegistrationScreen(),
      ),
      _ModuleItem(
        num: '05',
        title: 'Client Management',
        category: 'Core Business',
        desc: 'Buyer & seller directory, KYC status, trade volume & + Add Client',
        icon: Icons.people_alt_rounded,
        iconColor: AppColors.tradeTeal,
        tint: AppColors.tealTint,
        builder: (_) => const ClientManagementScreen(),
      ),
      _ModuleItem(
        num: '06',
        title: 'Client Profile (360°)',
        category: 'Core Business',
        desc: 'Al Noor Traders 360° dossier, notes tab, deals & paperwork',
        icon: Icons.badge_rounded,
        iconColor: AppColors.tradeTeal,
        tint: AppColors.tealTint,
        builder: (ctx) => ClientProfileScreen(client: state.clients.first),
      ),
      _ModuleItem(
        num: '07',
        title: 'Supplier Directory & Map',
        category: 'Core Business',
        desc: 'Verified manufacturers, factory audits & GPS map coordinates',
        icon: Icons.storefront_rounded,
        iconColor: AppColors.tradeTeal,
        tint: AppColors.tealTint,
        builder: (_) => const SupplierDirectoryScreen(),
      ),
      _ModuleItem(
        num: '08',
        title: 'Product Catalog',
        category: 'Core Business',
        desc: 'Commodity items, HS code tags, MOQ & "+ Add to Quote"',
        icon: Icons.inventory_2_rounded,
        iconColor: AppColors.tradeTeal,
        tint: AppColors.tealTint,
        builder: (_) => const ProductCatalogScreen(),
      ),
      _ModuleItem(
        num: '09',
        title: 'Inquiries & RFQ Pipeline',
        category: 'Deal Cycle',
        desc: 'Open buyer requests, urgency timers & Quotation triggers',
        icon: Icons.mark_email_unread_rounded,
        iconColor: AppColors.gold,
        tint: AppColors.goldTint,
        builder: (_) => const InquiriesRfqScreen(),
      ),
      _ModuleItem(
        num: '10',
        title: 'Quotation Builder (Q-1042)',
        category: 'Deal Cycle',
        desc: 'Incoterms 2020 (CIF/FOB), automated freight & commission PDF generator',
        icon: Icons.calculate_rounded,
        iconColor: AppColors.gold,
        tint: AppColors.goldTint,
        builder: (_) => const QuotationBuilderScreen(),
      ),
      _ModuleItem(
        num: '11',
        title: 'Deal Negotiation Chat',
        category: 'Deal Cycle',
        desc: 'Buyer-Seller-Broker live chat with interactive Counter-Offer cards',
        icon: Icons.chat_rounded,
        iconColor: AppColors.gold,
        tint: AppColors.goldTint,
        builder: (_) => const NegotiationChatScreen(),
      ),
      _ModuleItem(
        num: '12',
        title: 'Confirmed Orders',
        category: 'Deal Cycle',
        desc: 'ORD-5531 to ORD-5521 trade contracts, milestones & progress bars',
        icon: Icons.fact_check_rounded,
        iconColor: AppColors.gold,
        tint: AppColors.goldTint,
        builder: (_) => const OrdersScreen(),
      ),
      _ModuleItem(
        num: '13',
        title: 'Order Details & Execution',
        category: 'Deal Cycle',
        desc: 'Mandatory 6-stage order timeline & live shipment linking',
        icon: Icons.assignment_turned_in_rounded,
        iconColor: AppColors.gold,
        tint: AppColors.goldTint,
        builder: (ctx) => OrderDetailsScreen(order: state.orders.first),
      ),
      _ModuleItem(
        num: '14',
        title: 'Container Shipment Tracking',
        category: 'Logistics & Compliance',
        desc: 'Interactive sea route map (Karachi -> Jebel Ali), vessel GPS & ETA',
        icon: Icons.directions_boat_rounded,
        iconColor: AppColors.oceanBlue,
        tint: AppColors.blueTint,
        builder: (_) => const ShipmentTrackingScreen(),
      ),
      _ModuleItem(
        num: '15',
        title: 'Trade Documents Vault',
        category: 'Logistics & Compliance',
        desc: 'Invoices, B/L, packing lists, LC MT700, verify/reject & camera scanner',
        icon: Icons.folder_shared_rounded,
        iconColor: AppColors.oceanBlue,
        tint: AppColors.blueTint,
        builder: (_) => const DocumentsScreen(),
      ),
      _ModuleItem(
        num: '16',
        title: 'Customs & HS Code Tariff',
        category: 'Logistics & Compliance',
        desc: 'HS 9405.42 verification, import duty breakdowns & 5-point checklist',
        icon: Icons.policy_rounded,
        iconColor: AppColors.oceanBlue,
        tint: AppColors.blueTint,
        builder: (_) => const CustomsHsScreen(),
      ),
      _ModuleItem(
        num: '17',
        title: 'Commission Calculator',
        category: 'Finance',
        desc: 'Deal value input, rate slider, 90/10 fee donut chart & Save to Deal',
        icon: Icons.pie_chart_rounded,
        iconColor: AppColors.successGreen,
        tint: AppColors.greenTint,
        builder: (_) => const CommissionCalculatorScreen(),
      ),
      _ModuleItem(
        num: '18',
        title: 'Earnings Ledger',
        category: 'Finance',
        desc: '\$12,430 monthly earnings, +14.2% MoM & itemized commission reconciliation',
        icon: Icons.account_balance_wallet_rounded,
        iconColor: AppColors.successGreen,
        tint: AppColors.greenTint,
        builder: (_) => const EarningsLedgerScreen(),
      ),
      _ModuleItem(
        num: '19',
        title: 'Trade & Commission Invoices',
        category: 'Finance',
        desc: 'Paid (\$68K), Unpaid (\$21K), Overdue (\$6K) tiles & invoice generator',
        icon: Icons.receipt_long_rounded,
        iconColor: AppColors.successGreen,
        tint: AppColors.greenTint,
        builder: (_) => const InvoicesScreen(),
      ),
      _ModuleItem(
        num: '20',
        title: 'Cross-Border Payments & Escrow',
        category: 'Finance',
        desc: 'LC, TT & 50% staged Escrow release vault with 256-bit encryption',
        icon: Icons.lock_rounded,
        iconColor: AppColors.successGreen,
        tint: AppColors.greenTint,
        builder: (_) => const PaymentsScreen(),
      ),
      _ModuleItem(
        num: '21',
        title: 'Currency Rates & FX Converter',
        category: 'Finance',
        desc: 'USD to PKR / AED / EUR converter & live interbank sparkline trends',
        icon: Icons.currency_exchange_rounded,
        iconColor: AppColors.successGreen,
        tint: AppColors.greenTint,
        builder: (_) => const CurrencyRatesScreen(),
      ),
      _ModuleItem(
        num: '22',
        title: 'Reports & Analytics',
        category: 'Insights & Utilities',
        desc: 'Deal volume chart, trade country donut (UAE 38%) & conversion metrics',
        icon: Icons.analytics_rounded,
        iconColor: AppColors.deepNavy,
        tint: const Color(0xFFF1F5F9),
        builder: (_) => const ReportsAnalyticsScreen(),
      ),
      _ModuleItem(
        num: '23',
        title: 'Alert Center & Notifications',
        category: 'Insights & Utilities',
        desc: 'Today vs Earlier chronological deal, payment & shipment alerts',
        icon: Icons.notifications_active_rounded,
        iconColor: AppColors.deepNavy,
        tint: const Color(0xFFF1F5F9),
        builder: (_) => const NotificationsScreen(),
      ),
      _ModuleItem(
        num: '24',
        title: 'Trade Calendar & Tasks',
        category: 'Insights & Utilities',
        desc: 'Monthly deadline dots (LC expiry, shipments) & daily broker checklist',
        icon: Icons.event_note_rounded,
        iconColor: AppColors.deepNavy,
        tint: const Color(0xFFF1F5F9),
        builder: (_) => const CalendarTasksScreen(),
      ),
      _ModuleItem(
        num: '25',
        title: 'Settings & Profile',
        category: 'Insights & Utilities',
        desc: 'User identity card, Face ID, dark mode, language & secure sign-out',
        icon: Icons.manage_accounts_rounded,
        iconColor: AppColors.deepNavy,
        tint: const Color(0xFFF1F5F9),
        builder: (_) => const SettingsProfileScreen(),
      ),
    ];

    // Filter modules by category and search keyword
    final filteredModules = allModules.where((mod) {
      final matchesSearch = mod.title.toLowerCase().contains(_searchModuleQuery.toLowerCase()) ||
          mod.num.contains(_searchModuleQuery) ||
          mod.desc.toLowerCase().contains(_searchModuleQuery.toLowerCase()) ||
          mod.category.toLowerCase().contains(_searchModuleQuery.toLowerCase());
      if (!matchesSearch) return false;

      if (_selectedCategory == 'All') return true;
      if (_selectedCategory == 'Core' && mod.category == 'Core Business') return true;
      if (_selectedCategory == 'Deal Cycle' && mod.category == 'Deal Cycle') return true;
      if (_selectedCategory == 'Logistics' && mod.category == 'Logistics & Compliance') return true;
      if (_selectedCategory == 'Finance' && mod.category == 'Finance') return true;
      if (_selectedCategory == 'Insights' && mod.category == 'Insights & Utilities') return true;
      if (_selectedCategory == 'Access' && mod.category == 'Access & Onboarding') return true;
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${user.fullName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.successGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${user.companyName} • ${user.role == UserRole.agent ? 'Commission Agent' : user.role == UserRole.importer ? 'Importer / Buyer' : 'Exporter / Supplier'}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined, size: 24),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.alertRed,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${state.notifications.where((n) => !n.isRead).length}',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4 Real-Time KPI Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: user.role == UserRole.importer ? 'Active Orders' : 'Active Deals',
                    value: '24',
                    badge: '+12%',
                    badgePositive: true,
                    icon: Icons.handshake_outlined,
                    iconColor: AppColors.tradeTeal,
                    tint: AppColors.tealTint,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: user.role == UserRole.importer ? 'Trade Spend' : 'Commission',
                    value: user.role == UserRole.importer ? '\$240K' : '\$12.4K',
                    badge: '+8%',
                    badgePositive: true,
                    icon: Icons.payments_outlined,
                    iconColor: AppColors.gold,
                    tint: AppColors.goldTint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'In Transit',
                    value: '9',
                    badge: '4 Ports',
                    badgePositive: true,
                    icon: Icons.directions_boat_outlined,
                    iconColor: AppColors.oceanBlue,
                    tint: AppColors.blueTint,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Pending Docs',
                    value: '6',
                    badge: '2 Urgent',
                    badgePositive: false,
                    icon: Icons.description_outlined,
                    iconColor: AppColors.alertRed,
                    tint: AppColors.redTint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ALL 25 TRADELINK MODULES DIRECTORY SECTION (FEATURED DIRECTLY ON DASHBOARD)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.apps_rounded, color: AppColors.tradeTeal, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'All TradeLink Modules (25)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepNavy,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.tealTint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${filteredModules.length} Modules',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tap any module to open its interactive screen. Press < on any screen to return here.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                  ),
                  const SizedBox(height: 12),

                  // Module Search Input
                  TextField(
                    onChanged: (val) => setState(() => _searchModuleQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search module by name or # (e.g. 08, catalog, tracking)...',
                      prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textSecondaryLight),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip('All (25)', 'All'),
                        const SizedBox(width: 6),
                        _buildCategoryChip('Core (05-08)', 'Core'),
                        const SizedBox(width: 6),
                        _buildCategoryChip('Deal Cycle (09-13)', 'Deal Cycle'),
                        const SizedBox(width: 6),
                        _buildCategoryChip('Logistics (14-16)', 'Logistics'),
                        const SizedBox(width: 6),
                        _buildCategoryChip('Finance (17-21)', 'Finance'),
                        const SizedBox(width: 6),
                        _buildCategoryChip('Insights (22-25)', 'Insights'),
                        const SizedBox(width: 6),
                        _buildCategoryChip('Access (01-03)', 'Access'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Module List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredModules.length,
                    separatorBuilder: (_, __) => const Divider(height: 12, color: Color(0xFFF1F5F9)),
                    itemBuilder: (context, index) {
                      final mod = filteredModules[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: mod.builder),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Row(
                            children: [
                              // Module Number Badge & Icon
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: mod.tint,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(mod.icon, color: mod.iconColor, size: 22),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 3,
                                      child: Text(
                                        mod.num,
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                          color: mod.iconColor.withValues(alpha: 0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Title and description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${mod.num}. ${mod.title}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.deepNavy,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            mod.category,
                                            style: const TextStyle(fontSize: 8.5, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      mod.desc,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                                    ),
                                  ],
                                ),
                              ),

                              // Forward Chevron Arrow
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: Color(0xFF94A3B8),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Monthly Commission 6-Month Bar Chart
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Commission Growth',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                          ),
                          Text(
                            'Last 6 months performance',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.tealTint,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '+14.2% MoM',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Interactive Custom Bar Chart
                  SizedBox(
                    height: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBar('May', 0.45, '\$6.2K'),
                        _buildBar('Jun', 0.60, '\$8.1K'),
                        _buildBar('Jul', 0.55, '\$7.4K'),
                        _buildBar('Aug', 0.75, '\$9.8K'),
                        _buildBar('Sep', 0.85, '\$10.8K'),
                        _buildBar('Oct', 1.00, '\$12.4K', isHighlighted: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recent Activity Feed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                    );
                  },
                  child: const Text('View All', style: TextStyle(color: AppColors.tradeTeal, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _buildActivityItem(
              title: 'Quotation Accepted (Q-1042)',
              detail: 'Al Noor Traders approved 8,000 pcs LED panels • Commission \$1,235',
              time: '15m ago',
              icon: Icons.check_circle_outline,
              iconColor: AppColors.successGreen,
              tint: AppColors.greenTint,
            ),
            _buildActivityItem(
              title: 'Escrow Milestone Released',
              detail: 'ORD-5530 advance payment \$6,500 released to Mumbai Spices',
              time: '2h ago',
              icon: Icons.lock_open_outlined,
              iconColor: AppColors.gold,
              tint: AppColors.goldTint,
            ),
            _buildActivityItem(
              title: 'Vessel Departed Seaport',
              detail: 'MV Ocean Star carrying MSKU-7781452 departed Karachi for Jebel Ali',
              time: '4h ago',
              icon: Icons.directions_boat_outlined,
              iconColor: AppColors.oceanBlue,
              tint: AppColors.blueTint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, String key) {
    final isSelected = _selectedCategory == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepNavy : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String badge,
    required bool badgePositive,
    required IconData icon,
    required Color iconColor,
    required Color tint,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: badgePositive ? AppColors.greenTint : AppColors.redTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: badgePositive ? AppColors.successGreen : AppColors.alertRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.deepNavy,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String month, double heightFactor, String value, {bool isHighlighted = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: isHighlighted ? AppColors.tradeTeal : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 24,
          height: 80 * heightFactor,
          decoration: BoxDecoration(
            color: isHighlighted ? AppColors.tradeTeal : const Color(0xFFCBD5E1),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          month,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
            color: isHighlighted ? AppColors.deepNavy : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String detail,
    required String time,
    required IconData icon,
    required Color iconColor,
    required Color tint,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}

class _ModuleItem {
  final String num;
  final String title;
  final String category;
  final String desc;
  final IconData icon;
  final Color iconColor;
  final Color tint;
  final WidgetBuilder builder;

  const _ModuleItem({
    required this.num,
    required this.title,
    required this.category,
    required this.desc,
    required this.icon,
    required this.iconColor,
    required this.tint,
    required this.builder,
  });
}
