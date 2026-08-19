import 'package:cloud_firestore/cloud_firestore.dart';

/// C4 — every discovery-surface error used to render the same
/// "device offline"-labeled dialog, so a genuine outage and a broken query
/// (e.g. `failed-precondition` from a missing composite index, exactly what
/// several C2 filter fixes need deployed) looked identical. This is the one
/// place that decides which is which, so it can't drift per-surface.
class DiscoveryErrorInfo {
  final String title;
  final String subtitle;
  const DiscoveryErrorInfo(this.title, this.subtitle);
}

const _genericError = DiscoveryErrorInfo(
  'Something went wrong',
  "We couldn't load profiles right now. Please try again.",
);

DiscoveryErrorInfo discoveryErrorInfo(Object? error) {
  if (error is FirebaseException &&
      (error.code == 'unavailable' || error.code == 'deadline-exceeded')) {
    return const DiscoveryErrorInfo(
      'Network error',
      'We encountered an error while trying to load your data',
    );
  }
  return _genericError;
}
