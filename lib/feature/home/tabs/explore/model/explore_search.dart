import '../../../../../constants/index.dart';

class ExploreSearch {
  final String label;
  final String? avatar;

  ExploreSearch({required this.label, this.avatar});
}

final List<ExploreSearch> options = [
  ExploreSearch(label: 'Similar Interest'),
  ExploreSearch(label: 'Online'),
  ExploreSearch(label: 'New members'),
  ExploreSearch(label: 'Popular in my area'),
  ExploreSearch(label: 'Looking to date'),
  ExploreSearch(label: 'Outside my country'),
  ExploreSearch(label: 'Flirty'),
  ExploreSearch(label: 'Advanced search', avatar: AppAssets.wwSearch),
];
