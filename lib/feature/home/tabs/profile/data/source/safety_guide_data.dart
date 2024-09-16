import '../../../../../../constants/index.dart';
import '../../model/guide_detail.dart';

final List<GuideDetail> guideDetails = [
  GuideDetail(AppAssets.bulb, 'General Safety Tips', [
    GuideDetailItem(
      'Trust Your Instincts',
      'If something feels off, it probably is. Don’t hesitate to stop communicating with someone you feel uncomfortable.',
    ),
    GuideDetailItem(
      'Stay on the Platform',
      'Keep all communications within the app until you are comfortable and sure about the person.',
    ),
  ]),
  GuideDetail(AppAssets.lock, 'Protecting Personal Information', [
    GuideDetailItem(
      'Keep Personal Details Private',
      'Avoid sharing your phone number, address, workplace, or other personal details with someone you just met online.',
    ),
    GuideDetailItem(
      'Stay on the Platform',
      'Use a strong password for your dating profile and avoid using same password across multiple accounts.',
    ),
  ]),
  GuideDetail(AppAssets.flag, 'Spotting Red Flags', [
    GuideDetailItem(
      'Inconsistent Information',
      'Be wary of people who give vague or conflicting information about themselves',
    ),
    GuideDetailItem(
      'Pressure for Personal Information',
      'Be cautious of someone who quickly wants personal details or tries to move the conversation off the app',
    ),
    GuideDetailItem(
      'Too Good to Be True',
      'Be suspicious of overly flattering or seemingly perfect profiles, as they may be fake.',
    ),
    GuideDetailItem(
      'Requests for Money',
      'Never send money or financial information to someone you’ve only met online.',
    ),
  ]),
  GuideDetail(AppAssets.comms, 'Communicating with Matches', [
    GuideDetailItem(
      'Take Your Time',
      'There’s no rush to give out your personal information or agree to meet in person. Get to know the person first.',
    ),
    GuideDetailItem(
      'Be Honest and Clear',
      'Clearly communicate your boundaries and comfort levels. If someone doesn’t respect them, it’s a red flag.',
    ),
  ]),
  GuideDetail(AppAssets.meet, 'Meeting in Person', [
    GuideDetailItem(
      'Meet in a Public Place',
      'Always meet in a well-lit, public location. Avoid secluded areas or meeting at your home.',
    ),
    GuideDetailItem(
      'Tell Someone',
      'Inform a friend or a family member about your plans, including who you’re meeting, where, and when.',
    ),
    GuideDetailItem(
      'Arrange Your Own Transportation',
      'Don’t rely on your date for transportation. Have a plan to get home safely on your own.',
    ),
    GuideDetailItem(
      'Stay Sober',
      'Avoid excessive alcohol or drug use during your first meetings, as it can impair your judgement and safety.',
    ),
  ]),
  GuideDetail(AppAssets.block, 'Reporting and Blocking', [
    GuideDetailItem(
      'Report Suspicious Behaviour',
      'Use the reporting feature to alert us of any users who violate our community guidelines or engage in harmful behaviour.',
    ),
    GuideDetailItem(
      'Block Unwanted Users',
      'If someone makes you uncomfortable or engages in harassment, block them immediately.',
    ),
    GuideDetailItem(
      'Contact Support',
      'Our support team is here to help. If you need assistance or have concerns, don’t hesitate to reach out.',
    ),
  ]),
  GuideDetail(AppAssets.faq, 'FAQs', [
    GuideDetailItem(
      'Q: How Do I Report a User?',
      'A: To report a user, go to profile, click the “Report” button, and follow the instructions.',
    ),
    GuideDetailItem(
      'Q: Can I delete my account if I feel unsafe?',
      'A: Yes, you can delete your account at any time in the account settings section of the app.',
    ),
    GuideDetailItem(
      'Q: What should I do if someone asks for money?',
      'A: Do not send money to anyone you’ve met online. Report the user to our support team immediately.',
    ),
  ]),
];
