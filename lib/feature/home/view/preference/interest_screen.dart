import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../../../auth/onboarding/data/state/notifier_set.dart';
import '../../../auth/onboarding/model/alphabet.dart';

@RoutePage()
class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  late NotifierSet<String> _selectedTicks;

  final formKey1 = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedTicks = NotifierSet<String>();
    // Register a listener here _selectedTicks.addListener();
  }

  @override
  void dispose() {
    // Remove _selectedTicks.removeListener(_update);

    _selectedTicks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: pagePadding,
      appBar: const CustomAppBar(
        title: 'Interest',
        showAction: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Todo: Add search functionality here
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Form(
              key: formKey1,
              child: AppTextField(
                focusNode: searchFocusNode,
                textController: searchController,
                hintText: 'search',
                prefixIcon: search(),
                padding: 13,
                curvierEdges: true,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: alphabet.length,
              itemBuilder: (context, index) {
                final letter = alphabet[index]['letter'] as String;
                final options = alphabet[index]['options'] as List<String>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      letter.toUpperCase(),
                      style: TextStyles.tickTitle.copyWith(
                        fontSize: AppUtils.scale(12.sp),
                      ),
                    ),
                    addHeight(4),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: options.map((_) => _buildAppChip(_)).toList(),
                    ),
                    addHeight(16),
                    if (index != alphabet.length - 1)
                      Column(
                        children: [
                          const Divider(
                            color: AppColors.outlinedColor,
                            height: 0,
                          ),
                          addHeight(12),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),

          addHeight(8),
        ],
      ),
    );
  }

  Widget _buildAppChip(String data) {
    final isSelected = _selectedTicks.contains(data);
    return AppChip(
      data: data,
      isSelected: isSelected,
      onTap: () {
        setState(() {
          if (_selectedTicks.contains(data)) {
            _selectedTicks.remove(data);
          } else {
            _selectedTicks.add(data);
          }
        });
      },
    );
  }
}
