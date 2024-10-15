import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/providers.dart';
import '../../../data/source/edit_profile_data.dart';

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
  final _debouncer = Debouncer(milliseconds: 300);

  bool _hasUserUpdated = false;

  void updateHasUserUpdated(bool value) {
    setState(() {
      _hasUserUpdated = value;
    });
  }

  void _update() {
    final bio = textController.text;

    if (bio.isValidBio()) {
      editProfileProvider.updateProfile(bio: bio);
    }
  }

  void setUserUpdateFlag() {
    if (!_hasUserUpdated) {
      updateHasUserUpdated(true);
    }
  }

  @override
  void initState() {
    super.initState();

    editProfileProvider = context.read<EditProfileNotifier>();

    // Set the text programmatically first
    textController.text = editProfileProvider.coreProfile?.bio ?? '';

    // Then register the listener
    textController.addListener(() {
      updateCounter();
      _debouncer.run(_update);
      setUserUpdateFlag();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void updateCounter() {
    setState(() => _characterCount = textController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppDivider(),
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: EdgeInsets.symmetric(horizontal: 14.r),
          child: Column(
            children: [
              // Selector to efficiently rebuild only the TextFormField
              Selector<EditProfileNotifier, String?>(
                selector: (_, profile) => profile.coreProfile?.bio,
                builder: (_, bio, __) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (textController.text != bio && !_hasUserUpdated) {
                      textController.text = bio ?? '';
                      updateHasUserUpdated(true);
                    }
                  });
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
                            data: '+20%',
                            isSelected: false,
                            outlined: false,
                            isBold: true,
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 6.r),
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
                      ),
                      addHeight(4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$_characterCount/$_maxCharacterCount characters',
                          style: TextStyles.prefText.copyWith(
                            color: AppColors.hintTextColor,
                          ),
                        ),
                      ),
                      addHeight(4),
                    ],
                  );
                },
              ),
              // Consumer to handle broader profile updates
              Consumer<EditProfileNotifier>(
                builder: (_, profile, __) {
                  return PreferenceTile(
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
                  );
                },
              ),
            ],
          ),
        ),
        const AppDivider(),
      ],
    );
  }
}
