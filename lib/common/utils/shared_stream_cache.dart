import 'package:rxdart/rxdart.dart';

/// Hands back the same live stream for the same key, so a widget that
/// rebuilds and asks again doesn't re-subscribe and re-fetch everything. A
/// new listener gets the latest value straight away.
///
/// When the last listener leaves, the underlying subscription is cancelled
/// and the entry is dropped, so the next request opens a fresh subscription
/// instead of getting back a stream that would only ever replay its last
/// value.
class SharedStreamCache<T> {
  final _streams = <String, Stream<T>>{};

  Stream<T> get(String key, Stream<T> Function() create) {
    final existing = _streams[key];
    if (existing != null) return existing;

    late final Stream<T> shared;
    shared = create()
        .doOnCancel(() {
          if (identical(_streams[key], shared)) _streams.remove(key);
        })
        .publishReplay(maxSize: 1)
        .refCount();
    _streams[key] = shared;
    return shared;
  }

  /// Forgets every stream, e.g. on sign-out.
  void clear() => _streams.clear();
}
