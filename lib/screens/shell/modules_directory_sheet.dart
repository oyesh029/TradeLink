import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '../finance/17_commission_calculator_screen.dart';
import '../finance/18_earnings_ledger_screen.dart';
import '../finance/19_invoices_screen.dart';
import '../finance/20_payments_screen.dart';
import '../finance/21_currency_rates_screen.dart';
import '../insights/22_reports_analytics_screen.dart';
import '../insights/23_notifications_screen.dart';
import '../insights/24_calendar_tasks_screen.dart';
import '../insights/25_settings_profile_screen.dart';
import '../deal_cycle/26_dispute_arbitration_screen.dart';
import '../logistics/27_maritime_weather_radar_screen.dart';
import '../logistics/28_sanctions_compliance_screen.dart';
import '../finance/29_letter_of_credit_screen.dart';
import '../logistics/30_container_freight_screen.dart';
import '../deal_cycle/31_quality_inspection_screen.dart';

class ModulesDirectorySheet extends StatelessWidget {
  const ModulesDirectorySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const FinanceHubScreen();
  }
}

class FinanceHubScreen extends StatelessWidget {
  const FinanceHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.deepNavy;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

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
        title: const Text('Finance & Operations'),
        actions: const [
          ThemeToggleButton(transparentBackground: true),
          SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Financial Executive KPI Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0F1E36), const Color(0xFF1E293B)]
                    : [const Color(0xFF0F172A), const Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF2B4365) : Colors.transparent,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Financial Liquidity Overview',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Verified Ledger',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.successGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildKpiMini('Net Commission', '\$12,430', '+14.2% MoM', true),
                    _buildKpiMini('Escrow Vault', '\$32,500', '3 Contracts', true),
                    _buildKpiMini('Pending Invoices', '\$21,000', '4 Invoices', false),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 1: Financial Management & Settlements
          _buildSectionHeader('Financial Management & Settlements', textPrimary),
          const SizedBox(height: 8),
          _buildFeatureCard(
            context: context,
            title: 'Earnings Ledger',
            subtitle: '\$12,430 monthly receivables & itemized commission reconciliation',
            icon: Icons.account_balance_wallet_rounded,
            iconColor: AppColors.successGreen,
            tint: isDark ? AppColors.successGreen.withValues(alpha: 0.15) : AppColors.greenTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EarningsLedgerScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'Commission Calculator',
            subtitle: 'Deal value input, rate sliders, 90/10 split chart & save to quotation',
            icon: Icons.calculate_rounded,
            iconColor: AppColors.gold,
            tint: isDark ? AppColors.gold.withValues(alpha: 0.15) : AppColors.goldTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CommissionCalculatorScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'Trade & Commission Invoices',
            subtitle: 'Paid (\$68K), Unpaid (\$21K) & Overdue tracking with PDF generator',
            icon: Icons.receipt_long_rounded,
            iconColor: isDark ? const Color(0xFF93C5FD) : AppColors.deepNavy,
            tint: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InvoicesScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'Cross-Border Payments & Escrow',
            subtitle: 'LC, TT & 50% staged milestone escrow release vault with 256-bit encryption',
            icon: Icons.lock_clock_rounded,
            iconColor: AppColors.tradeTeal,
            tint: isDark ? AppColors.tradeTeal.withValues(alpha: 0.15) : AppColors.tealTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PaymentsScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'Currency Rates & FX Converter',
            subtitle: 'USD to PKR / AED / EUR interbank converter with live sparkline trends',
            icon: Icons.currency_exchange_rounded,
            iconColor: AppColors.oceanBlue,
            tint: isDark ? AppColors.oceanBlue.withValues(alpha: 0.15) : AppColors.blueTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CurrencyRatesScreen()),
            ),
          ),

          const SizedBox(height: 20),

          // Section 2: Risk, Compliance & Maritime Intelligence
          _buildSectionHeader('Risk, Compliance & Maritime Intelligence', textPrimary),
          const SizedBox(height: 8),
          _buildFeatureCard(
            context: context,
            title: 'Dispute & Arbitration Center',
            subtitle: 'Contested escrow deposits, commercial claim filing & ICC tribunal settlements',
            icon: Icons.balance_rounded,
            iconColor: AppColors.alertRed,
            tint: isDark ? AppColors.alertRed.withValues(alpha: 0.15) : AppColors.redTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DisputeArbitrationScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'Maritime Weather & Port Radar',
            subtitle: 'Live terminal dwell times, berth queues, typhoon tracking & demurrage fine calculator',
            icon: Icons.waves_rounded,
            iconColor: AppColors.tradeTeal,
            tint: isDark ? AppColors.tradeTeal.withValues(alpha: 0.15) : AppColors.tealTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MaritimeWeatherRadarScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'Sanctions & AML Compliance',
            subtitle: 'OFAC SDN list checks, UN/EU dual-use scrutiny & cryptographic compliance certificates',
            icon: Icons.security_rounded,
            iconColor: AppColors.gold,
            tint: isDark ? AppColors.gold.withValues(alpha: 0.15) : AppColors.goldTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SanctionsComplianceScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'Letter of Credit (LC) Advisor',
            subtitle: 'UCP 600 audit rules, discrepancy scanner & SWIFT MT707 amendment generator',
            icon: Icons.account_balance_rounded,
            iconColor: AppColors.oceanBlue,
            tint: isDark ? AppColors.oceanBlue.withValues(alpha: 0.15) : AppColors.blueTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LetterOfCreditScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'Container Freight & Incoterms 2020',
            subtitle: 'CBM volumetric calculator, FCL/LCL optimizer & ICC risk allocation matrix',
            icon: Icons.view_in_ar_rounded,
            iconColor: AppColors.tradeTeal,
            tint: isDark ? AppColors.tradeTeal.withValues(alpha: 0.15) : AppColors.tealTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContainerFreightScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'PSI Quality Audit & AQL 2.5',
            subtitle: 'ISO 2859-1 sample pull, defect scorecards & Certificate of Inspection (COI)',
            icon: Icons.fact_check_rounded,
            iconColor: AppColors.successGreen,
            tint: isDark ? AppColors.successGreen.withValues(alpha: 0.15) : AppColors.greenTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QualityInspectionScreen()),
            ),
          ),

          const SizedBox(height: 20),

          // Section 3: Trade Intelligence & Utilities
          _buildSectionHeader('Trade Intelligence & Utilities', textPrimary),
          const SizedBox(height: 8),
          _buildFeatureCard(
            context: context,
            title: 'Reports & Analytics',
            subtitle: 'Deal volume chart, trade country donut (UAE 38%) & conversion metrics',
            icon: Icons.analytics_rounded,
            iconColor: isDark ? const Color(0xFF93C5FD) : AppColors.deepNavy,
            tint: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportsAnalyticsScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'Trade Calendar & Tasks',
            subtitle: 'Monthly deadline markers (LC, shipments) & daily broker checklist',
            icon: Icons.calendar_month_rounded,
            iconColor: AppColors.tradeTeal,
            tint: isDark ? AppColors.tradeTeal.withValues(alpha: 0.15) : AppColors.tealTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarTasksScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'Alert Center & Notifications',
            subtitle: 'Real-time chronological deal, payment & vessel alerts',
            icon: Icons.notifications_active_rounded,
            iconColor: AppColors.alertRed,
            tint: isDark ? AppColors.alertRed.withValues(alpha: 0.15) : AppColors.redTint,
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          _buildFeatureCard(
            context: context,
            title: 'Settings & Security Profile',
            subtitle: 'User identity card, Face ID, dark mode, language & secure sign-out',
            icon: Icons.manage_accounts_rounded,
            iconColor: isDark ? const Color(0xFF93C5FD) : AppColors.deepNavy,
            tint: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsProfileScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildKpiMini(String label, String value, String sub, bool isPositive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isPositive ? const Color(0xFF4ADE80) : const Color(0xFFFCA5A5),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color tint,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: textSecondary),
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: textSecondary),
          onTap: onTap,
        ),
      ),
    );
  }
}
