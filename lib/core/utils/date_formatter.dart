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
    // Date parse failure — return raw value as-is rather than crashing
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
    // Date parse failure — return raw value as-is rather than crashing
    return rawDate.toString();
  }
}

/// Relative time — "5 min", "2 h", "3 j" (fr) or "3 min", "2 h", "3 d" (en)
String formatRelative(dynamic rawDate, {String locale = 'fr'}) {
  if (rawDate == null) return '';
  try {
    final dt = DateTime.parse(rawDate.toString()).toLocal();
    final diff = DateTime.now().difference(dt);
    final dayLabel = locale.startsWith('fr') ? 'j' : 'd';
    if (diff.inSeconds < 60) return '< 1 min';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} h';
    return '${diff.inDays} $dayLabel';
  } catch (_) {
    // Date parse failure — return raw value as-is rather than crashing
    return rawDate.toString();
  }
}
