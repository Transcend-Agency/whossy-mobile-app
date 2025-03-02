import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/components.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/provider.dart';
import '../widgets/_.dart';

@RoutePage()
class BlockedContacts extends StatefulWidget {
  const BlockedContacts({super.key, required this.uids});

  final List<String> uids;

  @override
  State<BlockedContacts> createState() => _BlockedContactsState();
}

class _BlockedContactsState extends State<BlockedContacts> {
  final _listKey = GlobalKey<AnimatedListState>();
  late EditProfileNotifier _editNotifier;
  late ValueNotifier<List<String>> _uidsNotifier;

  @override
  void initState() {
    super.initState();

    _uidsNotifier = ValueNotifier(List.from(widget.uids));

    _editNotifier = context.read<EditProfileNotifier>();
  }

  void handleUnblock(String uid, int index, UserProfile profile) async {
    final removedUid = _uidsNotifier.value[index];

    _listKey.currentState?.removeItem(
      index,
      (ctx, animation) => _buildRemovedItem(
        removedUid,
        animation,
        profile,
        index,
      ),
      duration: const Duration(milliseconds: 300),
    );

    final previousUids = List<String>.from(_uidsNotifier.value);

    _uidsNotifier.value = List.from(_uidsNotifier.value)..removeAt(index);

    _editNotifier.updateProfile(blockedIds: _uidsNotifier.value);

    bool success = await _editNotifier.saveUserProfile(
      showSnackbar: (msg) => showSnackbar(msg, context),
    );

    if (!success) {
      // If saveUserProfile fails, rollback state
      _uidsNotifier.value = previousUids;
      _editNotifier.updateProfile(blockedIds: previousUids);
      if (Navigator.of(context).mounted) {
        showSnackbar(AppStrings.unblockFailure, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const CustomAppBar(
        title: 'Blocked Contacts',
        addBarHeight: 4,
      ),
      body: Selector<SettingsNotifier, Future<List<UserProfile>>>(
        selector: (_, notifier) => notifier.getBlockedUsers(widget.uids),
        builder: (_, futureBlockedUsers, __) {
          return FutureBuilder<List<UserProfile>>(
            future: futureBlockedUsers,
            builder: (context, snapshot) {
              return AppAnimatedSwitcher(
                child: buildContentBasedOnSnapshot(
                  context,
                  snapshot,
                  handleUnblock,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildContentBasedOnSnapshot(
    BuildContext context,
    AsyncSnapshot<List<UserProfile>> snapshot,
    void Function(String, int, UserProfile) handleUnblock,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return buildLoadingList();
    } else if (snapshot.hasError) {
      return buildErrorWidget(snapshot.error);
    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
      return buildEmptyData();
    } else if (snapshot.hasData) {
      return buildDataList(snapshot.data!, handleUnblock);
    } else {
      return buildErrorWidget(snapshot.error);
    }
  }

  Widget buildErrorWidget(Object? error) {
    return const BadNetworkDialog(
      key: ValueKey('error'),
    );
  }

  Widget buildEmptyData() {
    return EmptyDataBox(
      key: const ValueKey('empty'),
      header: svgIcon(
        AppAssets.blockUser,
        color: Colors.black,
        size: 45.r,
      ),
      spacing: 10,
      text: 'No blocked contacts',
    );
  }

  Widget buildLoadingList() {
    return AppListBuilder(
      key: const ValueKey('loading'),
      padding: EdgeInsets.zero,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const ShimmerBlockedTile(),
            Padding(
              padding: EdgeInsets.only(left: 51.w),
              child: const AppDivider(),
            ),
          ],
        );
      },
    );
  }

  Widget buildDataList(
    List<UserProfile> blockedUsers,
    void Function(String, int, UserProfile) handleUnblock,
  ) {
    return ValueListenableBuilder<List<String>>(
      key: const ValueKey('data'),
      valueListenable: _uidsNotifier,
      builder: (context, uids, child) {
        if (uids.isEmpty) {
          return buildEmptyData();
        }
        return AnimatedList(
          key: _listKey,
          initialItemCount: uids.length,
          itemBuilder: (context, index, animation) {
            final uid = uids[index];
            final profile = blockedUsers.firstWhere((u) => u.user.uid == uid);

            return SizeTransition(
              sizeFactor: animation,
              child: Column(
                children: [
                  BlockedListTile(
                    profile: profile,
                    handleUnblock: () => handleUnblock(uid, index, profile),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 51.w),
                    child: const AppDivider(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRemovedItem(
    String uid,
    Animation<double> animation,
    UserProfile profile,
    int index,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: Column(
        children: [
          BlockedListTile(
            profile: profile,
            handleUnblock: () => handleUnblock(uid, index, profile),
          ),
          Padding(
            padding: EdgeInsets.only(left: 51.w),
            child: const AppDivider(),
          ),
        ],
      ),
    );
  }
}
