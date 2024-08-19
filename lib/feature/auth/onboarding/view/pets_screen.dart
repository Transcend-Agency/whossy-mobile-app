import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../data/source/workout_data.dart';
import '../data/state/notifier_set.dart';
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
  late NotifierSet<String> _selectedPets;
  late OnboardingNotifier onboardingProvider;

  @override
  void initState() {
    super.initState();
    _selectedPets = NotifierSet<String>();
    _selectedPets.addListener(_update);

    onboardingProvider =
        Provider.of<OnboardingNotifier>(context, listen: false);
  }

  @override
  void dispose() {
    _selectedPets.removeListener(_update);

    _selectedPets.dispose();
    super.dispose();
  }

  void _update() {
    onboardingProvider.updateUserProfile(pets: _selectedPets.items);
    _checkCompletion();
  }

  void _checkCompletion() {
    final isComplete = _selectedPets.isNotEmpty && _workOut != null;
    if (onboardingProvider.isSelected(widget.pageIndex) != isComplete) {
      onboardingProvider.select(widget.pageIndex, value: isComplete);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          children: AppStrings.pets.map((pet) => _buildAppChip(pet)).toList(),
        ),
        addHeight(16),
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
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
        Consumer<OnboardingNotifier>(
          builder: (_, onboarding, __) {
            return ListView(
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
            );
          },
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildAppChip(String data) {
    return AppChip(
      data: data,
      isSelected: _selectedPets.contains(data),
      onTap: () {
        setState(() {
          if (_selectedPets.contains(data)) {
            _selectedPets.remove(data);
          } else {
            _selectedPets.add(data);
          }
        });
      },
    );
  }
}
