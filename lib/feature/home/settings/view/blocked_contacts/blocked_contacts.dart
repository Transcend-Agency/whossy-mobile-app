import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';
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
  late EditProfileNotifier _editProfileNotifier;
  late ValueNotifier<List<String>> _uidsNotifier;

  @override
  void initState() {
    super.initState();

    _uidsNotifier = ValueNotifier(List.from(widget.uids));

    _editProfileNotifier = context.read<EditProfileNotifier>();
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

    _editProfileNotifier.updateProfile(blockedIds: _uidsNotifier.value);

    bool success = await _editProfileNotifier.saveUserProfile(
      showSnackbar: (msg) => showSnackbar(msg),
      returnResult: true,
    );

    if (!success) {
      // If saveUserProfile fails, rollback state
      _uidsNotifier.value = previousUids;
      _editProfileNotifier.updateProfile(blockedIds: previousUids);
      showSnackbar(AppStrings.unblockFailure);
    }
  }

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
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
      return const Center(child: Text('Something went wrong.'));
    }
  }

  Widget buildErrorWidget(Object? error) {
    return Center(
      key: const ValueKey('error'),
      child: Text(
        'Error: $error',
        style: const TextStyle(color: Colors.red),
      ),
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
