import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../components/primary_button.dart';
import '../components/secondary_button.dart';
import '../components/app_text_field.dart';
import '../components/status_badge.dart';
import '../components/step_indicator.dart';
import '../components/section_card.dart';
import '../components/empty_state.dart';
import '../components/event_card.dart';

/// Página de presentación pura para la Galería de Componentes (/galeria).
/// Muestra cada uno de los componentes reutilizables con sus variantes.
class GalleryPage extends StatelessWidget {
  final VoidCallback onOpenStandardDialog;
  final VoidCallback onOpenDestructiveDialog;

  const GalleryPage({
    super.key,
    required this.onOpenStandardDialog,
    required this.onOpenDestructiveDialog,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Galería de Componentes',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Catálogo interactivo de componentes reutilizables construidos para la aplicación Peewah.',
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // 1. Botones Primarios
                SectionCard(
                  icon: Icons.smart_button_rounded,
                  title: 'PrimaryButton',
                  subtitle: 'Botón de acción principal con variantes de icono, carga y ancho completo.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          PrimaryButton(
                            label: 'Predeterminado',
                            onPressed: () {},
                          ),
                          PrimaryButton(
                            label: 'Con icono',
                            icon: Icons.add_rounded,
                            onPressed: () {},
                          ),
                          const PrimaryButton(
                            label: 'Deshabilitado',
                            onPressed: null,
                          ),
                          const _GalleryLoadingButtonDemo(),
                        ],
                      ),
                      const SizedBox(height: 14),
                      PrimaryButton(
                        label: 'Ancho completo',
                        icon: Icons.check_circle_outline_rounded,
                        isFullWidth: true,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Botones Secundarios
                SectionCard(
                  icon: Icons.crop_portrait_rounded,
                  title: 'SecondaryButton',
                  subtitle: 'Botón secundario o contorneado, con variante destructiva para eliminar.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SecondaryButton(
                            label: 'Secundario',
                            onPressed: () {},
                          ),
                          SecondaryButton(
                            label: 'Con icono',
                            icon: Icons.arrow_back_rounded,
                            onPressed: () {},
                          ),
                          const SecondaryButton(
                            label: 'Deshabilitado',
                            onPressed: null,
                          ),
                          SecondaryButton(
                            label: 'Destructivo (Eliminar)',
                            icon: Icons.delete_outline_rounded,
                            isDestructive: true,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SecondaryButton(
                        label: 'Secundario de ancho completo',
                        isFullWidth: true,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Campos de Texto
                SectionCard(
                  icon: Icons.edit_note_rounded,
                  title: 'AppTextField',
                  subtitle: 'Campos de entrada estándar con estados, iconos y validación.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AppTextField(
                        labelText: 'Campo de texto estándar',
                        hintText: 'Escribe algo aquí...',
                      ),
                      const SizedBox(height: 14),
                      const AppTextField(
                        labelText: 'Con icono prefijo',
                        hintText: 'Ej. Nombre de evento',
                        prefixIcon: Icons.title_outlined,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        labelText: 'Contraseña (oculto)',
                        initialValue: '12345678',
                        obscureText: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        suffixIcon: const Icon(Icons.visibility_off_outlined),
                      ),
                      const SizedBox(height: 14),
                      const AppTextField(
                        labelText: 'Con error de validación',
                        initialValue: 'Dato inválido',
                        errorText: 'Este campo es obligatorio',
                        prefixIcon: Icons.error_outline_rounded,
                      ),
                      const SizedBox(height: 14),
                      const AppTextField(
                        labelText: 'Campo deshabilitado',
                        initialValue: 'Texto no editable',
                        enabled: false,
                        prefixIcon: Icons.block_flipped,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 4. Diálogos de Confirmación
                SectionCard(
                  icon: Icons.help_outline_rounded,
                  title: 'ConfirmDialog',
                  subtitle: 'Ventanas modales para confirmar acciones o advertir antes de eliminar.',
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      PrimaryButton(
                        buttonKey: const Key('gallery_open_standard_dialog'),
                        label: 'Abrir diálogo estándar',
                        icon: Icons.info_outline_rounded,
                        onPressed: onOpenStandardDialog,
                      ),
                      SecondaryButton(
                        buttonKey: const Key('gallery_open_destructive_dialog'),
                        label: 'Abrir diálogo destructivo',
                        icon: Icons.delete_outline_rounded,
                        isDestructive: true,
                        onPressed: onOpenDestructiveDialog,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 5. Badges de Estado e Indicadores
                SectionCard(
                  icon: Icons.label_outline_rounded,
                  title: 'StatusBadge & StepIndicator',
                  subtitle: 'Etiquetas de estado y barra de pasos del asistente en 3 fases.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          StatusBadge(label: 'Congreso'),
                          StatusBadge(label: 'Configurado', filled: true),
                          StatusBadge(label: 'Aceptado', icon: Icons.check_circle_outline),
                          StatusBadge(label: 'Editado', filled: true, icon: Icons.edit_outlined),
                          StatusBadge(label: 'Rechazado', icon: Icons.close_rounded),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const StepIndicator(
                        currentStep: 2,
                        labels: [
                          'Características',
                          'Bloques sugeridos',
                          'Fechas sugeridas',
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 6. Tarjetas y EmptyState
                SectionCard(
                  icon: Icons.dashboard_outlined,
                  title: 'EventCard & EmptyState',
                  subtitle: 'Tarjetas de eventos en lista y estado vacío.',
                  child: Column(
                    children: [
                      EventCard(
                        name: 'Congreso Internacional de Tecnología 2026',
                        category: 'Congreso',
                        modality: 'Híbrida',
                        dateLabel: '15 oct 2026',
                        registrations: 412,
                        estimatedAttendance: 450,
                        status: 'Configurado',
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      EmptyState(
                        icon: Icons.event_busy_outlined,
                        title: 'Sin elementos registrados',
                        message: 'Este es el componente reutilizable de estado vacío.',
                        action: PrimaryButton(
                          label: 'Acción sugerida',
                          onPressed: () {},
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
    );
  }
}

class _GalleryLoadingButtonDemo extends StatefulWidget {
  const _GalleryLoadingButtonDemo();

  @override
  State<_GalleryLoadingButtonDemo> createState() => _GalleryLoadingButtonDemoState();
}

class _GalleryLoadingButtonDemoState extends State<_GalleryLoadingButtonDemo> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: _loading ? 'Cargando...' : 'Probar carga',
      isLoading: _loading,
      onPressed: () {
        setState(() => _loading = true);
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _loading = false);
        });
      },
    );
  }
}

