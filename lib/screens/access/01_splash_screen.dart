import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/tradelink_brand_logo.dart';
import '02_account_type_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _progressAnimation;

  String _loadingStepCode = '01 / 03';
  String _loadingStepText = 'INITIALIZING SECURE PROTOCOL & LOCAL DATABASE VAULT';

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.84, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.65, curve: Curves.easeIn)),
    );

    _glowAnimation = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOutCubic),
    );

    _mainController.forward();

    // Staged enterprise protocol status sequence
    Future.delayed(const Duration(milliseconds: 650), () {
      if (mounted) {
        setState(() {
          _loadingStepCode = '02 / 03';
          _loadingStepText = 'SYNCHRONIZING GLOBAL PORT RADAR & LIVE TARIFF FEEDS';
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) {
        setState(() {
          _loadingStepCode = '03 / 03';
          _loadingStepText = 'TRADELINK ENTERPRISE SECURITY CLEARANCE ACTIVE';
        });
      }
    });

    // Auto navigate after 1.9s to Account Type Selection Screen
    Future.delayed(const Duration(milliseconds: 1900), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AccountTypeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TradeState? tradeState;
    try {
      tradeState = TradeStateInherited.of(context);
    } catch (_) {
      tradeState = null;
    }

    final isDark = tradeState != null
        ? tradeState.isDarkMode
        : Theme.of(context).brightness == Brightness.dark;

    final size = MediaQuery.of(context).size;

    // Elite palette definitions for both Dark and Light modes
    final bgGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF060D1E), Color(0xFF0A1733), Color(0xFF081226)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final titleTextColor = isDark ? Colors.white : AppColors.deepNavy;
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF0F1E36) : Colors.white;
    final cardBorderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: bgGradient),
        child: Stack(
          children: [
            // 1. Subtle Calisthenic Maritime Precision Coordinates Background Grid
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (ctx, child) {
                  return CustomPaint(
                    painter: _CalisthenicRadarPainter(
                      rotationAngle: _rotationController.value * 2 * math.pi,
                      isDark: isDark,
                    ),
                  );
                },
              ),
            ),

            // 2. Ambient Luxury Radial Halos
            Positioned(
              top: -100,
              right: -100,
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (ctx, child) => Container(
                  width: 420,
                  height: 420,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.tradeTeal.withValues(alpha: (isDark ? 0.22 : 0.12) * _glowAnimation.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              left: -100,
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (ctx, child) => Container(
                  width: 380,
                  height: 380,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.gold.withValues(alpha: (isDark ? 0.16 : 0.08) * _glowAnimation.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 3. Central Brand Composition
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated Hero Emblem with Pulsing Elevation
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (ctx, child) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.tradeTeal.withValues(
                                    alpha: (isDark ? 0.35 : 0.18) * _glowAnimation.value,
                                  ),
                                  blurRadius: 44,
                                  spreadRadius: 10,
                                ),
                                BoxShadow(
                                  color: AppColors.gold.withValues(
                                    alpha: (isDark ? 0.18 : 0.10) * _glowAnimation.value,
                                  ),
                                  blurRadius: 65,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: const TradeLinkLogo(size: 114),
                          ),
                        ),
                        const SizedBox(height: 26),

                        // Fortune 500 Corporate Eyebrow
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4.5),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.gold.withValues(alpha: 0.12)
                                : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.gold.withValues(alpha: 0.45)
                                  : const Color(0xFFD97706).withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.workspace_premium,
                                size: 13,
                                color: isDark ? AppColors.gold : const Color(0xFFB45309),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'GLOBAL COMMODITY & BROKERAGE PLATFORM',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.gold : const Color(0xFF92400E),
                                  letterSpacing: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // TradeLink Brand Name
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Trade',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: titleTextColor,
                                  letterSpacing: -0.9,
                                ),
                              ),
                              const TextSpan(
                                text: 'Link',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.tradeTeal,
                                  letterSpacing: -0.9,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Official Tagline
                        Text(
                          'Import Export Commission Agent Platform',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: subtitleColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Institutional Compliance Credentials Badges
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTrustPill(
                                icon: Icons.layers_rounded,
                                label: '31 Enterprise Modules',
                                color: AppColors.oceanBlue,
                                bgColor: cardBgColor,
                                borderColor: cardBorderColor,
                                isDark: isDark,
                              ),
                              const SizedBox(width: 8),
                              _buildTrustPill(
                                icon: Icons.security_rounded,
                                label: 'ISO 37301 & AML Compliant',
                                color: AppColors.successGreen,
                                bgColor: cardBgColor,
                                borderColor: cardBorderColor,
                                isDark: isDark,
                              ),
                              const SizedBox(width: 8),
                              _buildTrustPill(
                                icon: Icons.account_balance_rounded,
                                label: 'ICC UCP 600 Verified',
                                color: AppColors.gold,
                                bgColor: cardBgColor,
                                borderColor: cardBorderColor,
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 38),

                        // Sleek Precision Dynamic Loader
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 290),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _loadingStepCode,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? AppColors.tradeTeal : AppColors.deepNavy,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  AnimatedBuilder(
                                    animation: _progressAnimation,
                                    builder: (ctx, child) {
                                      final pct = (_progressAnimation.value * 100).toInt();
                                      return Text(
                                        '$pct%',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (ctx, child) {
                                    return LinearProgressIndicator(
                                      value: _progressAnimation.value,
                                      minHeight: 4.5,
                                      backgroundColor: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFCBD5E1),
                                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.tradeTeal),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  _loadingStepText,
                                  key: ValueKey<String>(_loadingStepText),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 4. Top Right Corner Live Theme Toggle Button
            const Positioned(
              top: 14,
              right: 18,
              child: SafeArea(
                child: ThemeToggleButton(transparentBackground: false),
              ),
            ),

            // 5. Bottom Institutional Footer
            Positioned(
              bottom: 18,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 12,
                          color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '256-Bit Encrypted Interbank Escrow & Local SQLite Storage',
                          style: TextStyle(
                            fontSize: size.width < 360 ? 9 : 10,
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF475569),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'TradeLink Enterprise Edition • v2.4.0 • 31 Modules Bound',
                      style: TextStyle(
                        fontSize: size.width < 360 ? 9 : 10,
                        color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustPill({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required Color borderColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white.withValues(alpha: 0.95) : AppColors.deepNavy,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalisthenicRadarPainter extends CustomPainter {
  final double rotationAngle;
  final bool isDark;

  _CalisthenicRadarPainter({
    required this.rotationAngle,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.42);
    final maxRadius = math.min(size.width, size.height) * 0.58;

    final baseColor = isDark ? const Color(0xFF13A89E) : const Color(0xFF0B2545);
    final ringOpacity = isDark ? 0.05 : 0.035;

    final ringPaint = Paint()
      ..color = baseColor.withValues(alpha: ringOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw concentric precision coordinate rings
    for (int i = 1; i <= 4; i++) {
      final r = maxRadius * (i / 4.0);
      canvas.drawCircle(center, r, ringPaint);
    }

    // Draw precision crosshair axes
    final axisPaint = Paint()
      ..color = baseColor.withValues(alpha: ringOpacity * 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.drawLine(Offset(center.dx - maxRadius, center.dy), Offset(center.dx + maxRadius, center.dy), axisPaint);
    canvas.drawLine(Offset(center.dx, center.dy - maxRadius), Offset(center.dx, center.dy + maxRadius), axisPaint);

    // Rotating nautical sweep ray
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: FractionalOffset(center.dx / size.width, center.dy / size.height),
        startAngle: 0.0,
        endAngle: math.pi / 2,
        colors: [
          baseColor.withValues(alpha: isDark ? 0.08 : 0.04),
          Colors.transparent,
        ],
        transform: GradientRotation(rotationAngle),
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

    canvas.drawCircle(center, maxRadius, sweepPaint);
  }

  @override
  bool shouldRepaint(covariant _CalisthenicRadarPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle || oldDelegate.isDark != isDark;
  }
}
