import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/feature/home/data/state/user_notifier.dart';
import 'package:whossy_mobile_app/feature/home/model/extras.dart';
import 'package:whossy_mobile_app/feature/home/view/preference/components/city_sheet.dart';
import 'package:whossy_mobile_app/feature/home/view/preference/components/range_sheet.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import 'extras_sheet.dart';

class ExtrasComponent extends StatefulWidget {
  const ExtrasComponent({super.key});

  @override
  State<ExtrasComponent> createState() => _ExtrasComponentState();
}

class _ExtrasComponentState extends State<ExtrasComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: EdgeInsets.symmetric(horizontal: 14.r),
          child: Consumer<UserNotifier>(
            builder: (_, user, __) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: AppConstants.extraPreferences1.length,
                    itemBuilder: (_, index) {
                      final item = AppConstants.extraPreferences1[index];

                      return PreferenceTile(
                        key: ValueKey(index),
                        text: item.header,
                        onTap: () async {
                          final value = await showCustomModalBottomSheet(
                            selectedItem: user.getSelected(item.type),
                            context: context,
                            item: item,
                          );

                          if (value != null) {
                            setState(() => user.setValue(value));
                          }
                        },
                        trailing: user.getValue(item.type),
                      ); //
                    },
                  ),
                  PreferenceTile(
                    text: 'Country of Residence',
                    onTap: () => showPicker(
                      showCode: false,
                      onSelect: (_) => user.updatePreferences(country: _.name),
                    ),
                    trailing: user.otherPreferences.country ?? 'Choose',
                  ),
                  PreferenceTile(
                    text: 'City of Residence',
                    onTap: () async {
                      final city = await showCitySheet(
                        context: context,
                        city: user.otherPreferences.city,
                      );

                      if (city != null) {
                        user.updatePreferences(city: city);
                      }
                    },
                    trailing: user.otherPreferences.city ?? 'Choose',
                  ),
                  PreferenceTile(
                    text: 'Height',
                    onTap: () async {
                      final height = await showRangeSheet(
                        context: context,
                        range: user.otherPreferences.toHeightRange(),
                        type: RangeType.height,
                      );

                      if (height != null) {
                        user.updatePreferences(
                          minHeight: height.start.round(),
                          maxHeight: height.end.round(),
                        );
                      }
                    },
                    trailing: user.otherPreferences.heightRange.displayRange(),
                  ),
                  PreferenceTile(
                    text: 'Weight',
                    onTap: () async {
                      final weight = await showRangeSheet(
                        context: context,
                        range: user.otherPreferences.toWeightRange(),
                        type: RangeType.weight,
                      );

                      if (weight != null) {
                        user.updatePreferences(
                          minWeight: weight.start.round(),
                          maxWeight: weight.end.round(),
                        );
                      }
                    },
                    trailing: user.otherPreferences.weightRange
                        .displayRange(type: RangeType.weight),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: AppConstants.extraPreferences2.length,
                    itemBuilder: (_, index) {
                      final item = AppConstants.extraPreferences2[index];

                      return PreferenceTile(
                        key: ValueKey(index),
                        text: item.header,
                        onTap: () async {
                          final value = await showCustomModalBottomSheet(
                            selectedItem: user.getSelected(item.type),
                            context: context,
                            item: item,
                          );

                          if (value != null) {
                            setState(() => user.setValue(value));
                          }
                        },
                        trailing: user.getValue(item.type),
                        showDivider:
                            index < AppConstants.extraPreferences2.length - 1,
                      ); //
                    },
                  ),
                ],
              );
            },
          ),
        ),
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
      ],
    );
  }

  void showPicker({
    bool showCode = true,
    required void Function(Country) onSelect,
  }) {
    showCountryPicker(
      header: _header(),
      useSafeArea: true,
      context: context,
      moveAlongWithKeyboard: true,
      showPhoneCode: showCode,
      countryListTheme: AppTheme().countryListTheme(),
      onSelect: onSelect,
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Country of Residence',
            style: TextStyles.buttonText.copyWith(
              fontSize: AppUtils.scale(17),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SizedBox.square(
              dimension: 30.r,
              child: cancelIcon(),
            ),
          ),
        ],
      ),
    );
  }
}

Future<T?> showCustomModalBottomSheet<T extends GenericEnum>({
  required BuildContext context,
  required ExtraPreferences<T> item,
  T? selectedItem,
}) {
  return showModalBottomSheet<T?>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => ExtrasSheet<T>(item: item, selectedItem: selectedItem),
  );
}

Future<String?> showCitySheet({
  required BuildContext context,
  String? city,
}) {
  return showModalBottomSheet<String?>(
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => CitySheet(city: city),
  );
}

Future<RangeValues?> showRangeSheet({
  required RangeValues? range,
  required BuildContext context,
  required RangeType type,
}) {
  return showModalBottomSheet<RangeValues?>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => RangeSheet(
      range: range,
      type: type,
    ),
  );
}
