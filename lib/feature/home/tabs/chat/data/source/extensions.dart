import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

// Extension on List<XFile> to return a string describing the number of pictures
extension PictureCount on List<XFile>? {
  String get picDesc {
    if (this == null || this!.isEmpty) {
      return 'No photos';
    } else if (this!.length == 1) {
      return '1 photo';
    } else if (this!.length > 10) {
      return '10+ photos';
    } else {
      return '${this!.length} photos';
    }
  }
}

extension XFileListExtension on List<XFile>? {
  List<String> get paths {
    return this?.map((picture) => picture.path).toList() ?? [];
  }
}

extension TimestampExtensions on Timestamp? {
  String toTime() {
    if (this == null) {
      return '';
    }

    final dateTime = this!.toDate();
    final hour = dateTime.hour;
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    // Convert hour to 12-hour format
    final formattedHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    // Determine AM/PM
    final period = hour >= 12 ? 'pm' : 'am';

    return '$formattedHour:$minutes $period';
  }
}

String getMessageContent(String content, List<XFile>? pictures) {
  if (content.isEmpty && pictures != null && pictures.isNotEmpty) {
    final photoCount = pictures.length;
    return photoCount == 1 ? "Sent a photo" : "Sent $photoCount photos";
  }
  return content; // Return the original content if it's not empty
}

bool areListsEqual(List<String> list1, List<String> list2) {
  if (list1.length != list2.length) {
    return false;
  }

  list1.sort();
  list2.sort();
  // Compare the sorted lists element by element
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }
  return true;
}
