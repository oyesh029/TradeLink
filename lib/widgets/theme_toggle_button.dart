import 'package:flutter/material.dart';
import '../state/trade_state.dart';
import '../theme/app_colors.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool transparentBackground;
  final EdgeInsetsGeometry? padding;
  final double size;

  const ThemeToggleButton({
    super.key,
    this.transparentBackground = false,
    this.padding,
    this.size = 40.0,
  });

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

    final tooltipText = isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode';

    return Padding(
      padding: padding ?? const EdgeInsets.all(4.0),
      child: Tooltip(
        message: tooltipText,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(size / 2),
            onTap: () {
              if (tradeState != null) {
                tradeState.toggleDarkMode();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: transparentBackground
                    ? (isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.20))
                    : (isDark
                        ? AppColors.cardDark
                        : Colors.white),
                border: Border.all(
                  color: transparentBackground
                      ? Colors.white.withValues(alpha: 0.25)
                      : (isDark
                          ? const Color(0xFF2E3856)
                          : const Color(0xFFE2E8F0)),
                  width: 1.2,
                ),
                boxShadow: transparentBackground
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: anim,
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
                  key: ValueKey<bool>(isDark),
                  size: size * 0.52,
                  color: isDark ? AppColors.gold : AppColors.deepNavy,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
