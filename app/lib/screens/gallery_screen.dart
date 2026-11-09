import 'package:flutter/material.dart';

import '../components/confirm_dialog.dart';
import '../pages/gallery_page.dart';

/// Screen anfitriona para la Galería de Componentes (/galeria).
/// Maneja las interacciones, diálogos y notificaciones de prueba.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  Future<void> _showStandardDialog(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: '¿Confirmar operación?',
      message: 'Este es un diálogo de confirmación estándar utilizando los botones reutilizables.',
      confirmLabel: 'Aceptar',
      cancelLabel: 'Cancelar',
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Acción confirmada desde el diálogo estándar.')),
      );
    }
  }

  Future<void> _showDestructiveDialog(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: '¿Eliminar elemento?',
      message: 'Esta acción no se puede deshacer. El elemento será eliminado permanentemente de la memoria.',
      confirmLabel: 'Eliminar',
      cancelLabel: 'Cancelar',
      isDestructive: true,
      confirmKey: const Key('gallery_confirm_destructive_button'),
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Acción destructiva confirmada.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería de Componentes'),
      ),
      body: GalleryPage(
        onOpenStandardDialog: () => _showStandardDialog(context),
        onOpenDestructiveDialog: () => _showDestructiveDialog(context),
      ),
    );
  }
}
