import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Botón secundario/contorneado reutilizable para la galería y las pantallas.
/// Soporta variantes con icono, estado deshabilitado, variante destructiva
/// (por ejemplo, para eliminar) y ajuste de ancho completo.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final bool isDestructive;
  final Key? buttonKey;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.isDestructive = false,
    this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isDestructive ? AppColors.error : AppColors.gray400;
    final textColor = isDestructive ? AppColors.error : AppColors.black;
    final iconColor = isDestructive ? AppColors.error : AppColors.black;

    final childWidget = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: onPressed == null ? AppColors.gray400 : iconColor),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            color: onPressed == null ? AppColors.gray400 : textColor,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );

    final buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: textColor,
      side: BorderSide(color: onPressed == null ? AppColors.gray300 : borderColor),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: isFullWidth ? const Size.fromHeight(48) : null,
    );

    return OutlinedButton(
      key: buttonKey ?? key,
      onPressed: onPressed,
      style: buttonStyle,
      child: childWidget,
    );
  }
}
