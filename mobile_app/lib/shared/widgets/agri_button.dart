import 'package:flutter/material.dart';

/// AgriButton - Primary/Secondary button variants following UI rules
/// Height: 48-56px, Rounded corners, Clear hierarchy
class AgriButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const AgriButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: Size(width ?? double.infinity, 52),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    if (type == ButtonType.primary) {
      return SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey.shade400;
              }
              return const Color(0xFF2E7D32);
            }),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: _buildButtonContent(),
        ),
      );
    } else {
      return SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey.shade100;
              }
              return Colors.white;
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey.shade400;
              }
              return const Color(0xFF2E7D32);
            }),
            side: MaterialStateProperty.resolveWith<BorderSide>((states) {
              if (states.contains(MaterialState.disabled)) {
                return BorderSide(color: Colors.grey.shade300);
              }
              return const BorderSide(color: Color(0xFF2E7D32));
            }),
          ),
          child: _buildButtonContent(),
        ),
      );
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

enum ButtonType { primary, secondary }

/// AgriIconButton - Icon-only button for actions
class AgriIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String tooltip;
  final Color? color;
  final double? size;

  const AgriIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.tooltip,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color ?? const Color(0xFF2E7D32), size: size ?? 24),
      tooltip: tooltip,
    );
  }
}

/// AgriFloatingActionButton - Primary action FAB
class AgriFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String tooltip;

  const AgriFloatingActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF2E7D32),
      child: Icon(icon, color: Colors.white),
      tooltip: tooltip,
    );
  }
}
