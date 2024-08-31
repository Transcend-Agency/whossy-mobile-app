import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';

import '../../../feature/auth/sign_up/data/repository/user_repository.dart';
import '../exceptions/failed_upload.dart';

class FileService {
  final _userRepository = UserRepository();

  static Future<File?> cropImage(File image) async {
    // Todo: Images can be rotated on iOS, I wanted them to be fixed
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
    );

    if (croppedImage == null) return null;

    return File(croppedImage.path);
  }

  Future<List<String>> processPhotos(
    List<dynamic> photos,
    void Function(String) showSnackbar,
  ) async {
    final localFilePaths = <String, int>{};
    final updatedPhotos = List<String>.from(photos);

    // Identify local file paths and keep track of their indexes
    for (int i = 0; i < photos.length; i++) {
      final photo = photos[i];
      if (photo is String && !photo.isUrl) {
        localFilePaths[photo] = i;
      }
    }

    // Convert local file paths to File objects
    final localFiles = localFilePaths.keys.map((path) => File(path)).toList();

    if (localFiles.isNotEmpty) {
      try {
        // Upload local files and get URLs
        final urls = await _userRepository.uploadProfilePictures(localFiles);

        // Replace local file paths in the list with the new URLs
        for (var url in urls) {
          final localPath = localFilePaths.keys.first;
          final index = localFilePaths[localPath]!;
          updatedPhotos[index] = url;
          localFilePaths.remove(localPath);
        }

        // Ensure no local file paths are left unprocessed
        if (localFilePaths.isNotEmpty) {
          showSnackbar('Some photos could not be uploaded.');
        }
      } on Exception catch (e) {
        if (e is FailedUploadException) {
          showSnackbar((e as dynamic).message);
        } else {
          rethrow;
        }
      }
    }

    return updatedPhotos;
  }
}
