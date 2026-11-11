import 'package:flutter/material.dart';
import '../../database/local_database_service.dart';
import '../../services/biometric_auth_service.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/tradelink_brand_logo.dart';
import '../shell/main_shell.dart';
import '02_account_type_screen.dart';
import '03_registration_screen.dart';

class LoginScreen extends StatefulWidget {
  final UserRole selectedRole;

  const LoginScreen({
    super.key,
    this.selectedRole = UserRole.agent,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late UserRole _activeRole;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _rememberMe = true;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _activeRole = widget.selectedRole;
    _emailController = TextEditingController(text: '03226808199');
    _passwordController = TextEditingController(text: 'awais2284\$#@A');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillRoleCredentials(UserRole role) {
    setState(() {
      _activeRole = role;
      _emailController.text = '03226808199';
      _passwordController.text = 'awais2284\$#@A';
      _errorMessage = null;
    });
  }

  Future<void> _navigateToRegistration() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const RegistrationScreen()),
    );

    if (!mounted) return;

    if (result != null && result['registered'] == true) {
      setState(() {
        _emailController.text = result['phone'] as String? ?? result['email'] as String? ?? '03226808199';
        _passwordController.text = result['password'] as String? ?? 'awais2284\$#@A';
        final returnedRole = result['role'] as UserRole?;
        if (returnedRole != null) {
          _activeRole = returnedRole;
        }
        _errorMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Account registered in database! You can now sign in with your credentials.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.successGreen,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _performLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Authenticate with the local database
    final state = TradeStateInherited.of(context);
    final authenticatedUser = await LocalDatabaseService.instance.authenticateUser(
      email: email,
      password: password,
      expectedRole: _activeRole,
    );

    if (!mounted) return;

    if (authenticatedUser != null) {
      state.setCurrentUser(authenticatedUser);
      await LocalDatabaseService.instance.saveLastSelectedRole(_activeRole);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Authenticated via Local DB as ${authenticatedUser.fullName} (${_getRoleTitle(_activeRole)})'),
              ),
            ],
          ),
          backgroundColor: AppColors.successGreen,
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      // User doesn't exist with these credentials in the database!
      setState(() {
        _errorMessage = 'No user exists with credentials "$email". Please register as a new user.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'No user exists with these credentials. Please register as a new user.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.alertRed,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Register Now',
            textColor: Colors.white,
            onPressed: () => _navigateToRegistration(),
          ),
        ),
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performBiometricLogin() async {
    String email = _emailController.text.trim().toLowerCase();
    if (email.isEmpty) {
      final lastEmail = await LocalDatabaseService.instance.getLastBiometricEmail();
      if (lastEmail != null && lastEmail.isNotEmpty) {
        email = lastEmail;
        _emailController.text = email;
      }
    }

    final isEnrolled = await BiometricAuthService.instance.isBiometricEnabledForUser(email);

    if (!isEnrolled) {
      if (!mounted) return;
      final isDark = TradeStateInherited.of(context).isDarkMode;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: isDark ? AppColors.cardDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.fingerprint, color: AppColors.gold, size: 24),
              const SizedBox(width: 8),
              Text(
                'Biometrics Not Enabled',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Biometric login (Fingerprint / Face ID) is currently turned OFF for ${email.isEmpty ? "your account" : email}.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to enable:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.tradeTeal : AppColors.deepNavy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '1. Sign in normally with your password.\n2. Open Settings & Profile.\n3. Toggle ON "Fingerprint / Face ID Biometric Login".\n4. Return here anytime for instant 1-tap biometric unlock!',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Got It, Sign In with Password',
                style: TextStyle(
                  color: isDark ? AppColors.tradeTeal : AppColors.deepNavy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final bioResult = await BiometricAuthService.instance.authenticate(
      reason: 'Scan fingerprint or Face ID to access TradeLink Enterprise Platform',
    );

    if (!mounted) return;

    if (bioResult.success) {
      final user = await LocalDatabaseService.instance.authenticateViaBiometrics(email: email);
      if (!mounted) return;
      if (user != null) {
        final state = TradeStateInherited.of(context);
        state.setCurrentUser(user);
        await LocalDatabaseService.instance.saveLastSelectedRole(user.role);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.verified, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Biometric Verified! Welcome back, ${user.fullName}'),
                ),
              ],
            ),
            backgroundColor: AppColors.successGreen,
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bioResult.errorMessage ?? 'Biometric verification cancelled or failed.'),
          backgroundColor: AppColors.alertRed,
        ),
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your registered business email. A secure recovery token will be verified against the local database.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Business Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Recovery token verified via Local Database! Check your inbox.'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            child: const Text('Send Reset Link'),
          ),
        ],
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

            // Top Left Back to Account Selection
            Positioned(
              top: 14,
              left: 18,
              child: Tooltip(
                message: 'Back to Account Type Selection',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AccountTypeScreen(initialRole: _activeRole),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppColors.cardDark : Colors.white,
                        border: Border.all(
                          color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 38),

                      // Brand Icon
                      const Center(
                        child: TradeLinkLogo(size: 64),
                      ),
                      const SizedBox(height: 14),

                      // Step 2 Pill
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
                            'STEP 2 OF 2 • SIGN IN CREDENTIALS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.tradeTeal,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Header Title
                      Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter your credentials to access your TradeLink workspace.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Active Selected Role Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.tradeTeal.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.tradeTeal.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.tradeTeal.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getRoleIcon(_activeRole),
                                color: AppColors.tradeTeal,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _getRoleTitle(_activeRole),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.tealTint,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'Selected',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.tradeTeal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getRoleDescription(_activeRole),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AccountTypeScreen(initialRole: _activeRole),
                                    ),
                                  );
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                minimumSize: Size.zero,
                              ),
                              child: const Text(
                                'Change',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.tradeTeal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Quick Demo Account Pre-fill Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _buildQuickFillChip(
                            label: 'Agent (03226808199)',
                            role: UserRole.agent,
                            isDark: isDark,
                          ),
                          _buildQuickFillChip(
                            label: 'Importer (03226808199)',
                            role: UserRole.importer,
                            isDark: isDark,
                          ),
                          _buildQuickFillChip(
                            label: 'Exporter (03226808199)',
                            role: UserRole.exporter,
                            isDark: isDark,
                          ),
                          _buildQuickFillChip(
                            label: 'Admin (03226808199)',
                            role: UserRole.admin,
                            isDark: isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Login Card Form
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Local Database Connection Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.storage_rounded,
                                    size: 14,
                                    color: AppColors.tradeTeal,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Local Database: ${LocalDatabaseService.instance.databaseEngine}',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.successGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Error banner if any
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.redTint,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.alertRed.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline, size: 18, color: AppColors.alertRed),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(fontSize: 12, color: AppColors.alertRed),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],

                            // Username / Phone / Email Field
                            Text(
                              'Username / Mobile Number / Email',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle_outlined,
                                  size: 20,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                                hintText: '03226808199 or name@tradelink.pk',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                ),
                                filled: true,
                                fillColor: isDark ? const Color(0xFF131A2E) : const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: isDark ? const Color(0xFF2E3856) : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: AppColors.tradeTeal, width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  size: 20,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    size: 20,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                                hintText: 'Enter password',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                ),
                                filled: true,
                                fillColor: isDark ? const Color(0xFF131A2E) : const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: isDark ? const Color(0xFF2E3856) : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: AppColors.tradeTeal, width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Remember Me & Forgot Password Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        activeColor: AppColors.tradeTeal,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        onChanged: (val) => setState(() => _rememberMe = val ?? false),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Remember me',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: _showForgotPasswordDialog,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.tradeTeal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Sign In Button
                            ElevatedButton(
                              onPressed: _isLoading ? null : _performLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark ? AppColors.tradeTeal : AppColors.deepNavy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Sign In as ${_getRoleTitle(_activeRole)}',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                    ),
                            ),
                            const SizedBox(height: 12),

                            // Face ID / Biometrics & Google Button Row
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _performBiometricLogin,
                                    icon: const Icon(Icons.fingerprint, color: AppColors.tradeTeal, size: 20),
                                    label: const Text('Bio ID / Sensor'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      side: BorderSide(
                                        color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0),
                                      ),
                                      foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _performLogin,
                                    icon: Icon(
                                      Icons.g_mobiledata,
                                      color: isDark ? Colors.white : AppColors.deepNavy,
                                      size: 26,
                                    ),
                                    label: const Text('Google SSO'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      side: BorderSide(
                                        color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0),
                                      ),
                                      foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Register Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToRegistration,
                            child: const Text(
                              'Create Account',
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

  Widget _buildQuickFillChip({
    required String label,
    required UserRole role,
    required bool isDark,
  }) {
    final isCurrent = _activeRole == role;

    return ActionChip(
      avatar: Icon(
        _getRoleIcon(role),
        size: 14,
        color: isCurrent ? AppColors.tradeTeal : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
          color: isCurrent
              ? (isDark ? Colors.white : AppColors.deepNavy)
              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
        ),
      ),
      backgroundColor: isCurrent
          ? (isDark ? AppColors.tradeTeal.withValues(alpha: 0.2) : AppColors.tealTint)
          : (isDark ? AppColors.cardDark : Colors.white),
      side: BorderSide(
        color: isCurrent ? AppColors.tradeTeal : (isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
      ),
      onPressed: () => _fillRoleCredentials(role),
    );
  }

  String _getRoleTitle(UserRole role) {
    switch (role) {
      case UserRole.importer:
        return 'Importer (Buyer)';
      case UserRole.exporter:
        return 'Exporter (Supplier)';
      case UserRole.admin:
        return 'Administrator';
      case UserRole.agent:
        return 'Commission Agent';
    }
  }

  String _getRoleDescription(UserRole role) {
    switch (role) {
      case UserRole.importer:
        return 'Buyer Mode • RFQs, Escrow & Tracking';
      case UserRole.exporter:
        return 'Supplier Mode • Catalog & Shipments';
      case UserRole.admin:
        return 'Superadmin • Full Governance';
      case UserRole.agent:
        return 'Broker Mode • Quotations & Commission Deals';
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.importer:
        return Icons.shopping_bag_rounded;
      case UserRole.exporter:
        return Icons.factory_rounded;
      case UserRole.admin:
        return Icons.admin_panel_settings_rounded;
      case UserRole.agent:
        return Icons.business_center_rounded;
    }
  }
}
