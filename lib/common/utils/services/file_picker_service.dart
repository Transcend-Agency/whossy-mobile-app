import 'dart:io';

import 'package:image_cropper/image_cropper.dart';

class FilePickerService {
  static Future<File?> cropImage(File image) async {
    // Todo: Images can be rotated on iOS, I wanted them to be fixed
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
    );

    if (croppedImage == null) return null;

    return File(croppedImage.path);
  }
}
