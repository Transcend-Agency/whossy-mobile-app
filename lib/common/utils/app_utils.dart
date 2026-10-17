import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../constants/index.dart';
import '../../feature/auth/sign_up/model/geography.dart';
import '../../feature/home/settings/model/user_settings.dart';
import '../../feature/home/tabs/matching/model/user_profile.dart';
import '../../feature/home/tabs/profile/model/credit.dart';
import '../../provider/provider.dart';
import '../components/components.dart';
import 'utils.dart';

class AppUtils {
  static Map<String, dynamic>? geographyToJson(Geography? geography) =>
      geography?.toJson();

  static Geography? geographyFromJson(Map<String, dynamic>? json) =>
      json != null ? Geography.fromJson(json) : null;

  static UserSettings userSettingsFromJson(Map<String, dynamic>? json) =>
      json == null ? UserSettings() : UserSettings.fromJson(json);

  static Map<String, dynamic>? userSettingsToJson(UserSettings? settings) =>
      settings?.toJson();


  static Timestamp? timestampFromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) return json;
    if (json is DateTime) return Timestamp.fromDate(json);
    if (json is int) return Timestamp.fromMillisecondsSinceEpoch(json);
    if (json is String) {
      final parsed = DateTime.tryParse(json);
      return parsed != null ? Timestamp.fromDate(parsed) : null;
    }
    if (json is Map) {
      final seconds = json['seconds'] ?? json['_seconds'];
      final nanoseconds = json['nanoseconds'] ?? json['_nanoseconds'] ?? 0;
      if (seconds is int && nanoseconds is int) {
        return Timestamp(seconds, nanoseconds);
      }
    }
    return null;
  }

  static dynamic timestampToJson(Timestamp? timestamp) => timestamp;

  static Currency? currencyFromJson(String? code) => Currency.fromCode(code);
  static String? currencyToJson(Currency? currency) => currency?.toJson();

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

  static bool excludeProfile(
    UserProfile profile,
    String currentUserId,
    List<String> blockedIds, {
    ExcludeSettings? settings,
  }) {
    settings ??= const ExcludeSettings();

    // Apply exclusion settings
    if (settings.excludeIncompleteOnboarding &&
        !profile.user.hasCompletedOnboarding) {
      return true;
    }
    if (settings.excludeBannedUsers && profile.user.isBanned) {
      return true;
    }
    if (settings.excludeUnapprovedUsers && !profile.user.isApproved) {
      return true;
    }

    if (settings.excludePublicSearch &&
        !(profile.user.userSettings.publicSearch ?? true)) {
      return true;
    }

    if (settings.excludeBlockedAndSelf &&
        (profile.user.uid == currentUserId ||
            blockedIds.contains(profile.user.uid) ||
            (profile.user.blockedIds?.contains(currentUserId) ?? false))) {
      return true;
    }

    return false;
  }
}

class ExcludeSettings {
  final bool excludeIncompleteOnboarding;
  final bool excludeBannedUsers;
  final bool excludeUnapprovedUsers;
  final bool excludeBlockedAndSelf;
  final bool excludePublicSearch;

  const ExcludeSettings({
    this.excludeIncompleteOnboarding = false,
    this.excludeBannedUsers = false,
    this.excludeUnapprovedUsers = false,
    this.excludeBlockedAndSelf = false,
    this.excludePublicSearch = false,
  });
}

class TimestampWrapper {
  final dynamic timestamp;

  TimestampWrapper(this.timestamp);

  Timestamp? toTimestamp() {
    if (timestamp is Timestamp) {
      return timestamp as Timestamp;
    } else if (timestamp is Map<String, int> &&
        timestamp.containsKey('seconds') &&
        timestamp.containsKey('nanoseconds')) {
      final seconds = timestamp['seconds']!;
      final nanoseconds = timestamp['nanoseconds']!;
      return Timestamp(seconds, nanoseconds);
    }
    return null;
  }

  static TimestampWrapper? timestampFromJson(dynamic json) =>
      TimestampWrapper(json);

  static dynamic timestampToJson(TimestampWrapper? timestamp) =>
      timestamp?.timestamp;

  // Method to check if the timestamp is in the past
  bool isInThePast() {
    final timestampObj = toTimestamp();
    if (timestampObj == null) return true;
    return timestampObj.toDate().isBefore(DateTime.now());
  }

  // Method to convert the timestamp to DateTime, or return current time if null
  DateTime? toDateTime() {
    final timestampObj = toTimestamp();
    return timestampObj?.toDate();
  }
}

class ListQueue<T> {
  final _queue = Queue<T>();

  void add(T item) {
    if (_queue.length == 2) {
      _queue.removeLast();
    }
    _queue.addFirst(item);
  }

  List<T> getQueue() {
    return List.unmodifiable(_queue);
  }

  T? getBottom() {
    if (_queue.isEmpty) {
      return null; // Return null if the queue is empty
    }
    return _queue.last; // Get the last item in the queue
  }
}

typedef TransactionCompletedCallback = void Function(
    Map<String, dynamic> decodedRespBody);
typedef TransactionNotCompletedCallback = void Function(
    TransactionErrorType errorType, String reason);

int mapMonthsToIndex(int months) => [1, 3, 6, 12].indexOf(months);

final List<BottomNavItem> bottomNavItems = [
  const BottomNavItem(assetPath: AppAssets.globalSearch, label: "Explore"),
  const BottomNavItem(assetPath: AppAssets.fire, label: "Matching"),
  const BottomNavItem(assetPath: AppAssets.heart, label: "Likes/Match"),
  const BottomNavItem(assetPath: AppAssets.chat, label: "Chat"),
  const BottomNavItem(assetPath: AppAssets.user, label: "Profile"),
];

class GlobalKeys {
  // Global Keys for Bottom Navigation Items
  static final GlobalKey fireTabKey = GlobalKey();
  static final GlobalKey globalSearchTabKey = GlobalKey();
  static final GlobalKey heartTabKey = GlobalKey();
  static final GlobalKey chatTabKey = GlobalKey();
  static final GlobalKey userTabKey = GlobalKey();

  static final GlobalKey notificationKey = GlobalKey();
  static final GlobalKey advancedSearchKey = GlobalKey();
  static final GlobalKey matchingPreferencesKey = GlobalKey();
}

void resetAllNotifiers(BuildContext context) {
  context.read<ExploreNotifier>().reset();
  context.read<SwipeAndMatchNotifier>().reset();
  context.read<ChatsNotifier>().reset();
  context.read<TourNotifier>().reset();
  context.read<AdvancedSearchNotifier>().reset();
  context.read<EditProfileNotifier>().reset();
  context.read<PreferencesNotifier>().reset();
  context.read<LoginNotifier>().reset();
}

Future<LottieComposition?> customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(bytes, filePicker: (files) {
    return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'));
  });
}

String formatPrice(double price, String currencyCode) {
  final hasDecimal = price % 1 != 0;

  final formatter = NumberFormat.currency(
    name: currencyCode,
    decimalDigits: hasDecimal ? 2 : 0,
  );

  final formatted = formatter.format(price);
  final symbol = formatter.currencySymbol;

  return formatted.replaceFirst(symbol, '$symbol ');
}
