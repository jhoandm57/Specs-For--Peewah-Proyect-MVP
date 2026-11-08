import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../domain/entities/event.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_card.dart';
import '../widgets/status_badge.dart';

class EventsPage extends StatelessWidget {
  final AuthUser user;
  final List<Event> events;
  final EventCategory? selectedCategory;
  final ValueChanged<EventCategory?> onCategoryChanged;
  final ValueChanged<Event> onEventTap;
  final ValueChanged<Event> onUseAsBase;
  final VoidCallback onNewEvent;
  final VoidCallback onLogout;

  const EventsPage({
    super.key,
    required this.user,
    required this.events,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onEventTap,
    required this.onUseAsBase,
    required this.onNewEvent,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SessionCard(user: user, onLogout: onLogout),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Eventos de la organización',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.4,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Consulta el historial y usa un evento como referencia.',
                            style: TextStyle(
                              color: AppColors.gray600,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    StatusBadge(
                      label: '${events.length} eventos',
                      filled: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _CategoryFilter(
                  selectedCategory: selectedCategory,
                  onChanged: onCategoryChanged,
                ),
                const SizedBox(height: 18),
                if (events.isEmpty)
                  EmptyState(
                    icon: Icons.event_busy_outlined,
                    title: selectedCategory == null
                        ? 'Tu organización todavía no tiene eventos'
                        : 'No hay eventos de este tipo',
                    message: selectedCategory == null
                        ? 'Cuando configures el primer evento, aparecerá en esta lista.'
                        : 'Prueba con otra categoría o vuelve a ver todos los eventos.',
                    action: user.isAdmin && selectedCategory == null
                        ? ElevatedButton.icon(
                            onPressed: onNewEvent,
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Crear evento'),
                          )
                        : null,
                  )
                else
                  _EventsGrid(
                    events: events,
                    canUseAsBase: user.isAdmin,
                    onEventTap: onEventTap,
                    onUseAsBase: onUseAsBase,
                  ),
                const SizedBox(height: 24),
                const _SimulationNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final AuthUser user;
  final VoidCallback onLogout;

  const _SessionCard({required this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.gray100,
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.black,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${user.organizationName} · ${user.email}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.gray600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(
                key: const Key('user_role_badge'),
                label: user.isAdmin ? 'Administrador' : 'Colaborador',
                filled: user.isAdmin,
                icon: user.isAdmin
                    ? Icons.admin_panel_settings_outlined
                    : Icons.groups_2_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              key: const Key('logout_button'),
              onPressed: onLogout,
              icon: const Icon(Icons.logout_rounded, size: 17),
              label: const Text('Cerrar sesión'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final EventCategory? selectedCategory;
  final ValueChanged<EventCategory?> onChanged;

  const _CategoryFilter({
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FILTRAR POR TIPO',
          style: TextStyle(
            color: AppColors.gray500,
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              key: const Key('filter_all'),
              label: const Text('Todos'),
              selected: selectedCategory == null,
              onSelected: (_) => onChanged(null),
            ),
            for (final category in EventCategory.values)
              ChoiceChip(
                key: Key('filter_${category.name}'),
                label: Text(category.label),
                selected: selectedCategory == category,
                onSelected: (_) => onChanged(category),
              ),
          ],
        ),
      ],
    );
  }
}

class _EventsGrid extends StatelessWidget {
  final List<Event> events;
  final bool canUseAsBase;
  final ValueChanged<Event> onEventTap;
  final ValueChanged<Event> onUseAsBase;

  const _EventsGrid({
    required this.events,
    required this.canUseAsBase,
    required this.onEventTap,
    required this.onUseAsBase,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1000
            ? 3
            : constraints.maxWidth >= 680
                ? 2
                : 1;
        const spacing = 14.0;
        final itemWidth =
            (constraints.maxWidth - (columns - 1) * spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final event in events)
              SizedBox(
                width: itemWidth,
                child: EventCard(
                  event: event,
                  canUseAsBase: canUseAsBase,
                  onTap: () => onEventTap(event),
                  onUseAsBase: () => onUseAsBase(event),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SimulationNote extends StatelessWidget {
  const _SimulationNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray200),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 17, color: AppColors.gray600),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Pantallas con datos simulados. La creación y persistencia de eventos se conectan en la siguiente iteración.',
              style: TextStyle(
                color: AppColors.gray600,
                fontSize: 11.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
