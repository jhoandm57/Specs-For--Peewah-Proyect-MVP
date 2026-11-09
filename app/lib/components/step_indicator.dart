import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          Expanded(
            child: _StepItem(
              number: index + 1,
              label: labels[index],
              active: index + 1 == currentStep,
              completed: index + 1 < currentStep,
            ),
          ),
          if (index < labels.length - 1)
            const Padding(
              padding: EdgeInsets.only(top: 15, left: 4, right: 4),
              child: SizedBox(
                width: 18,
                child: Divider(color: AppColors.gray300),
              ),
            ),
        ],
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  final int number;
  final String label;
  final bool active;
  final bool completed;

  const _StepItem({
    required this.number,
    required this.label,
    required this.active,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final highlighted = active || completed;

    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: highlighted ? AppColors.black : AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: highlighted ? AppColors.black : AppColors.gray300,
            ),
          ),
          child: Text(
            '$number',
            style: TextStyle(
              color: highlighted ? AppColors.white : AppColors.gray500,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: active ? AppColors.black : AppColors.gray500,
            fontSize: 10.5,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
