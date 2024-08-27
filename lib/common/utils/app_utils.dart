import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppUtils {
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
}
