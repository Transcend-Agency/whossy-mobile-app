import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/explore_data.dart';

import '../../../../../../../common/components/index.dart';
import '../../../../../../../provider/providers.dart';
import 'helper_components.dart';

class ExploreGrid extends StatelessWidget {
  const ExploreGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector2<ExploreNotifier, EditProfileNotifier, ExploreData>(
      selector: (_, explore, edit) => ExploreData(
        profileStream: explore.profileStream(edit.coreProfile?.blockedIds),
      ),
      builder: (_, result, __) {
        return StreamBuilder(
          stream: result.profileStream,
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
