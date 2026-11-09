import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Campo de texto reutilizable para la galería y todas las pantallas de la app.
/// Soporta controladores, valores iniciales, iconos de prefijo y sufijo,
/// visibilidad de contraseña, validación y estados deshabilitados.
class AppTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final String? errorText;
  final Key? fieldKey;

  const AppTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.errorText,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey ?? key,
      initialValue: controller == null ? initialValue : null,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      style: TextStyle(
        color: enabled ? AppColors.black : AppColors.gray500,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
