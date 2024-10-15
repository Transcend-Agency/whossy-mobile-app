import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';

import '../../../../../../../common/components/index.dart';
import '../../../../../../../common/utils/index.dart';
import '../../../../../../../provider/providers.dart';

class ImageGrid extends StatelessWidget {
  final List<String>? localPhotos;
  final List<String>? photos;
  final List<bool> uploadStates;
  final String messageId;

  const ImageGrid({
    super.key,
    this.localPhotos,
    this.photos,
    required this.uploadStates,
    required this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    List<String> images = [];

    if (localPhotos != null && localPhotos!.isNotEmpty) {
      images.addAll(localPhotos!);
    }

    if (photos != null && photos!.isNotEmpty) {
      images.addAll(photos!);
    }

    if (images.isEmpty) return const SizedBox.shrink();

    // Layout images based on the count
    switch (images.length) {
      case 1:
        return _buildImage(images[0], 0);
      case 2:
        return Row(
          children: [
            Expanded(child: _buildImage(images[0], 0)),
            addWidth(5),
            Expanded(child: _buildImage(images[1], 1)),
          ],
        );
      case 3:
        return Row(
          children: [
            Expanded(child: _buildImage(images[0], 0)),
            addWidth(5),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _buildImage(images[1], 1)),
                  addHeight(5),
                  Expanded(child: _buildImage(images[2], 2)),
                ],
              ),
            ),
          ],
        );
      default:
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildImage(images[0], 0)),
                addWidth(5),
                Expanded(child: _buildImage(images[1], 1)),
              ],
            ),
            addHeight(5),
            Row(
              children: [
                Expanded(child: _buildImage(images[2], 2)),
                addWidth(5),
                Expanded(child: _buildImage(images[3], 3)),
              ],
            ),
          ],
        );
    }
  }

  Widget _buildImage(String imageUrl, int index) {
    bool isUploading = false;
    if (index < uploadStates.length) {
      isUploading = uploadStates[index];
    }

    return imageUrl.isUrl
        ? NetworkImage(url: imageUrl)
        : LocalImage(
            isUploading: isUploading,
            hasUploadFailed: false,
            path: imageUrl,
            id: messageId,
          );
  }
}

class NetworkImage extends StatelessWidget {
  const NetworkImage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: editMediaDecoration,
        child: CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (_, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          placeholder: (_, __) => const ShimmerWidget.rectangular(),
          errorWidget: (context, url, error) {
            log('Error loading image: ${error.toString()}');

            return offline(size: 24);
          },
        ),
      ),
    );
  }
}

class LocalImage extends StatelessWidget {
  final bool isUploading;
  final bool hasUploadFailed;
  final String path;
  final String id;

  const LocalImage({
    super.key,
    required this.isUploading,
    required this.hasUploadFailed,
    required this.path,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              showImage(
                path,
                fit: BoxFit.cover,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: Container(color: Colors.transparent),
              ),
            ],
          ),
        ),

        // Show loader if uploading
        if (isUploading)
          const Align(
            alignment: Alignment.center,
            child: AppLoader(),
          ),

        // Show retry button if upload failed
        if (hasUploadFailed)
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.red),
              onPressed: () {
                context.read<ChatsNotifier>().retryUpload(id, path);
              },
            ),
          ),
      ],
    );
  }
}
