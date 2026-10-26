import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../access/01_splash_screen.dart';
import '../access/02_login_screen.dart';
import '../access/03_registration_screen.dart';
import '../core/04_dashboard_screen.dart';
import '../core/05_client_management_screen.dart';
import '../core/06_client_profile_screen.dart';
import '../core/07_supplier_directory_screen.dart';
import '../core/08_product_catalog_screen.dart';
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
import '../../state/trade_state.dart';

class ModulesDirectorySheet extends StatelessWidget {
  const ModulesDirectorySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('TradeLink 25-Module Directory'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAreaHeader('Access & Onboarding (Modules 01 - 03)'),
          _buildModuleTile(context, '01', 'Splash Screen', 'Session validation & animated launch', Icons.launch, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
          }),
          _buildModuleTile(context, '02', 'Login', 'Role switching & Face ID login', Icons.login, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          }),
          _buildModuleTile(context, '03', 'Registration', 'Account & company onboarding', Icons.person_add, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen()));
          }),

          const SizedBox(height: 16),
          _buildAreaHeader('Core Business (Modules 04 - 08)'),
          _buildModuleTile(context, '04', 'Dashboard', '4 live KPI cards & 6-month earnings bar chart', Icons.dashboard_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
          }),
          _buildModuleTile(context, '05', 'Client Management', 'Searchable buyers & exporters directory', Icons.business_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientManagementScreen()));
          }),
          _buildModuleTile(context, '06', 'Client Profile', '4 tabs (Details, Deals, Docs, Notes)', Icons.badge_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ClientProfileScreen(client: state.clients.first)));
          }),
          _buildModuleTile(context, '07', 'Supplier Directory', 'Verified manufacturers & Map View', Icons.precision_manufacturing_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SupplierDirectoryScreen()));
          }),
          _buildModuleTile(context, '08', 'Product Catalog', 'Commodities grid with HS codes & pricing', Icons.inventory_2_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductCatalogScreen()));
          }),

          const SizedBox(height: 16),
          _buildAreaHeader('Deal Cycle (Modules 09 - 13)'),
          _buildModuleTile(context, '09', 'Inquiries / RFQ', 'Buyer RFQ pipeline counters & response triggers', Icons.mark_email_unread_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const InquiriesRfqScreen()));
          }),
          _buildModuleTile(context, '10', 'Quotation Builder', 'Incoterm CIF/FOB, commission & PDF preview', Icons.calculate_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()));
          }),
          _buildModuleTile(context, '11', 'Negotiation Chat', 'Real-time chat & Counter-Offer cards', Icons.chat_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NegotiationChatScreen()));
          }),
          _buildModuleTile(context, '12', 'Orders', 'Confirmed orders with visual progress bars', Icons.fact_check_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
          }),
          _buildModuleTile(context, '13', 'Order Details', '6-stage mandatory execution timeline', Icons.timeline_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: state.orders.first)));
          }),

          const SizedBox(height: 16),
          _buildAreaHeader('Logistics & Compliance (Modules 14 - 16)'),
          _buildModuleTile(context, '14', 'Shipment Tracking', 'Vessel AIS route map & milestone checkpoints', Icons.directions_boat_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ShipmentTrackingScreen()));
          }),
          _buildModuleTile(context, '15', 'Documents Vault', 'Invoices, B/L, Packing & mobile scanner', Icons.folder_open_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentsScreen()));
          }),
          _buildModuleTile(context, '16', 'Customs & HS Code', 'PSW duty calculator & 5-point compliance checklist', Icons.gavel_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomsHsScreen()));
          }),

          const SizedBox(height: 16),
          _buildAreaHeader('Finance & Ledger (Modules 17 - 21)'),
          _buildModuleTile(context, '17', 'Commission Calculator', 'Slider rates, presets & fee donut chart', Icons.pie_chart_outline, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CommissionCalculatorScreen()));
          }),
          _buildModuleTile(context, '18', 'Earnings Ledger', 'Receivables ledger & monthly MoM growth', Icons.account_balance_wallet_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const EarningsLedgerScreen()));
          }),
          _buildModuleTile(context, '19', 'Invoices', 'Paid, Unpaid & Overdue billing tracker', Icons.receipt_long_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const InvoicesScreen()));
          }),
          _buildModuleTile(context, '20', 'Payments & Escrow', 'Staged milestone escrow vault & 256-bit security', Icons.lock_clock_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentsScreen()));
          }),
          _buildModuleTile(context, '21', 'Currency Rates', 'Real-time multi-currency converter & live sparklines', Icons.currency_exchange_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CurrencyRatesScreen()));
          }),

          const SizedBox(height: 16),
          _buildAreaHeader('Insights & Utilities (Modules 22 - 25)'),
          _buildModuleTile(context, '22', 'Reports & Analytics', 'Trade intelligence charts & country donut breakdown', Icons.analytics_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsAnalyticsScreen()));
          }),
          _buildModuleTile(context, '23', 'Notifications', 'Real-time alerts grouped by Today & Earlier', Icons.notifications_none_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
          }),
          _buildModuleTile(context, '24', 'Calendar & Tasks', 'Monthly deadline markers & daily to-do checklist', Icons.calendar_today_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarTasksScreen()));
          }),
          _buildModuleTile(context, '25', 'Settings & Profile', 'Security toggles, currency, language & logout', Icons.settings_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsProfileScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildAreaHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.tradeTeal,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildModuleTile(BuildContext context, String number, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.deepNavy,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondaryLight),
        onTap: onTap,
      ),
    );
  }
}
