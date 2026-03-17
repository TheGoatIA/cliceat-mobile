import 'package:intl/intl.dart';

/// Formats an ISO 8601 date string (from the API) into a locale-aware,
/// human-readable string using the device's local timezone.
///
/// Examples:
///   formatDate('2026-03-17T14:32:00.000Z')
///     → "17 mars 2026 15:32" (fr) or "Mar 17, 2026 3:32 PM" (en)
///
///   formatDate(null) → ''
String formatDate(dynamic rawDate, {String locale = 'fr'}) {
  if (rawDate == null) return '';
  try {
    final dt = DateTime.parse(rawDate.toString()).toLocal();
    final fmt = DateFormat.yMMMd(locale).add_Hm();
    return fmt.format(dt);
  } catch (_) {
    return rawDate.toString();
  }
}

/// Short date only (no time). e.g. "17/03/2026" (fr) or "3/17/2026" (en)
String formatDateShort(dynamic rawDate, {String locale = 'fr'}) {
  if (rawDate == null) return '';
  try {
    final dt = DateTime.parse(rawDate.toString()).toLocal();
    return DateFormat.yMd(locale).format(dt);
  } catch (_) {
    return rawDate.toString();
  }
}

/// Relative time — "il y a 5 min", "il y a 2 h", etc. (locale-aware via intl)
String formatRelative(dynamic rawDate) {
  if (rawDate == null) return '';
  try {
    final dt = DateTime.parse(rawDate.toString()).toLocal();
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '< 1 min';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} h';
    return '${diff.inDays} j';
  } catch (_) {
    return rawDate.toString();
  }
}
