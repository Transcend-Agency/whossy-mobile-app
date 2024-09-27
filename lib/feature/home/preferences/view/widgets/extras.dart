import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';
import '../../data/source/core_prefs_data.dart';
import '../../data/source/extensions.dart';
import '../sheets/_.dart';

class ExtrasComponent<T extends SearchPreferencesNotifier>
    extends StatelessWidget {
  const ExtrasComponent({super.key});

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
          child: Consumer<T>(
            builder: (_, notifier, __) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: corePrefsData.length - 3,
                    itemBuilder: (_, index) {
                      final item = corePrefsData[index];

                      return PreferenceTile(
                        key: ValueKey(index),
                        text: item.header,
                        onTap: () async {
                          final value = await showCustomModalBottomSheet(
                            selectedItem: notifier.getSelected(item.type),
                            context: context,
                            item: item,
                          );

                          if (value != null) {
                            notifier.setValue(value);
                          }
                        },
                        trailing: notifier.selectedItems == null
                            ? null
                            : notifier.getValue(item.type),
                      );
                    },
                  ),
                  PreferenceTile(
                    text: 'Country of Residence',
                    onTap: () => showPicker(
                      showCode: false,
                      onSelect: (_) =>
                          notifier.updatePreferences(country: _.name),
                      context: context,
                    ),
                    trailing: notifier.otherPreferences?.country ??
                        (notifier.otherPreferences == null ? null : 'Choose'),
                  ),
                  PreferenceTile(
                    text: 'City of Residence',
                    onTap: () async {
                      final city = await showCitySheet(
                        context: context,
                        city: notifier.otherPreferences?.city,
                      );

                      if (city != null) {
                        notifier.updatePreferences(city: city);
                      }
                    },
                    trailing: notifier.otherPreferences?.city ??
                        (notifier.otherPreferences == null ? null : 'Choose'),
                  ),
                  PreferenceTile(
                    text: 'Height',
                    onTap: () async {
                      final height = await showRangeSheet(
                        context: context,
                        range: notifier.otherPreferences?.toHeightRange(),
                        type: RangeType.height,
                      );

                      if (height != null) {
                        notifier.updatePreferences(
                          minHeight: height.start.round(),
                          maxHeight: height.end.round(),
                        );
                      }
                    },
                    trailing: notifier.otherPreferences?.heightRange
                            .displayRange() ??
                        (notifier.otherPreferences == null ? null : 'Choose'),
                  ),
                  PreferenceTile(
                    text: 'Weight',
                    onTap: () async {
                      final weight = await showRangeSheet(
                        context: context,
                        range: notifier.otherPreferences?.toWeightRange(),
                        type: RangeType.weight,
                      );

                      if (weight != null) {
                        notifier.updatePreferences(
                          minWeight: weight.start.round(),
                          maxWeight: weight.end.round(),
                        );
                      }
                    }, //
                    trailing: notifier.otherPreferences?.weightRange
                            .displayRange(type: RangeType.weight) ??
                        (notifier.otherPreferences == null ? null : 'Choose'),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (_, index) {
                      final item = corePrefsData[index + 10];

                      return PreferenceTile(
                        key: ValueKey(index),
                        text: item.header,
                        onTap: () async {
                          final value = await showCustomModalBottomSheet(
                            selectedItem: notifier.getSelected(item.type),
                            context: context,
                            item: item,
                          );

                          if (value != null) {
                            notifier.setValue(value);
                          }
                        },
                        trailing: notifier.selectedItems == null
                            ? null
                            : notifier.getValue(item.type),
                        showDivider: index < 2,
                      );
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
    required BuildContext context,
  }) {
    showCountryPicker(
      header: _header(context),
      useSafeArea: true,
      context: context,
      moveAlongWithKeyboard: true,
      showPhoneCode: showCode,
      countryListTheme: AppTheme().countryListTheme(
        textStyle: TextStyles.prefText.copyWith(
          color: AppColors.hintTextColor,
          fontSize: AppUtils.scale(11.sp) ?? 13.5.sp,
          // fontSize: AppUtils.scale(11.sp) ?? 9.sp,
        ),
      ),
      onSelect: onSelect,
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w).copyWith(
        top: AppUtils.scale(11.h),
        bottom: AppUtils.scale(11.h),
      ),
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
