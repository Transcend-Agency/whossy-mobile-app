import 'package:whossy_app/constants/asset_paths.dart';

class AppStrings {
  // General
  static const String appName = 'Whossy';

  // Splash Screen
  static const String splashText1 = 'Heartfelt Connections Await.';
  static const String splashText2 = '\nDiscover Love on Whossy.';

  // Authentication
  static const String noAccount = 'Don\'t have an account?  ';
  static const String cAccount = 'Create account';
  static const String welBack = 'Welcome back';
  static const String loginSub = "Login to see who you've matched with ✌️";
  static const String emailPhoneLabel = "Email";
  static const String emailHint = 'example@gmail.com';
  static const String passwordLabel = "Password";
  static const String passwordHint = 'Password';
  static const String forgotPassword = "Forgot Password ?";
  static const String loginButton = 'Login';
  static const String orDivider = 'or sign in with';
  static const String signInFacebook = 'Sign in with Facebook';
  static const String signInGoogle = 'Sign in with Google';
  static const String createAccountButton = 'Create new account';
  static const String loginAgreement = 'By clicking "Login" you agree to our';
  static const String createAgreement =
      'By clicking "Create account" you agree to our';
  static const String termsAndConditions = ' Terms and conditions.';
  static const String privacyPolicy = ' Privacy Policy.';
  static const String dataProcessingInfo =
      ' Learn how we process our data in our';

  // Reset Password Screen
  static const String resetPasswordTitle = 'Reset your password';
  static const String resetPasswordSubtitle =
      'Enter your email to receive otp code.';
  static const String sendLinkButton = 'Send link';

  // Sign Up Screen
  static const String signUpTitle = "Welcome to Whossy, Let's get you Started!";
  static const String signUpSubtitle =
      'Ensure to enter the correct data, as some will be displayed on your profile.';
  static const String firstNameLabel = 'First name';
  static const String firstNameHint = 'John';
  static const String lastNameLabel = 'Last name';
  static const String lastNameHint = 'Doe';

  // Profile
  static const String profileAddMore =
      'Add more info to your profile to stand out. Click on the edit button to get started.';
  static const String profileBio =
      'I am very excited to meet new people and make friends. Let’s start with that and see where it takes us 🚀';

  // Onboarding
  static const String distanceSubHeader =
      'Use the slider below to set a radius of how far you want our system to search for matches within your current location. You can always change this later in the settings.';
  static const String onboardingSelfieTitle = "Take a Selfie";
  static const String onboardingSelfieSubtitle =
      "Tap on the camera icon to take a snapshot of yourself for verification. Kindly use a well-lighted background and avoid blurry photos.";
  static const String onboardingSelfieRetakeTitle = "Awesome!";
  static const String onboardingSelfieRetakeSubtitle =
      'Not satisfied? You can always retake the selfie until the desired result is achieved and click continue to save.';
  static const String skip = "Skip";

  // Requirements
  static const List<String> requirements = [
    'Be at least 8 characters or more',
    'At least 1 uppercase and lowercase letter',
    'Must contain a digit or a number',
    "Must contain a special character e.g'@\$!%*?&'. ",
  ];

  // Preferences
  static const List<String> pets = [
    "🐕  Dog",
    "🐈  Cat",
    "🐍  Reptile",
    "🐸  Amphibian",
    "🐦  Bird",
    "🐟  Fish",
    "😒  Don't like pets",
    "🐇  Rabbits",
    "🐁  Mouse",
    "😉  Planning on getting",
    "🤧  Allergic",
    "🐴  Other",
    "😊  Want a pet",
  ];

  // Guidelines
  static const List<String> leadingEmojis = [
    AppAssets.real,
    AppAssets.exclamation,
    AppAssets.shake,
    AppAssets.anger,
  ];

  static const List<String> titles = [
    'Be real',
    'DO NOT share personal data or information',
    'Respect others',
    'Report bad behaviour',
  ];

  static const List<String> subtitles = [
    "Ensure your photos, age, and bio are true. This will increase your chances of getting matched.",
    "Always keep your personal information and do not be too quick to share with anyone.",
    "Treat others the way you would like to be treated, avoid being rude, and chat safely.",
    "Don’t hesitate to hit the report button whenever you feel threatened or see bad behaviour.",
  ];

  static const List<String> freePricing = [
    'Profile Browsing',
    'Swipe and Match',
    'See Who Liked You',
    'Profile Boost',
  ];

  static const List<String> premiumPricing = [
    'Chat Initiation',
    'Rewind',
    'Top Picks',
    'Read Receipts',
  ];

  // Error Messages
  static const String errorEmailInUse = 'Account already exists';
  static const String errorInvalidEmail = 'The email address is not valid.';
  static const String errorInvalidCode = 'Invalid code';
  static const String errorOperationNotAllowed =
      'This authentication method is not enabled.';
  static const String errorWeakPassword = 'The password provided is too weak.';
  static const String errorNetworkRequestFailed = 'Poor internet connection';
  static const String errorUnknown =
      'An unknown error occurred. Please try again later.';
  static const String deviceOffline =
      'Network unavailable. Please try again later.';
  static const String deniedAccess =
      'Unable to access photos. Please update your permissions in settings.';
  static const String unblockFailure =
      'Failed to unblock user, Please try again';
  static const String blockFailure = 'Failed to block user, Please try again';
  static const String addCreditsFailure =
      'Failed to add credits, Please try again';
  static const String payPremiumFailure =
      'Failed to make payment, Please try again';
  static const String unsubscribePremiumFailure =
      'Failed to unsubscribe from premium, Please try again';
  static const String deductCreditsFailure =
      'Failed to deduct credits, Please try again';
  static const String unUploadedPhotos = 'Some photos could not be uploaded';

  // Login User Errors
  static const String disabledAccount = 'Your account has been disabled';
  static const String userNotFound = 'Invalid email or password';
  static const String tooManyRequests = 'Too many requests, try again later';

  // Success
  static const String success = 'Successful';
  static const String reset =
      'A link has been sent to your email to reset your password.';

  // Registration Status
  static const String unregisteredEmail =
      'Account not registered with app, consider signing up instead';
  static const String registeredEmail = 'Account already registered';
  static const String differentCredentials =
      'Account exists with different credential';

  // Misc
  static const String accUnselected = 'No account selected';
  static const String signOutFailure = 'Failed to sign out. Please try again.';
  static const String logout =
      'All your current sessions will be closed after logging out. Are you sure you want to log out?';
  static const String cancelPlan =
      'Are you sure you want to cancel your premium plan? You will lose access to premium features after your current billing cycle ends';

  static const String noProfilePic =
      'You need to add at least one photo to preview your profile.';
  static const String uploadTimeout =
      "Failed to upload profile pictures. Please check your network and try again.";
  static const String minPicsRequired =
      'You need at least 3 photos to save your profile.';

  static const String mission =
      'Our mission is to help you connect with new people in a safe and enjoyable environment. Your safety is our top priority, and we have put together this guide to help you navigate the online dating world securely and confidently.';
  static const String chatSafety =
      'Please respect people privacy and chat safely with everyone. We at Whossy have technology that can detect harmful, malicious or illegal activity in your messages. \n \nAny suspicious activity will have your account suspended. By clicking “Continue” you agree to our ';

  // Paths
  static String profilePicsPath(String? uid, String fileName) {
    return 'users/$uid/profile_pictures/$fileName';
  }

  static String faceVerPicPath(String? uid, String fileName) {
    return 'users/$uid/face_verification/$fileName';
  }

  static String chatPicsPath(String fileName, String chatId) {
    return 'chats/$chatId/$fileName';
  }

  static String blockUser(String name) =>
      "Are you sure you want to block $name? You can unblock them later under Settings -> Blocked Contacts.";
  static String reportUser =
      "Our team will review your report to ensure community guidelines are upheld.";
  static String unlockChat(String name) =>
      "Unlock this chat with $name for 1 credit. You'll have access for 24 hours.";

  static const String permissionDeniedPhoneCheck =
      'Unable to check for phone number uniqueness due to insufficient permissions.';

  static String disAbleUnapproved(String value) =>
      '$value is disabled until you have been approved';

  // Tutorial for the 'Like' button
  static const String likeButtonTutorial =
      'Tap the button to show interest in a profile. If both you and the other person like each other, it\'s a match!';

  // Tutorial for the 'Dislike' button
  static const String dislikeButtonTutorial =
      'Tap the button to skip a profile you\'re not interested in. You\'ll never see it again!';

  //// Bottom Tabs
  // Tutorial for the 'Swipe and Match' tab (FireTab)
  static const String fireTabTutorial =
      'Swipe through profiles to show interest. If you both swipe right, it\'s a match!';

  // Tutorial for the 'Explore' tab (GlobalSearchTab)
  static const String globalSearchTabTutorial =
      'Browse through profiles freely, no need to swipe. Just explore and discover!';

  // Tutorial for the 'Likes and Matches' tab (HeartTab)
  static const String heartTabTutorial =
      'See people who have liked you, and view your matches here!';

  // Tutorial for the 'Chats' tab (ChatTab)
  static const String chatTabTutorial =
      'You can send messages and images to your matches. Chat away!';

  // Tutorial for the 'Profile' tab (UserTab)
  static const String userTabTutorial =
      'Manage your profile, edit your information, and access your settings here.';
}
