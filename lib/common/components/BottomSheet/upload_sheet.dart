import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/index.dart';
import '../../styles/component_style.dart';
import '../index.dart';

class UploadSheet extends StatefulWidget {
  final String header;
  final String subHeader;

  const UploadSheet({
    super.key,
    required this.header,
    required this.subHeader,
  });

  @override
  State<UploadSheet> createState() => _UploadSheetState();
}

class _UploadSheetState extends State<UploadSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  onLoaded(LottieComposition composition) {
    _controller
      ..duration = composition.duration
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: pagePadding.copyWith(top: 12.h),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            SignupHeaderText(
              center: true,
              top: 6,
              title: widget.header,
              subtitle: widget.subHeader,
            ),
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: Lottie.asset(
                AppAssets.loading,
                controller: _controller,
                decoder: customDecoder,
                onLoaded: onLoaded,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<LottieComposition?> customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(bytes, filePicker: (files) {
    return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'));
  });
}

const minSize = 0.4;
const maxSize = 0.5;

// Todo: Make responsive for bigger screens
Future<void> showLoadingSheet(
  BuildContext ctx,
  AnimationController ctr, {
  required String header,
  required String subHeader,
}) async {
  await showModalBottomSheet<void>(
    transitionAnimationController: ctr,
    showDragHandle: false,
    enableDrag: false,
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    isDismissible: false,
    context: ctx,
    shape: roundedTop,
    builder: (_) => PopScope(
      canPop: false,
      child: DraggableScrollableSheet(
        shouldCloseOnMinExtent: false,
        expand: false,
        initialChildSize: minSize,
        minChildSize: minSize,
        maxChildSize: maxSize,
        builder: (_, __) => UploadSheet(
          header: header,
          subHeader: subHeader,
        ),
      ),
    ),
  );
}
