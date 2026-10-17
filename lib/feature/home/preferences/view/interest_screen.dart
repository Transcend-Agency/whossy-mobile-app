import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/components/components.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/utils.dart';
import '../../../auth/onboarding/data/state/notifier_set.dart';
import '../../../auth/onboarding/model/alphabet.dart';

@RoutePage()
class InterestScreen extends HookWidget {
  const InterestScreen({super.key, this.initialValues});

  final List<String>? initialValues;

  @override
  Widget build(BuildContext context) {
    final selectedTicks =
        useState(NotifierSet<String>()..addAll(initialValues ?? []));
    final filteredAlphabet = useState(List.from(alphabet));
    final searchController = useTextEditingController();
    final searchFocusNode = useFocusNode();

    void filterSearchResults() {
      final query = searchController.text.toLowerCase();
      filteredAlphabet.value = alphabet
          .map((item) {
            final letter = item['letter'] as String;
            final options = item['options'] as List<String>;

            // Filter options based on the query
            final filteredOptions = options
                .where((option) => option.toLowerCase().contains(query))
                .toList();

            return {
              'letter': letter,
              'options': filteredOptions,
            };
          })
          .where((item) => (item['options'] as List<String>).isNotEmpty)
          .toList();
    }

    useEffect(() {
      searchController.addListener(filterSearchResults);
      return () {
        searchController.removeListener(filterSearchResults);
      };
    }, [searchController]);

    return AppScaffold(
      padding: pagePadding,
      appBar: const CustomAppBar(
        addBarHeight: 4,
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
                  itemCount: filteredAlphabet.value.length,
                  itemBuilder: (context, index) {
                    final letter =
                        filteredAlphabet.value[index]['letter'] as String;
                    final options = filteredAlphabet.value[index]['options']
                        as List<String>;

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
                          children: options
                              .map((item) => _buildAppChip(item, selectedTicks))
                              .toList(),
                        ),
                        addHeight(16),
                        if (index != filteredAlphabet.value.length - 1)
                          Column(
                            children: [
                              const AppDivider(),
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
                        selectedTicks.value.items,
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

  Widget _buildAppChip(
    String data,
    ValueNotifier<NotifierSet<String>> selectedTicks,
  ) {
    final isSelected = selectedTicks.value.contains(data);
    return AppChip(
      data: data,
      isSelected: isSelected,
      onTap: () {
        final updatedSet = NotifierSet<String>()
          ..addAll(selectedTicks.value.items);
        if (updatedSet.contains(data)) {
          updatedSet.remove(data);
        } else {
          updatedSet.add(data);
        }
        selectedTicks.value = updatedSet;
      },
    );
  }
}
