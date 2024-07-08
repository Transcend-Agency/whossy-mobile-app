import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticationProvider extends ChangeNotifier {
  String tc = 'https://www.google.com/';

  void signApple() {}
  void signGoogle() {}
  void createNew() {}

  Future<void> launchTC() async {
    final Uri url = Uri.parse('mailto:$tc');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
