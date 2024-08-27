import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../../auth/onboarding/data/state/notifier_set.dart';
import '../../../auth/onboarding/model/alphabet.dart';

@RoutePage<List<String>>()
class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key, this.initialValues});

  final List<String>? initialValues;
  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  late NotifierSet<String> _selectedTicks;

  final formKey1 = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  List<Map<String, dynamic>> _filteredAlphabet = [];

  @override
  void initState() {
    super.initState();
    _selectedTicks = NotifierSet<String>();
    _selectedTicks.addAll(widget.initialValues ?? []);

    // Initialize filtered list
    _filteredAlphabet = List.from(alphabet);

    // Add listener for search functionality
    searchController.addListener(_filterSearchResults);
  }

  void _filterSearchResults() {
    final query = searchController.text.toLowerCase();
    setState(() {
      _filteredAlphabet = alphabet
          .map((item) {
            final letter = item['letter'] as String;
            final options = item['options'] as List<String>;

            // Filter the options list based on the query
            final filteredOptions = options
                .where((option) => option.toLowerCase().contains(query))
                .toList();

            // Return the letter and its filtered options if any match the query
            return {
              'letter': letter,
              'options': filteredOptions,
            };
          })
          .where((item) => (item['options'] as List<String>).isNotEmpty)
          .toList();
    });
  }

  @override
  void dispose() {
    _selectedTicks.dispose();
    searchController.removeListener(_filterSearchResults);
    searchController.dispose();
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  itemCount: _filteredAlphabet.length,
                  itemBuilder: (context, index) {
                    // if (index >= _filteredAlphabet.length) {
                    //   // Return an empty container to avoid range errors
                    //   return const SizedBox.shrink();
                    // }

                    final letter = _filteredAlphabet[index]['letter'] as String;
                    final options =
                        _filteredAlphabet[index]['options'] as List<String>;

                    // if (options.isEmpty) {
                    //   // Skip if no options are available
                    //   return const SizedBox.shrink();
                    // }

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
                          children:
                              options.map((_) => _buildAppChip(_)).toList(),
                        ),
                        addHeight(16),
                        if (index != _filteredAlphabet.length - 1)
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
              addHeight(67),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPress: () => Navigator.pop<List<String>>(
                        context,
                        _selectedTicks.items,
                      ),
                      text: 'Save',
                    ),
                  ),
                ],
              ),
            ),
          )
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
