class DataRange {
  Map<String, double> data;

  DataRange({required double min, required double max})
      : data = {
          'min': min,
          'max': max,
        };

  double get min => data['min']!;

  double get max => data['max']!;

  double get midpoint => (min + max) / 2;
}
