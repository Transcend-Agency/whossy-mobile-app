import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/common/utils/shared_stream_cache.dart';

void main() {
  group('SharedStreamCache', () {
    late SharedStreamCache<int> cache;
    late int created;
    late List<StreamController<int>> sources;

    Stream<int> create() {
      created++;
      final c = StreamController<int>();
      sources.add(c);
      return c.stream;
    }

    setUp(() {
      cache = SharedStreamCache<int>();
      created = 0;
      sources = [];
    });

    test('the same key gives the same stream and one source', () {
      final a = cache.get('k', create);
      final b = cache.get('k', create);
      expect(identical(a, b), isTrue);
      expect(created, 1);
    });

    test('a different key gives a different source', () {
      cache.get('user-a|', create);
      cache.get('user-b|', create);
      expect(created, 2);
    });

    test('a late listener gets the latest value and live updates', () async {
      final stream = cache.get('k', create);
      final first = <int>[];
      final sub1 = stream.listen(first.add);
      sources.single.add(1);
      await pumpEventQueue();

      final second = <int>[];
      final sub2 = stream.listen(second.add);
      sources.single.add(2);
      await pumpEventQueue();

      expect(first, [1, 2]);
      expect(second, [1, 2]);
      await sub1.cancel();
      await sub2.cancel();
    });

    test('after the last listener leaves, the next request opens a fresh source', () async {
      final stream = cache.get('k', create);
      final sub = stream.listen((_) {});
      sources.single.add(1);
      await pumpEventQueue();
      await sub.cancel();
      await pumpEventQueue();

      final values = <int>[];
      final fresh = cache.get('k', create);
      final sub2 = fresh.listen(values.add);
      expect(created, 2);
      sources.last.add(5);
      await pumpEventQueue();

      expect(values, [5]);
      await sub2.cancel();
    });

    test('clear forgets every stream', () {
      cache.get('k', create);
      cache.clear();
      cache.get('k', create);
      expect(created, 2);
    });
  });
}
