import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Botón principal reutilizable para la galería y todas las pantallas.
/// Soporta variantes con icono, estado deshabilitado, indicador de carga
/// y ajuste de ancho completo.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Key? buttonKey;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.black;
    final effectiveForegroundColor = foregroundColor ?? AppColors.white;

    final childWidget = isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: effectiveForegroundColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: effectiveForegroundColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          );

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      disabledBackgroundColor: AppColors.gray300,
      disabledForegroundColor: AppColors.gray600,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: isFullWidth ? const Size.fromHeight(48) : null,
    );

    return ElevatedButton(
      key: buttonKey ?? key,
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: childWidget,
    );
  }
}
