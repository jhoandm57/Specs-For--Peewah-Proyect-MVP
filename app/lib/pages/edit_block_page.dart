import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../components/section_card.dart';
import '../components/primary_button.dart';
import '../components/secondary_button.dart';
import '../components/app_text_field.dart';

/// Elemento de un bloque mientras se edita. El id permite agregar y quitar
/// elementos sin que los campos de texto se mezclen.
class EditableItem {
  final int id;
  final String text;

  const EditableItem(this.id, this.text);
}

/// Muestra los elementos del bloque como campos editables y reporta cada
/// cambio a la Screen.
class EditBlockPage extends StatelessWidget {
  final String blockLabel;
  final List<EditableItem> items;
  final void Function(int id, String text) onItemChanged;
  final VoidCallback onAddItem;
  final ValueChanged<int> onRemoveItem;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const EditBlockPage({
    super.key,
    required this.blockLabel,
    required this.items,
    required this.onItemChanged,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionCard(
                  icon: Icons.edit_note_rounded,
                  title: blockLabel,
                  subtitle:
                      'Agrega, cambia o quita elementos. Lo que sugirió '
                      'el sistema se conserva aparte.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'El bloque no tiene elementos.',
                            style: TextStyle(
                              color: AppColors.gray500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      for (var index = 0; index < items.length; index++)
                        Padding(
                          key: ValueKey('edit_item_${items[index].id}'),
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  fieldKey: Key('edit_item_input_$index'),
                                  initialValue: items[index].text,
                                  onChanged: (value) =>
                                      onItemChanged(items[index].id, value),
                                  hintText: 'Elemento ${index + 1}',
                                ),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                key: Key('remove_item_$index'),
                                tooltip: 'Quitar',
                                onPressed: () => onRemoveItem(items[index].id),
                                icon: const Icon(Icons.delete_outline_rounded),
                              ),
                            ],
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          key: const Key('add_item_button'),
                          onPressed: onAddItem,
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Agregar elemento'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SecondaryButton(
                      onPressed: onCancel,
                      label: 'Cancelar',
                    ),
                    PrimaryButton(
                      buttonKey: const Key('save_block_button'),
                      onPressed: onSave,
                      icon: Icons.check_rounded,
                      label: 'Guardar cambios',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
