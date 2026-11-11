import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TradeLinkLogo extends StatelessWidget {
  final double size;
  final bool showLabel;
  final double? fontSize;
  final Color? textColor;

  const TradeLinkLogo({
    super.key,
    this.size = 64,
    this.showLabel = false,
    this.fontSize,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final emblem = CustomPaint(
      size: Size(size, size),
      painter: _TradeLinkEmblemPainter(),
    );

    if (!showLabel) return emblem;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = textColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.deepNavy);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        emblem,
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Trade',
                style: TextStyle(
                  fontSize: fontSize ?? 24,
                  fontWeight: FontWeight.w900,
                  color: primaryTextColor,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'Link',
                style: TextStyle(
                  fontSize: fontSize ?? 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.tradeTeal,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'IMPORT EXPORT AGENT PLATFORM',
          style: TextStyle(
            fontSize: (fontSize ?? 24) * 0.36,
            fontWeight: FontWeight.w800,
            color: AppColors.gold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _TradeLinkEmblemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final r = RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.24));

    // 1. Deep Navy Gradient Background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0B2545), Color(0xFF0F1E36)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRRect(r, bgPaint);

    // 2. Subtle Teal Glowing Border
    final borderPaint = Paint()
      ..color = AppColors.tradeTeal.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, size.width * 0.025);
    canvas.drawRRect(r, borderPaint);

    // 3. Globe Meridian Coordinate Ring
    final globeRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.68,
      height: size.height * 0.68,
    );
    final globePaint = Paint()
      ..color = AppColors.tradeTeal.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, size.width * 0.015);
    canvas.drawOval(globeRect, globePaint);

    // 4. Interlocking Trade Exchange Arcs (Export Teal + Import Gold)
    final arcWidth = math.max(2.5, size.width * 0.075);
    final arcRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.56,
      height: size.height * 0.56,
    );

    // Export Arc (Teal)
    final tealPaint = Paint()
      ..color = AppColors.tradeTeal
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = arcWidth;
    canvas.drawArc(arcRect, 3.66, 2.44, false, tealPaint); // 210 deg, 140 deg sweep

    // Import Arc (Gold)
    final goldPaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = arcWidth;
    canvas.drawArc(arcRect, 0.52, 2.44, false, goldPaint); // 30 deg, 140 deg sweep

    // 5. Stylized 'TL' Cargo Monogram Glyph
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'TL',
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.32,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
          fontFamily: 'sans-serif',
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

