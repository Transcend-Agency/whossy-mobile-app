import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../common/components/index.dart';
import '../../../../../../../provider/providers.dart';
import '../../../../matching/model/user_profile.dart';
import 'helper_components.dart';

class ExploreGrid extends StatelessWidget {
  const ExploreGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ExploreNotifier, Stream<List<UserProfile>>>(
      selector: (_, notifier) => notifier.profileStream,
      builder: (_, profileStream, __) {
        return StreamBuilder(
          stream: profileStream,
          builder: (context, snapshot) {
            return AppAnimatedSwitcher(
              child: buildContentBasedOnSnapshot(context, snapshot),
            );
          },
        );
      },
    );
  }
}
