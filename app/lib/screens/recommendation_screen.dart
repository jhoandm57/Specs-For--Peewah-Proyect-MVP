import 'package:flutter/material.dart';

import '../models/auth_user.dart';
import '../data/mock_events.dart';
import '../data/mock_recommendations.dart';
import '../models/event.dart';
import '../pages/recommendation_page.dart';
import 'edit_block_screen.dart';
import 'temporality_screen.dart';

/// Screen anfitriona del paso 2 del asistente (F-04).
/// Guarda los bloques sugeridos y la decisión de cada uno; la página solo
/// dibuja y reporta.
class RecommendationScreen extends StatefulWidget {
  final AuthUser user;

  /// Evento armado en el paso 1, todavía sin bloques decididos.
  final Event draft;
  final Event? baseEvent;

  /// Tiempo simulado de búsqueda de eventos similares.
  final Duration searchDelay;

  const RecommendationScreen({
    super.key,
    required this.user,
    required this.draft,
    this.baseEvent,
    this.searchDelay = const Duration(milliseconds: 600),
  });

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  var _loading = true;
  var _usesTypicalConfiguration = false;
  var _showMissingDecisions = false;
  var _blocks = <RecommendationBlock>[];

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    await Future<void>.delayed(widget.searchDelay);
    if (!mounted) return;

    final suggestions = suggestBlocks(
      draft: widget.draft,
      history: mockEvents,
      baseEvent: widget.baseEvent,
    );
    setState(() {
      _blocks = suggestions.blocks;
      _usesTypicalConfiguration = suggestions.usesTypicalConfiguration;
      _loading = false;
    });
  }

  void _updateBlock(
    RecommendationBlockType type,
    RecommendationBlock Function(RecommendationBlock block) change,
  ) {
    setState(() {
      _blocks = [
        for (final block in _blocks) block.type == type ? change(block) : block,
      ];
      _showMissingDecisions = false;
    });
  }

  Future<void> _editBlock(RecommendationBlockType type) async {
    final block = _blocks.firstWhere((block) => block.type == type);
    final items = await EditBlockScreen.open(context, block);
    if (!mounted || items == null) return;
    _updateBlock(type, (block) => block.edit(items));
  }

  void _next() {
    final allDecided = _blocks.every(
      (block) => block.decision != RecommendationDecision.pendiente,
    );
    if (!allDecided) {
      setState(() => _showMissingDecisions = true);
      return;
    }
    _goToNextStep(_eventWithDecisions());
  }

  /// Aplica las decisiones al evento: un bloque rechazado queda vacío también
  /// en la configuración operativa.
  Event _eventWithDecisions() {
    final draft = widget.draft;
    bool rejected(RecommendationBlockType type) => _blocks.any(
      (block) =>
          block.type == type &&
          block.decision == RecommendationDecision.rechazado,
    );

    return draft.copyWith(
      registrationFields: rejected(RecommendationBlockType.formulario)
          ? const []
          : null,
      schedule: rejected(RecommendationBlockType.cronograma) ? const [] : null,
      tasks: rejected(RecommendationBlockType.tareas) ? const [] : null,
      recommendation: draft.recommendation.copyWith(blocks: _blocks),
    );
  }

  /// Conecta con el paso 3 (F-05 · Fechas sugeridas) pasando el evento
  /// con los bloques y decisiones tomadas.
  void _goToNextStep(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TemporalityScreen(
          user: widget.user,
          draft: event,
          baseEvent: widget.baseEvent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nuevo evento'),
            Text(
              'Paso 2 de 3 · Bloques sugeridos',
              style: TextStyle(
                color: Color(0xFF737373),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: RecommendationPage(
        eventName: widget.draft.name,
        categoryLabel: widget.draft.category.label,
        loading: _loading,
        usesTypicalConfiguration: _usesTypicalConfiguration,
        showMissingDecisions: _showMissingDecisions,
        blocks: _blocks,
        onAccept: (type) => _updateBlock(type, (block) => block.accept()),
        onEdit: _editBlock,
        onReject: (type) => _updateBlock(type, (block) => block.reject()),
        onBack: () => Navigator.of(context).pop(),
        onNext: _next,
      ),
    );
  }
}
