import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../view_model/onboarding_provider.dart';

class DrinkScreen extends StatefulWidget {
  final int pageIndex;

  const DrinkScreen({super.key, required this.pageIndex});

  @override
  State<DrinkScreen> createState() => _DrinkScreenState();
}

class _DrinkScreenState extends State<DrinkScreen>
    with AutomaticKeepAliveClientMixin<DrinkScreen> {
  Drink? _drink;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Do you drink?",
          subtitle: 'This will be shown on your profile',
          skip: true,
        ),
        addHeight(24),
        ListView(
          shrinkWrap: true,
          children: AppConstants.drinkData.map((data) {
            return GenericTile(
              value: data.value,
              groupValue: _drink,
              onChanged: (value) {
                setState(() => _drink = value);
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
}
