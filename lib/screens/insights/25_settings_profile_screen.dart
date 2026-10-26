import 'package:flutter/material.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../access/02_login_screen.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('TradeLink Support Desk'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Direct Broker Concierge:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            SizedBox(height: 4),
            Text('Email: support@tradelink.pk\nHotline: +92 21 3588 1234\nWhatsApp: +92 300 1234567', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
            SizedBox(height: 12),
            Text('Customs HS & Incoterms 2020 regulatory advisory available 24/7.', style: TextStyle(fontSize: 11)),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out of TradeLink?'),
        content: const Text('Active JWT and refresh tokens will be revoked from device keychain and server sessions table.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final state = TradeStateInherited.of(context);
              state.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.alertRed),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final user = state.currentUser;

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('25. Settings & Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.deepNavy,
                    child: Text(
                      user.fullName.substring(0, 2).toUpperCase(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                        const SizedBox(height: 2),
                        Text(user.email, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.tealTint,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${user.companyName} • ${user.accountTier}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondaryLight),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // App Preferences Toggles
            const Text('App & Security Preferences', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Real-time deal acceptances & vessel alerts', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                    value: user.pushNotifications,
                    activeThumbColor: AppColors.tradeTeal,
                    onChanged: (val) => setState(() => user.pushNotifications = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Face ID / Biometric Login', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Fast Secure Enclave authentication', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                    value: user.faceIdLogin,
                    activeThumbColor: AppColors.tradeTeal,
                    onChanged: (val) => setState(() => user.faceIdLogin = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Dark Mode Display', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('High contrast dark theme palette', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                    value: user.darkMode,
                    activeThumbColor: AppColors.tradeTeal,
                    onChanged: (val) => setState(() => user.darkMode = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Weekly Email Digest', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Commission reconciliation report to inbox', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                    value: user.emailReports,
                    activeThumbColor: AppColors.tradeTeal,
                    onChanged: (val) => setState(() => user.emailReports = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Regional & Currency
            const Text('Localization & Currency', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Default Base Currency', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      DropdownButton<String>(
                        value: user.defaultCurrency,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                          DropdownMenuItem(value: 'PKR', child: Text('PKR (₨)')),
                          DropdownMenuItem(value: 'EUR', child: Text('EUR (€)')),
                          DropdownMenuItem(value: 'AED', child: Text('AED (د.إ)')),
                        ],
                        onChanged: (val) => setState(() => user.defaultCurrency = val!),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Language', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      DropdownButton<String>(
                        value: user.preferredLanguage,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'English', child: Text('English (US)')),
                          DropdownMenuItem(value: 'Urdu', child: Text('اردو (Pakistan)')),
                          DropdownMenuItem(value: 'Arabic', child: Text('العربية (Middle East)')),
                        ],
                        onChanged: (val) => setState(() => user.preferredLanguage = val!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Support & Sign Out
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help_outline, color: AppColors.deepNavy),
                    title: const Text('Help & 24/7 Broker Support', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: _showHelpDialog,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.deepNavy),
                    title: const Text('Cross-Border Compliance & Terms', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.alertRed),
                    title: const Text('Log Out Securely', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.alertRed)),
                    onTap: _confirmLogout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
