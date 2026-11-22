import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/common/utils/enum/enums.dart';
import 'package:whossy_app/feature/home/tabs/matching/data/repository/query_helper.dart';

// QueryHelper.matches is the client-side twin of the swipe deck's query
// filters, used on the "nearby" group. It has to agree with the query.
void main() {
  final now = DateTime(2026, 6, 15);

  Map<String, dynamic> person({
    String gender = 'Female',
    DateTime? dob,
    String? bio = 'Hi',
    List<String> interests = const ['Music'],
    int? preference,
  }) =>
      {
        'gender': gender,
        'date_of_birth': Timestamp.fromDate(dob ?? DateTime(1996, 1, 1)),
        'bio': bio,
        'interests': interests,
        if (preference != null) 'preference': preference,
      };

  test('no filters lets everyone through', () {
    expect(QueryHelper.matches(person(), const {}, now: now), isTrue);
  });

  test('meet filters on gender, 2 means anyone', () {
    expect(QueryHelper.matches(person(gender: 'Male'), {'meet': 0}, now: now),
        isTrue);
    expect(QueryHelper.matches(person(gender: 'Female'), {'meet': 0}, now: now),
        isFalse);
    expect(QueryHelper.matches(person(gender: 'Male'), {'meet': 2}, now: now),
        isTrue);
  });

  test('age range uses the same date cut-offs as the query', () {
    final filters = {'age_min': 25, 'age_max': 30};
    // Turns 25 exactly today: in.
    expect(
        QueryHelper.matches(person(dob: DateTime(2001, 6, 15)), filters,
            now: now),
        isTrue);
    // Turns 25 tomorrow: still 24, out.
    expect(
        QueryHelper.matches(person(dob: DateTime(2001, 6, 16)), filters,
            now: now),
        isFalse);
    // Older than 30: out.
    expect(
        QueryHelper.matches(person(dob: DateTime(1990, 1, 1)), filters,
            now: now),
        isFalse);
  });

  test('a missing date of birth fails an age filter, as in the query', () {
    final data = person()..remove('date_of_birth');
    expect(QueryHelper.matches(data, {'age_min': 18}, now: now), isFalse);
  });

  test('hasBio needs a non-empty bio, false means no filter', () {
    expect(QueryHelper.matches(person(bio: ''), {'hasBio': true}, now: now),
        isFalse);
    expect(QueryHelper.matches(person(bio: null), {'hasBio': true}, now: now),
        isFalse);
    expect(QueryHelper.matches(person(bio: ''), {'hasBio': false}, now: now),
        isTrue);
  });

  test('similar interests needs at least one shared interest', () {
    expect(
        QueryHelper.matches(
            person(interests: ['Music', 'Art']),
            {
              'similar_interests': ['Art', 'Travel']
            },
            now: now),
        isTrue);
    expect(
        QueryHelper.matches(
            person(interests: ['Music']),
            {
              'similar_interests': ['Travel']
            },
            now: now),
        isFalse);
  });

  test('enum preferences compare by index', () {
    final wanted = Preference.values[1];
    expect(
        QueryHelper.matches(
            person(preference: wanted.index), {'preference': wanted},
            now: now),
        isTrue);
    expect(
        QueryHelper.matches(person(preference: Preference.values[0].index),
            {'preference': wanted},
            now: now),
        isFalse);
    expect(QueryHelper.matches(person(), {'preference': wanted}, now: now),
        isFalse);
  });
}
