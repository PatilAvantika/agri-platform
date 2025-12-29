import 'package:flutter/material.dart';

/// AgriCard - Standardized card component following UI rules
/// Border radius: 18px, Padding: 16px, Soft shadow
class AgriCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AgriCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
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
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardWidget,
      );
    }

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 250),
      child: cardWidget,
    );
  }
}

/// CarbonMetricCard - Specialized card for carbon display
class CarbonMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const CarbonMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? const Color(0xFF2E7D32),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
