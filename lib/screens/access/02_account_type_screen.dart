import 'package:flutter/material.dart';
import '../../database/local_database_service.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/tradelink_brand_logo.dart';
import '02_login_screen.dart';
import '03_registration_screen.dart';

class AccountTypeScreen extends StatefulWidget {
  final UserRole initialRole;

  const AccountTypeScreen({
    super.key,
    this.initialRole = UserRole.agent,
  });

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  late UserRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
    _loadSavedRole();
  }

  Future<void> _loadSavedRole() async {
    final savedRole = await LocalDatabaseService.instance.getLastSelectedRole();
    if (savedRole != null && mounted) {
      setState(() {
        _selectedRole = savedRole;
      });
    }
  }

  void _proceedToLogin() {
    LocalDatabaseService.instance.saveLastSelectedRole(_selectedRole);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(selectedRole: _selectedRole),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TradeState? tradeState;
    try {
      tradeState = TradeStateInherited.of(context);
    } catch (_) {
      tradeState = null;
    }
    final isDark = tradeState?.isDarkMode ?? (Theme.of(context).brightness == Brightness.dark);

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      body: SafeArea(
        child: Stack(
          children: [
            // Top Right Corner Theme Toggle Button
            const Positioned(
              top: 14,
              right: 18,
              child: ThemeToggleButton(),
            ),

            // Main Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),

                      // Brand Icon
                      const Center(
                        child: TradeLinkLogo(size: 60),
                      ),
                      const SizedBox(height: 16),

                      // Step Pill
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.tradeTeal.withValues(alpha: 0.15)
                                : AppColors.tealTint,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.tradeTeal.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Text(
                            'STEP 1 OF 2 • SELECT ACCOUNT TYPE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.tradeTeal,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        'Select Account Type',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        'Choose whether you need to continue as a Commission Agent, Importer, or Exporter to personalize your workspace.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Account Type 1: Commission Agent
                      _buildAccountTypeCard(
                        role: UserRole.agent,
                        title: 'Commission Agent',
                        roleSubtitle: 'Licensed Trade Broker & Deal Mediator',
                        description:
                            'Connect buyers with suppliers, orchestrate 3-way commission ledgers, issue Proforma Invoices, and monitor deal cycles.',
                        icon: Icons.business_center_rounded,
                        badges: ['Full Access', 'Broker Suite', 'Commission Ledger'],
                        accentColor: AppColors.tradeTeal,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),

                      // Account Type 2: Importer
                      _buildAccountTypeCard(
                        role: UserRole.importer,
                        title: 'Importer (Buyer)',
                        roleSubtitle: 'Commodity Buyer & Escrow Consignee',
                        description:
                            'Submit Requests for Quotation (RFQs), negotiate CIF/FOB pricing, track port shipments via PSW/Maersk, and release escrow.',
                        icon: Icons.shopping_bag_rounded,
                        badges: ['Buyer Portal', 'RFQs & Escrow', 'Cargo Tracking'],
                        accentColor: AppColors.oceanBlue,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),

                      // Account Type 3: Exporter
                      _buildAccountTypeCard(
                        role: UserRole.exporter,
                        title: 'Exporter (Supplier)',
                        roleSubtitle: 'Manufacturer, Producer & Shipper',
                        description:
                            'Showcase B2B product catalogs, respond to buyer inquiries, generate commercial invoices, and upload Bills of Lading.',
                        icon: Icons.factory_rounded,
                        badges: ['Supplier Portal', 'Catalog Showcase', 'Customs Dispatch'],
                        accentColor: AppColors.gold,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),

                      // Account Type 4: Platform Administrator
                      _buildAccountTypeCard(
                        role: UserRole.admin,
                        title: 'Platform Administrator',
                        roleSubtitle: 'Governance, System Audit & AML Authority',
                        description:
                            'Full-scale governance console: audit multi-bank letters of credit, arbitrate contract disputes, supervise user registries and system ledgers.',
                        icon: Icons.admin_panel_settings_rounded,
                        badges: ['Root Authority', 'AML & Sanctions', 'System Audit'],
                        accentColor: const Color(0xFF8B5CF6),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 24),

                      // Primary Action: Continue Button
                      ElevatedButton(
                        onPressed: _proceedToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tradeTeal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue as ${_getRoleTitle(_selectedRole)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Local Database Status Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.cardDark
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF2E3856)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.successGreen,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Connected to Local Database • Fast offline credentials verification',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Footer link to register
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Need a new organization account? ',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegistrationScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Register Organization',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.tradeTeal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTypeCard({
    required UserRole role,
    required String title,
    required String roleSubtitle,
    required String description,
    required IconData icon,
    required List<String> badges,
    required Color accentColor,
    required bool isDark,
  }) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedRole = role);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? const Color(0xFF162544)
                  : const Color(0xFFF0FDF4))
              : (isDark
                  ? AppColors.cardDark
                  : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.tradeTeal
                : (isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.tradeTeal.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Role Icon Box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.tradeTeal.withValues(alpha: 0.15)
                        : (isDark ? const Color(0xFF242E4C) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 26,
                    color: isSelected ? AppColors.tradeTeal : accentColor,
                  ),
                ),
                const SizedBox(width: 14),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.tradeTeal : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.tradeTeal
                                    : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 14, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        roleSubtitle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.tradeTeal
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),

            // Badges
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: badges.map((badge) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getRoleTitle(UserRole role) {
    switch (role) {
      case UserRole.importer:
        return 'Importer';
      case UserRole.exporter:
        return 'Exporter';
      case UserRole.admin:
        return 'Admin';
      case UserRole.agent:
        return 'Commission Agent';
    }
  }
}
