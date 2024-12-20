import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../feature/home/tabs/matching/model/user_profile.dart';

class AppUtils {
  static Timestamp? timestampFromJson(dynamic json) => json as Timestamp?;
  static dynamic timestampToJson(Timestamp? timestamp) => timestamp;

  static GeoPoint? geoPointFromJson(dynamic json) => json as GeoPoint?;

  static dynamic geoPointToJson(GeoPoint? location) => location;

  static Timestamp? timestampFromMilliseconds(int? milliseconds) {
    if (milliseconds == null) return null;
    return Timestamp.fromMillisecondsSinceEpoch(milliseconds);
  }

  static int? timestampToMilliseconds(Timestamp? timestamp) {
    return timestamp?.millisecondsSinceEpoch;
  }

  static String generateCombinedId(String currentUserUid, String otherUserUid) {
    List<String> userId = [currentUserUid, otherUserUid]..sort();
    return '${userId[0]}_${userId[1]}';
  }

  static String countryCodeToEmoji(String countryCode) {
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  static double? scale(double size) {
    return ScreenUtil().screenWidth > 500 ? size : null;
  }

  static void moveItemToTop<T>(List<T> list, int index) {
    if (index < 0 || index >= list.length) {
      throw RangeError.index(index, list, 'index');
    }

    T item = list.removeAt(index);
    list.insert(0, item);
  }

  static bool areListsEqual<T>(List<T>? list1, List<T>? list2) {
    if (list1 == null || list2 == null) {
      return list1 == list2;
    }

    final sortedList1 = List.of(list1)..sort();
    final sortedList2 = List.of(list2)..sort();
    return listEquals(sortedList1, sortedList2);
  }

  static Size getDimensions(int index) {
    final double screenWidth = ScreenUtil().screenWidth;
    final double height = ScreenUtil().screenHeight * 0.4;

    // Initialize default width and height
    double width = screenWidth;
    double calculatedHeight = height;

    // Determine width and height based on index
    switch (index) {
      case 0:
        width = screenWidth * 0.6;
        calculatedHeight = height * 0.66;
        break;
      case 1:
        width = screenWidth * 0.4;
        calculatedHeight = height * 0.33;
        break;
      case 2:
        width = screenWidth * 0.4;
        calculatedHeight = height * 0.33;
        break;
      case 3:
        width = screenWidth / 3;
        calculatedHeight = height * 0.34;
        break;
      case 4:
        width = screenWidth / 3;
        calculatedHeight = height * 0.34;
        break;
      case 5:
        width = screenWidth / 3;
        calculatedHeight = height * 0.34;
        break;
      default:
        width = 200.r;
        calculatedHeight = 200.r;
        break;
    }

    return Size(width, calculatedHeight);
  }

  static bool shouldExcludeProfile(
    UserProfile profile,
    String currentUserId,
    List<String> blockedIds,
  ) {
    return profile.user.uid == currentUserId ||
        blockedIds.contains(profile.user.uid) ||
        (profile.user.blockedIds?.contains(currentUserId) ?? false);
  }
}

class TimestampWrapper {
  final dynamic timestamp;

  TimestampWrapper(this.timestamp);

  // Method to check and convert to Timestamp
  Timestamp? toTimestamp() {
    if (timestamp is Timestamp) {
      return timestamp as Timestamp; // It's already a Timestamp
    } else if (timestamp is Map<String, int> &&
        timestamp.containsKey('seconds') &&
        timestamp.containsKey('nanoseconds')) {
      final seconds = timestamp['seconds']!;
      final nanoseconds = timestamp['nanoseconds']!;
      return Timestamp(seconds, nanoseconds); // Convert Map to Timestamp
    }
    return null; // Return null if it's neither a Timestamp nor a valid Map
  }

  // Custom fromJson function for timestamp
  static TimestampWrapper? timestampFromJson(dynamic json) =>
      TimestampWrapper(json);

  // Custom toJson function for timestamp
  static dynamic timestampToJson(TimestampWrapper? timestamp) =>
      timestamp?.timestamp;
}
