import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/feature/home/data/state/user_notifier.dart';
import 'package:whossy_mobile_app/feature/home/model/extras.dart';
import 'package:whossy_mobile_app/feature/home/view/preference/components/custom_extra_sheet.dart';

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
                    text: 'Height',
                    onTap: () async {
                      await showCustomExtraSheet(
                        context: context,
                      );
                    },
                    trailing: 'Choose',
                  ),
                  PreferenceTile(
                    text: 'Country of Residence',
                    onTap: () => showPicker(
                      showCode: false,
                      onSelect: (_) {},
                    ),
                    trailing: 'Choose',
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
      useSafeArea: true,
      context: context,
      moveAlongWithKeyboard: true,
      showPhoneCode: showCode,
      countryListTheme: AppTheme().countryListTheme(),
      onSelect: onSelect,
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

Future showCustomExtraSheet({
  required BuildContext context,
}) {
  return showModalBottomSheet(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => const CustomExtraSheet(),
  );
}
