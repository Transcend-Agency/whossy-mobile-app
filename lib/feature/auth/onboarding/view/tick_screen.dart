import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/styles/text_style.dart';

import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../data/state/notifier_set.dart';
import '../data/state/onboarding_notifier.dart';
import '../model/alphabet.dart';

class TickScreen extends StatefulWidget {
  final int pageIndex;
  const TickScreen({super.key, required this.pageIndex});

  @override
  State<TickScreen> createState() => _TickScreenState();
}

class _TickScreenState extends State<TickScreen>
    with AutomaticKeepAliveClientMixin<TickScreen> {
  late NotifierSet<String> _selectedTicks;
  late OnboardingNotifier onboardingProvider;

  final formKey1 = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  List<Map<String, dynamic>> _filteredAlphabet = [];

  @override
  void initState() {
    super.initState();
    _selectedTicks = NotifierSet<String>();
    _selectedTicks.addListener(_update);

    onboardingProvider =
        Provider.of<OnboardingNotifier>(context, listen: false);

    // Initialize filtered list
    _filteredAlphabet = List.from(alphabet);

    // Add listener for search functionality
    searchController.addListener(_filterSearchResults);
  }

  @override
  void dispose() {
    _selectedTicks.removeListener(_update);

    _selectedTicks.dispose();
    searchController.removeListener(_filterSearchResults);
    searchController.dispose();
    super.dispose();
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

  void _update() {
    int length = _selectedTicks.length;

    onboardingProvider.ticks = length;
    onboardingProvider.updateUserProfile(ticks: _selectedTicks.items);
    _checkCompletion(length);
  }

  void _checkCompletion(int length) {
    final isComplete = length >= 5;
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
          title: "Let's get to know you",
          subtitle: 'Share the interests and habits that define you.',
          skip: true,
        ),
        addHeight(18),
        Form(
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
        addHeight(12),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredAlphabet.length,
            itemBuilder: (context, index) {
              final letter = _filteredAlphabet[index]['letter'] as String;
              final options =
                  _filteredAlphabet[index]['options'] as List<String>;
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
        addHeight(72),
      ],
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
