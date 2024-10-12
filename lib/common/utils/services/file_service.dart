import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as p;
import 'package:whossy_app/constants/index.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/repository/chat_repository.dart';

import '../../../feature/auth/sign_up/data/repository/user_repository.dart';
import '../enum/enums.dart';
import '../exceptions/failed_upload.dart';
import 'services.dart';

typedef AddPicFn = Future<bool> Function({Picture? pic});
typedef AddIndexFn = Future<bool> Function({int? index});

class FileService {
  final _userRepository = UserRepository();
  final _storage = FirebaseStorage.instance;
  final _chatRepository = ChatRepository();

  // Tracks the progress of uploads using keys
  final Map<String, UploadTask> _uploadTasks = {};

  /// Uploads an image file to Firebase Storage
  Future<String> uploadImage(
      String chatId, File file, Function(double) onProgress) async {
    final fName = p.basenameWithoutExtension(file.path);
    final storageRef =
        _storage.ref().child(AppStrings.chatPicsPath(fName, chatId));
    final uploadTask = storageRef.putFile(file);

    // Track the upload progress
    _uploadTasks[file.path] = uploadTask;
    uploadTask.snapshotEvents.listen((taskSnapshot) {
      final progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
      onProgress(progress); // Report upload progress
    });

    try {
      final taskSnapshot = await uploadTask;
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      _uploadTasks.remove(file.path); // Remove completed task
      return downloadUrl; // Return the file's download URL
    } catch (e) {
      _uploadTasks.remove(file.path); // Cleanup on failure
      throw FailedUploadException('Failed to upload image');
    }
  }

  /// Handles the upload of images in the background
  Future<void> uploadImagesInBackground({
    required String chatId,
    required String messageId,
    required List<String> localPaths,
    required Function(String, double) onProgress,
  }) async
  // lb
  {
    // Map to store localPath and its corresponding download URL
    Map<String, String> uploadResults = {};

    for (var localPath in localPaths) {
      // Skip if the image is already being uploaded
      if (_uploadTasks.containsKey(localPath)) continue;

      final file = File(localPath);
      try {
        final downloadUrl = await uploadImage(chatId, file, (progress) {
          onProgress(localPath, progress);
        });

        // Store the local path and download URL
        uploadResults[localPath] = downloadUrl;
      } catch (e) {
        log('An error occurred ${e.toString()}');
      }
    }

    // After all uploads, batch the Firestore update
    if (uploadResults.isNotEmpty) {
      await _chatRepository.updatePhotosData(
        chatId: chatId,
        docId: messageId,
        uploadResults: uploadResults,
      );
    }
  }

  /// Cancel an upload in progress
  void cancelUpload(String localPath) {
    final uploadTask = _uploadTasks[localPath];
    if (uploadTask != null) {
      uploadTask.cancel();
      _uploadTasks.remove(localPath);
    }
  }

  /// Check if a file is already being uploaded
  bool isUploading(String localPath) => _uploadTasks.containsKey(localPath);

  static Future<bool> handlePermissions({
    required BuildContext context,
    required Function(BuildContext context) showDialog,
    required Function(String message) showSnackbar,
    required dynamic onAddPhoto,
    Picture? pic,
    int? index,
  })
  // lb
  async {
    try {
      return await _executeAddPhoto(onAddPhoto, pic: pic, index: index);
    } catch (e) {
      if (Platform.isIOS) {
        bool hasPermission = await PermissionService.requestPhotoPermission();
        if (hasPermission) {
          return await _executeAddPhoto(onAddPhoto, pic: pic, index: index);
        } else {
          if (context.mounted) {
            await PermissionService.handlePermanentlyDeniedPermission(
              context: context,
              showDialog: showDialog,
            );
          }
        }
      } else {
        showSnackbar('Access denied, update access in settings');
      }
      return false;
    }
  }

  static Future<bool> _executeAddPhoto(
    dynamic onAddPhoto, {
    Picture? pic,
    int? index,
  }) async
  // lb
  {
    if (onAddPhoto is AddPicFn) {
      return await onAddPhoto(pic: pic);
    } else if (onAddPhoto is AddIndexFn) {
      return await onAddPhoto(index: index);
    }
    return false; // Default case
  }

  static Future<File?> cropImage(File image) async
  // lb
  {
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
  ) async
  // lb
  {
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
