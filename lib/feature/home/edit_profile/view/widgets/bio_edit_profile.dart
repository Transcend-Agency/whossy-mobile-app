import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';
import 'package:whossy_mobile_app/feature/home/edit_profile/data/source/edit_profile_data.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';
import '../../../preferences/view/widgets/extras.dart';

class BioEditProfile extends StatefulWidget {
  const BioEditProfile({super.key});

  @override
  State<BioEditProfile> createState() => _BioEditProfileState();
}

class _BioEditProfileState extends State<BioEditProfile> {
  late EditProfileNotifier editProfileProvider;

  final textController = TextEditingController();
  final focusNode = FocusNode();

  int _characterCount = 0;
  static const int _maxCharacterCount = 500;
  final _debouncer = Debouncer(milliseconds: 1000);

  void _update() {
    final bio = textController.text;

    if (bio.isValidBio()) {
      editProfileProvider.updateProfile(bio: bio);
    }
  }

  @override
  void initState() {
    super.initState();

    textController.addListener(() {
      updateCounter();
      _debouncer.run(_update);
    });

    editProfileProvider =
        Provider.of<EditProfileNotifier>(context, listen: false);

    if (editProfileProvider.coreProfile.bio != null) {
      textController.text = editProfileProvider.coreProfile.bio!;
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void updateCounter() {
    setState(() {
      _characterCount = textController.text.length;
    });
  }

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
          child: Consumer<EditProfileNotifier>(
            builder: (_, profile, __) {
              return Column(
                children: [
                  addHeight(13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        " Bio",
                        style: TextStyles.prefText,
                      ),
                      AppChip(
                        data: '+20',
                        isSelected: false,
                        outlined: false,
                        isBold: true,
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 6.w),
                      ),
                    ],
                  ),
                  UnderlineTextField(
                    focusNode: focusNode,
                    textController: textController,
                    maxLength: _maxCharacterCount,
                    keyType: TextInputType.multiline,
                    validation: (bio) => bio?.trim().validateBio(),
                    validationMode: AutovalidateMode.onUserInteraction,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
                  ),
                  addHeight(3),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$_characterCount/$_maxCharacterCount characters',
                      style: TextStyles.prefText.copyWith(
                        color: AppColors.hintTextColor,
                      ),
                    ),
                  ),
                  addHeight(4),
                  PreferenceTile(
                    text: 'Relationship preference',
                    onTap: () async {
                      final item = relationshipData;

                      final value = await showCustomModalBottomSheet(
                        selectedItem: profile.getSelected(item.type),
                        context: context,
                        item: item,
                      );

                      if (value != null) {
                        profile.setValue(value);
                      }
                    },
                    trailing: profile.getValue(Preference),
                    showDivider: false,
                  )
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
}
