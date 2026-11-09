import 'package:flutter/material.dart';

const _months = <String>[
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

const _shortMonths = <String>[
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
];

String formatLongDate(DateTime date) {
  return '${date.day} de ${_months[date.month - 1]} de ${date.year}';
}

String formatShortDate(DateTime date) {
  return '${date.day} ${_shortMonths[date.month - 1]} ${date.year}';
}

DateTime dateFromDaysBefore(DateTime eventDate, int daysBefore) {
  return DateUtils.dateOnly(eventDate).subtract(Duration(days: daysBefore));
}

String formatDaysBefore(int daysBefore) {
  if (daysBefore == 0) {
    return 'El día del evento';
  }
  if (daysBefore == 1) {
    return '1 día antes';
  }
  return '$daysBefore días antes';
}
