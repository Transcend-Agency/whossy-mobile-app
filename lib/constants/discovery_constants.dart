/// C2 — one shared window for "New members", used by both the Explore
/// filter (explore_filters_component.dart) and the "New" badge
/// (matching/model/user_profile.dart). They used to hardcode the same value
/// independently, which was only accidentally in sync.
const kNewMemberWindow = Duration(days: 7);

/// C2 — default search radius for "Popular in my area" when the viewer
/// hasn't set a distance preference. Matches the onboarding slider's
/// default (distance_screen.dart).
const kDefaultDiscoveryRadiusMiles = 50.0;
