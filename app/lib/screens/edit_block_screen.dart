import 'package:flutter/material.dart';

import '../models/event.dart';
import '../pages/edit_block_page.dart';

/// Screen anfitriona de la edición de un bloque sugerido (F-04, A2).
/// Guarda el borrador de la edición y, al guardar, lo devuelve a quien la abrió.
class EditBlockScreen extends StatefulWidget {
  final RecommendationBlock block;

  const EditBlockScreen({super.key, required this.block});

  /// Abre la edición y devuelve el contenido nuevo, o null si se cancela.
  static Future<List<String>?> open(
    BuildContext context,
    RecommendationBlock block,
  ) {
    return Navigator.of(context).push<List<String>>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => EditBlockScreen(block: block),
      ),
    );
  }

  @override
  State<EditBlockScreen> createState() => _EditBlockScreenState();
}

class _EditBlockScreenState extends State<EditBlockScreen> {
  late final List<EditableItem> _items;
  var _nextId = 0;

  @override
  void initState() {
    super.initState();
    final start = widget.block.decision == RecommendationDecision.editado
        ? widget.block.finalItems
        : widget.block.suggestedItems;
    _items = [for (final text in start) EditableItem(_nextId++, text)];
  }

  void _changeItem(int id, String text) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == id);
      _items[index] = EditableItem(id, text);
    });
  }

  void _addItem() {
    setState(() => _items.add(EditableItem(_nextId++, '')));
  }

  void _removeItem(int id) {
    setState(() => _items.removeWhere((item) => item.id == id));
  }

  void _save() {
    final result = [
      for (final item in _items)
        if (item.text.trim().isNotEmpty) item.text.trim(),
    ];
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${widget.block.type.label.toLowerCase()}'),
      ),
      body: EditBlockPage(
        blockLabel: widget.block.type.label,
        items: _items,
        onItemChanged: _changeItem,
        onAddItem: _addItem,
        onRemoveItem: _removeItem,
        onCancel: () => Navigator.of(context).pop(),
        onSave: _save,
      ),
    );
  }
}
