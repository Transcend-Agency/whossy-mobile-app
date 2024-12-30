import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/utils/index.dart';

class MessageImageView extends StatelessWidget {
  const MessageImageView({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    double paddingValue = 20.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Darkened background
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          // Centered image with padding
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: paddingValue,
              vertical: paddingValue,
            ),
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
                        imageBuilder: (_, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                        placeholder: (_, __) => const SizedBox.shrink(),
                        errorWidget: (context, url, error) {
                          log('Error loading image: ${error.toString()}');

                          return offline(size: 24);
                        },
                      )
                    : offlineIcon(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
