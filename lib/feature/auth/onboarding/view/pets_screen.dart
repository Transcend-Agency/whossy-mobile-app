import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../data/source/workout_data.dart';
import '../data/state/onboarding_notifier.dart';

class PetsScreen extends StatefulWidget {
  final int pageIndex;

  const PetsScreen({super.key, required this.pageIndex});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen>
    with AutomaticKeepAliveClientMixin<PetsScreen> {
  WorkOut? _workOut;
  PetOwner? _pet;
  late OnboardingNotifier onboardingProvider;

  @override
  void initState() {
    super.initState();
    onboardingProvider = context.read<OnboardingNotifier>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkCompletion() {
    final isComplete = _pet != null && _workOut != null;
    if (onboardingProvider.isSelected(widget.pageIndex) != isComplete) {
      onboardingProvider.select(widget.pageIndex, value: isComplete);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<OnboardingNotifier>(
      builder: (_, onboarding, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const OnboardingHeaderText(
              title: "Do you own any pets?",
              subtitle: 'This will be shown on your profile',
              skip: true,
            ),
            addHeight(24),
            Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PetOwner.values.map((data) {
                  return SingleSelectAppChip<PetOwner?>(
                    value: data,
                    groupValue: _pet,
                    onChanged: (value) {
                      if (_pet != value) {
                        setState(() => _pet = value);
                        onboarding.updateUserProfile(pet: value?.index);
                        _checkCompletion();
                      }
                    },
                    title: data.name,
                  );
                }).toList()),
            addHeight(16),
           const AppDivider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 13.h),
              child: Text(
                "Do you workout?",
                style: TextStyles.hintText.copyWith(
                  fontSize: AppUtils.scale(11.sp),
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: workOutData.map((data) {
                return GenericTile(
                  value: data.value,
                  groupValue: _workOut,
                  onChanged: (value) {
                    if (_workOut != value) {
                      setState(() => _workOut = value);
                      onboarding.updateUserProfile(workOut: value?.index);
                      _checkCompletion();
                    }
                  },
                  title: data.text,
                );
              }).toList(),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
