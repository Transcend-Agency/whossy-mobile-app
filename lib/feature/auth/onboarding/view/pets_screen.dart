import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../view_model/onboarding_provider.dart';

class PetsScreen extends StatefulWidget {
  final int pageIndex;

  const PetsScreen({super.key, required this.pageIndex});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen>
    with AutomaticKeepAliveClientMixin<PetsScreen> {
  WorkOut? _workOut;
  final Set<String> _selectedPets = {};

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
          spacing: 4.w,
          runSpacing: 6.h,
          children: [...AppStrings.pets.map((_) => _buildAppChip(_))],
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
        ListView(
          shrinkWrap: true,
          children: AppConstants.workOutData.map((data) {
            return GenericTile(
              value: data.value,
              groupValue: _workOut,
              onChanged: (value) {
                setState(() => _workOut = value);
                context.read<OnboardingProvider>().select(widget.pageIndex);
              },
              title: data.text,
            );
          }).toList(),
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
