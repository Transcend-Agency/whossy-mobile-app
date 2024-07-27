import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/common/components/index.dart';

import '../../common/styles/component_style.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: pagePadding,
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SignupHeaderText(
            title: "User logged in",
            subtitle:
                "Onboarding and Creation is okay, account has also been verified",
          ),
        ],
      ),
    );
  }
}
