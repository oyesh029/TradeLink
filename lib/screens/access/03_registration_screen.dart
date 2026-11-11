import 'package:flutter/material.dart';
import '../../database/local_database_service.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '../shell/main_shell.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController(text: 'Awais Ahmad');
  final _companyController = TextEditingController(text: 'Noor Trader');
  final _phoneController = TextEditingController(text: '+92 300 1234567');
  final _emailController = TextEditingController(text: 'awais@tradelink.pk');
  final _passwordController = TextEditingController(text: 'SecretPass123!');
  UserRole _role = UserRole.agent;
  bool _agreeTerms = true;
  bool _enableFaceId = true;

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
      appBar: AppBar(
        title: const Text('Create TradeLink Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          ThemeToggleButton(transparentBackground: true),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Tagline
              const Text(
                'Join the Global B2B Broker Network',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepNavy,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select your organization role and enter company verification details.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 20),

              // Role Selector Cards
              Text(
                'Select Business Role',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildRoleSelectorCard(
                    title: 'Agent',
                    subtitle: 'Broker & Deals',
                    icon: Icons.handshake_outlined,
                    role: UserRole.agent,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildRoleSelectorCard(
                    title: 'Importer',
                    subtitle: 'Overseas Buyer',
                    icon: Icons.flight_land_outlined,
                    role: UserRole.importer,
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildRoleSelectorCard(
                    title: 'Exporter',
                    subtitle: 'Manufacturer',
                    icon: Icons.factory_outlined,
                    role: UserRole.exporter,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildRoleSelectorCard(
                    title: 'Administrator',
                    subtitle: 'Full Governance',
                    icon: Icons.admin_panel_settings_outlined,
                    role: UserRole.admin,
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Form Container
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _companyController,
                      label: 'Company Name',
                      icon: Icons.business_outlined,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Mobile Number (+ country code)',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Business Email',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),

                    // Password Strength Indicator
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.successGreen,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.successGreen,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.successGreen,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Strong',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Checkbox Preferences
              Material(
                color: isDark ? AppColors.cardDark : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _enableFaceId,
                      activeThumbColor: AppColors.tradeTeal,
                      title: Text(
                        'Enable Biometric Face ID Login',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                        ),
                      ),
                      subtitle: Text(
                        'Fast, cryptographic hardware-secured authentication',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      onChanged: (val) => setState(() => _enableFaceId = val),
                    ),
                    Divider(color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeTerms,
                          activeColor: AppColors.tradeTeal,
                          onChanged: (val) => setState(() => _agreeTerms = val ?? false),
                        ),
                        Expanded(
                          child: Text(
                            'I agree to TradeLink Terms of Service & Cross-Border Data Privacy Policy',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _agreeTerms
                    ? () async {
                        final rawPassword = _passwordController.text.trim();
                        final registeredPhone = _phoneController.text.trim();
                        final registeredEmail = _emailController.text.trim();

                        final newUser = UserProfile(
                          userId: 'usr-${DateTime.now().millisecondsSinceEpoch}',
                          fullName: _nameController.text.trim(),
                          email: registeredEmail,
                          companyName: _companyController.text.trim(),
                          phone: registeredPhone,
                          role: _role,
                          accountTier: _role == UserRole.admin ? 'Superadmin' : 'Verified Enterprise',
                          faceIdLogin: _enableFaceId,
                        );

                        await LocalDatabaseService.instance.registerUser(
                          newUser,
                          rawPassword,
                        );
                        await LocalDatabaseService.instance.saveLastSelectedRole(_role);

                        if (!context.mounted) return;
                        final state = TradeStateInherited.of(context);
                        state.setCurrentUser(newUser);

                        // Pop back to Login Screen so user can sign in with newly created credentials
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context, {
                            'registered': true,
                            'phone': registeredPhone,
                            'email': registeredEmail,
                            'password': rawPassword,
                            'role': _role,
                          });
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const MainShell()),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tradeTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Create Trade Account & Proceed to Sign In',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelectorCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required UserRole role,
    required bool isDark,
  }) {
    final isSelected = _role == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _role = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.tradeTeal.withValues(alpha: 0.2) : AppColors.tealTint)
                : (isDark ? AppColors.cardDark : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.tradeTeal : (isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.tradeTeal : (isDark ? const Color(0xFF94A3B8) : AppColors.textSecondaryLight),
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? (isDark ? Colors.white : AppColors.deepNavy)
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 14, color: isDark ? Colors.white : AppColors.deepNavy),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondaryLight),
            filled: true,
            fillColor: isDark ? const Color(0xFF131A2E) : const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: isDark ? const Color(0xFF2E3856) : const Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    );
  }
}
