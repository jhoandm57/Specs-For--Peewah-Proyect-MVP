import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../domain/entities/event.dart';
import 'status_badge.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool canUseAsBase;
  final VoidCallback onTap;
  final VoidCallback onUseAsBase;

  const EventCard({
    super.key,
    required this.event,
    required this.canUseAsBase,
    required this.onTap,
    required this.onUseAsBase,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      key: Key('event_card_${event.id}'),
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.gray200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusBadge(label: event.category.label),
                  const Spacer(),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      formatLongDate(event.date),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.gray500,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                event.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _MetaItem(
                    icon: Icons.location_on_outlined,
                    label: event.modality.label,
                  ),
                  _MetaItem(
                    icon: Icons.people_outline,
                    label: '${event.estimatedAttendees} asistentes',
                  ),
                ],
              ),
              if (event.baseEventName != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.link_rounded,
                      size: 14,
                      color: AppColors.gray500,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Base: ${event.baseEventName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.gray500,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (canUseAsBase) ...[
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    key: Key('use_as_base_card_${event.id}'),
                    onPressed: onUseAsBase,
                    icon: const Icon(Icons.copy_all_outlined, size: 16),
                    label: const Text('Usar como base'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.gray500),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.gray600,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
