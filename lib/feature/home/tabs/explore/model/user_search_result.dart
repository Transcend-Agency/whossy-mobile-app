/// One result of the `searchUsers` Cloud Function
/// (whossy-web-app/functions/src/search.ts). Only what a result tile needs:
/// the full profile is fetched when a result is opened.
class UserSearchResult {
  final String uid;
  final String firstName;
  final int? age;
  final String? photo;

  const UserSearchResult({
    required this.uid,
    required this.firstName,
    this.age,
    this.photo,
  });

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      uid: json['uid'] as String,
      firstName: (json['first_name'] as String?) ?? '',
      age: (json['age'] as num?)?.toInt(),
      photo: json['photo'] as String?,
    );
  }
}

/// Mirrors MIN_PREFIX in functions/src/searchIndex.ts.
const int minSearchLetters = 2;

final RegExp _wordBreak = RegExp(r'[^\p{L}\p{N}]+', unicode: true);
final RegExp _combiningMark = RegExp(r'\p{M}', unicode: true);

/// Whether the server will search this term: some word of it must be at
/// least [minSearchLetters] long. Checked here so a one-letter term shows a
/// hint instead of a call. Accented letters typed precomposed count once,
/// as they do on the server after normalising.
bool isSearchable(String term) {
  return term
      .replaceAll(_combiningMark, '')
      .split(_wordBreak)
      .any((word) => word.runes.length >= minSearchLetters);
}
