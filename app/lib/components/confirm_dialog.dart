import 'package:flutter/material.dart';

import 'primary_button.dart';
import 'secondary_button.dart';
import '../theme/app_colors.dart';

/// Diálogo de confirmación modal reutilizable para la galería y las pantallas.
/// Incluye soporte para acciones habituales y destructivas (eliminar, salir sin guardar).
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Key? confirmKey;
  final Key? cancelKey;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
    this.isDestructive = false,
    required this.onConfirm,
    this.onCancel,
    this.confirmKey,
    this.cancelKey,
  });

  /// Método estático para presentar el diálogo modal de confirmación en pantalla.
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    bool isDestructive = false,
    Key? confirmKey,
    Key? cancelKey,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        confirmKey: confirmKey,
        cancelKey: cancelKey,
        onConfirm: () => Navigator.of(dialogContext).pop(true),
        onCancel: () => Navigator.of(dialogContext).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.gray600,
          fontSize: 14,
          height: 1.45,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        SecondaryButton(
          buttonKey: cancelKey ?? const Key('dialog_cancel_button'),
          label: cancelLabel,
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            } else {
              Navigator.of(context).pop(false);
            }
          },
        ),
        PrimaryButton(
          buttonKey: confirmKey ?? const Key('dialog_confirm_button'),
          label: confirmLabel,
          backgroundColor: isDestructive ? AppColors.error : AppColors.black,
          onPressed: onConfirm,
        ),
      ],
    );
  }
}
