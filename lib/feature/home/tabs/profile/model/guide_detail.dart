class GuideDetail {
  final String imageAssetPath;

  final String header;
  final List<GuideDetailItem> items;

  GuideDetail(
    this.imageAssetPath,
    this.header,
    this.items,
  );
}

class GuideDetailItem {
  final String title;
  final String subTitle;

  GuideDetailItem(
    this.title,
    this.subTitle,
  );
}
