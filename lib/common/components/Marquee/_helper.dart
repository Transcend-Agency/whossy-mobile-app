class ImageHelper {
  static List<String> getImagePathsForRow(int row) {
    return List.generate(
        8, (index) => 'assets/images/sp_${row}_${index + 1}.png');
  }
}
