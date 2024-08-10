class AppStrings {
  static const String appName = 'Whossy';
  static const String splashText1 = 'Heartfelt Connections Await.';
  static const String splashText2 = '\nDiscover Love on Whossy.';
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

  // New strings for ResetPasswordScreen
  static const String resetPasswordTitle = 'Reset your password';
  static const String resetPasswordSubtitle =
      'Enter your email to receive otp code.';
  static const String sendLinkButton = 'Send link';

  // Strings for SignUpScreen
  static const String signUpTitle = "Welcome to Whossy, Let's get you Started!";
  static const String signUpSubtitle =
      'Ensure to enter the correct data, as some will be displayed on your profile.';
  static const String firstNameLabel = 'First name';
  static const String firstNameHint = 'John';
  static const String lastNameLabel = 'Last name';
  static const String lastNameHint = 'Doe';

  // Onboarding texts
  static const String distanceSubHeader =
      'Use the slider below to set a radius of how far you want our system to search for matches within your current location. You can always change this later in the settings.';

  static const requirements = [
    'Be at least 8 characters or more',
    'At least 1 uppercase and lowercase letter',
    'Must contain a digit or a number',
    "Must contain a special character e.g'@\$!%*?&'. ",
  ];

  static const List<String> leadingEmojis = [
    '🎉',
    '',
    '🤝',
    '😡',
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
    "Don’t hesitate to hit the report button whenever you feel threatened or see a bad behavior.",
  ];

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

  // Error messages for create account
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

  // Error messages for Login User
  static const String disabledAccount = 'Your account has been disabled';
  static const String userNotFound = 'Invalid email or password';
  static const String tooManyRequests = 'Too many requests, try again later';

  static const String success = 'Successful';

  static const String reset =
      'A link has been sent to your email to reset your password.';

  static const String unregisteredEmail =
      'Account not registered with app, consider signing up instead';

  static const String registeredEmail = 'Account already registered';

  static const String differentCredentials =
      'Account exists with different credential';

  static const String accUnselected = 'No account selected';
}
