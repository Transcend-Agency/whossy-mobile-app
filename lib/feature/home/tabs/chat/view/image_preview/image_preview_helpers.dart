part of 'image_preview.dart';

class PreviewPageIndicator extends StatelessWidget {
  const PreviewPageIndicator({
    super.key,
    required this.images,
    required this.currentPageIndex,
  });

  final List<XFile> images; // Add images list
  final int currentPageIndex; // Add currentPageIndex

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(images.length, (index) {
          return AnimatedContainer(
            key: ValueKey(images[index].path),
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 150),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: currentPageIndex == index ? 48.w : 36.w,
            height: currentPageIndex == index ? 48.h : 36.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: currentPageIndex == index ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(6.r),
              color: Colors.transparent,
              // Set the image with a color filter based on selection
              image: DecorationImage(
                image: FileImage(File(images[index].path)),
                fit: BoxFit.cover,
                // Apply a darkening effect for non-selected indicators
                colorFilter: currentPageIndex == index
                    ? null // Normal appearance for selected
                    : ColorFilter.mode(Colors.black.withOpacity(0.5),
                        BlendMode.dstATop), // Darken for unselected
              ),
            ),
          );
        }),
      ),
    );
  }
}
