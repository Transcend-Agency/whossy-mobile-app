import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';
import '../../../../common/utils/router/router.gr.dart';
import '../../../../constants/index.dart';
import '../../../../provider/providers.dart';
import 'notification_screen.dart';

@RoutePage()
class NotificationProfilePreview extends HookWidget {
  final String id;

  const NotificationProfilePreview({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(true);
    final hasError = useState<bool>(false);
    final profile = useState<UserProfile?>(null);

    useEffect(() {
      Future<void> loadUserProfile() async {
        final notifier = context.read<NotificationNotifier>();

        try {
          final fetchedProfile = await notifier.getProfileData(id);
          if (fetchedProfile == null) {
            hasError.value = true;
          } else {
            profile.value = fetchedProfile;
          }
        } catch (e) {
          hasError.value = true;
        } finally {
          isLoading.value = false;
        }
      }

      loadUserProfile();
      return null;
    }, []);

    /// **Navigate when profile is loaded**
    useEffect(() {
      if (profile.value != null) {
        Future.microtask(() {
          Nav.replace(
            context,
            MatchingProfilePreview(
              index: 0,
              userProfile: profile.value!,
              pageName: NotificationScreen.name,
              isLiked: false,
              usePageView: true,
            ),
          );
        });
      }
      return null;
    }, [profile.value]);

    return AppScaffold(
      appBar: const CustomAppBar(
        addBarHeight: 4,
        titleWidget: SizedBox.shrink(),
        borderColor: Colors.white,
        color: Colors.white,
      ),
      body: Center(
        child: isLoading.value
            ? const AppLoader(
                key: ValueKey('loading'),
                color: AppColors.primaryColor,
              )
            : hasError.value
                ? const BadNetworkDialog(
                    key: ValueKey('error'),
                  )
                : const SizedBox(), // Empty since it navigates automatically
      ),
    );
  }
}
