import 'package:flutter/material.dart';

import '../../feature/home/model/extras.dart';

enum RangeType {
  height('Height', [140, 220], RangeValues(160, 200)),
  weight('Weight', [40, 140], RangeValues(60, 120));

  const RangeType(this.name, this.feasibleRange, this.placeholder);

  final String name;
  final List<double> feasibleRange;
  final RangeValues placeholder;
}

enum Meet {
  men('Male'),
  women('Female'),
  everyone('Everyone');

  const Meet(this.name);

  final String name;
}

enum Preference implements GenericEnum {
  lookingToDate('Looking to date', 'Seeking casual dating experience'),
  chattingAndConnecting('Chatting and connecting',
      'Open to conversations and getting to know new people'),
  readyForCommitment('Ready for commitment',
      'For those who are looking for a serious, committed relationship'),
  justForFun('Just for fun',
      'Seeking fun and carefree connections without long term plans'),
  undecidedOrExploring('Undecided or exploring',
      'Not sure what you\'re looking for? Discover what feels right for you');

  const Preference(this.name, this.subtitle);

  @override
  final String name;
  final String subtitle;
}

enum School implements GenericEnum {
  notInSchool('Not In School'),
  currentlySchooling('Currently Schooling');

  const School(this.name);

  @override
  final String name;
}

enum Zodiac implements GenericEnum {
  aries('Aries', 'March 21 - April 19'),
  taurus('Taurus', 'April 20 - May 20'),
  gemini('Gemini', 'May 21 - June 20'),
  cancer('Cancer', 'June 21 - July 22'),
  leo('Leo', 'July 23 - August 22'),
  virgo('Virgo', 'August 23 - September 22'),
  libra('Libra', 'September 23 - October 22'),
  scorpio('Scorpio', 'October 23 - November 21'),
  sagittarius('Sagittarius', 'November 22 - December 21'),
  capricorn('Capricorn', 'December 22 - January 19'),
  aquarius('Aquarius', 'January 20 - February 18'),
  pisces('Pisces', 'February 19 - March 20');

  const Zodiac(this.name, this.dateRange);

  @override
  final String name;
  final String dateRange;
}

enum Drink implements GenericEnum {
  mindful('Mindful Drinking'),
  sober('100% Sober'),
  special('Special moments only'),
  regular('Regular nights out'),
  no('Not my thing');

  const Drink(this.name);

  @override
  final String name;
}

enum Smoke implements GenericEnum {
  working('Working on quitting'),
  dAndS('Drinks and smoke'),
  occasional('Occasional smoker'),
  frequent('Frequent smoker'),
  no('Doesn\'t smoke');

  const Smoke(this.name);

  @override
  final String name;
}

enum LoveLanguage implements GenericEnum {
  givingAndReceivingGifts('Giving and receiving gifts'),
  touchAndHugs('Touch and hugs'),
  heartfeltCompliments('Heartfelt compliments'),
  doingThingsForEachOther('Doing things for each other'),
  spendingTimeTogether('Spending time together');

  const LoveLanguage(this.name);

  @override
  final String name;
}

enum CommunicationStyle implements GenericEnum {
  directAndToThePoint('Direct and to the point'),
  friendlyAndOpen('Friendly and open'),
  reservedAndThoughtful('Reserved and thoughtful'),
  humorousAndLighthearted('Humorous and lighthearted'),
  detailedAndDescriptive('Detailed and descriptive');

  const CommunicationStyle(this.name);

  @override
  final String name;
}

enum FutureFamilyPlans implements GenericEnum {
  wantsChildren('I want children'),
  notSureYet('Not sure yet'),
  notInterestedForNow('Not interested for now'),
  doesntWantChildren('I don’t want children'),
  hasChildren('I have children'),
  wantsMoreChildren('I want more');

  const FutureFamilyPlans(this.name);

  @override
  final String name;
}

enum Religion implements GenericEnum {
  christian('Christian'),
  muslim('Muslim'),
  other('Other');

  const Religion(this.name);

  @override
  final String name;
}

enum Dietary implements GenericEnum {
  vegetarian('Vegetarian'),
  vegan('Vegan'),
  pescatarian('Pescatarian'),
  halal('Halal'),
  carnivore('Carnivore'),
  omnivore('Omnivore'),
  other('Other');

  const Dietary(this.name);

  @override
  final String name;
}

enum MaritalStatus implements GenericEnum {
  single('Single'),
  taken('Taken'),
  open('Open');

  const MaritalStatus(this.name);

  @override
  final String name;
}

enum WorkOut implements GenericEnum {
  yes('Yes, regularly'),
  occasionally('Occasionally'),
  weekends('Only on weekends'),
  rarely('Rarely'),
  no('Not at all');

  const WorkOut(this.name);

  @override
  final String name;
}

enum Gender implements GenericEnum {
  male('Male', Icons.male_rounded),
  female('Female', Icons.female_rounded);

  const Gender(this.name, this.icon);

  @override
  final String name;
  final IconData icon;
}

enum PetOwner implements GenericEnum {
  dog('🐕 Dog'),
  cat('🐈 Cat'),
  reptile('🐍 Reptile'),
  amphibian('🐸 Amphibian'),
  bird('🦜 Bird'),
  fish('🐟 Fish'),
  dontLikePets('😩 Don’t like pets'),
  rabbits('🐇 Rabbits'),
  mouse('🐀 Mouse'),
  planningOnGetting('😉 Planning on getting'),
  allergic('🤮 Allergic'),
  other('🐎 Other'),
  wantAPet('🙃 Want a pet');

  const PetOwner(this.name);

  @override
  final String name;
}
