const minimumAge = 18;
const maximumAge = 100;

/// Why this birth date cannot be used, or null when it can. An unfinished
/// entry also returns a message, so callers decide when it is worth showing.
///
/// The age is worked out from the whole date: comparing years alone let
/// someone who turns 18 later this year through.
String? birthDateError({
  required String year,
  required String month,
  required String day,
  DateTime? now,
}) {
  final y = int.tryParse(year);
  final m = int.tryParse(month);
  final d = int.tryParse(day);

  if (y == null || m == null || d == null) {
    return 'Enter your full date of birth';
  }

  final today = now ?? DateTime.now();

  if (y < today.year - maximumAge || y > today.year) {
    return 'Enter a valid birth year';
  }

  // DateTime rolls 31 February over to March, which would save a different
  // birth date than the one typed.
  final date = DateTime(y, m, d);
  if (date.year != y || date.month != m || date.day != d) {
    return 'That date does not exist';
  }

  var age = today.year - y;
  if (today.month < m || (today.month == m && today.day < d)) age--;

  if (age < minimumAge) return 'You must be $minimumAge or older to use Whossy';

  return null;
}
