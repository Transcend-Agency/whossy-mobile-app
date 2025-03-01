import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/liked_user_profile.dart';

import '../../../../../../../common/components/index.dart';
import '../../../../../../../provider/providers.dart';
import 'helpers/index.dart';

class ExploreGrid extends StatelessWidget {
  const ExploreGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ExploreNotifier, Stream<List<LikedUserProfile>>>(
      selector: (_, explore) => explore.profileStream(),
      builder: (_, stream, __) {
        return StreamBuilder(
          stream: stream,
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

Widget buildContentBasedOnSnapshot(
  BuildContext context,
  AsyncSnapshot<List<LikedUserProfile>> snapshot,
) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const LoadingGrid();
  } else if (snapshot.hasError) {
    return ErrorGrid(error: snapshot.error);
  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
    return const EmptyDataGrid();
  } else if (snapshot.hasData) {
    return DataGrid(tileData: snapshot.data!);
  } else {
    return const Text('No data found');
  }
}
