import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/utils/index.dart';

class SignUpProvider extends ChangeNotifier {
  String tc = 'https://www.google.com/';

  Future<void> launchTC() async {
    final Uri url = Uri.parse('mailto:$tc');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  String? _email;
  String? _password;
  String? _firstName;
  String? _lastName;
  String? _phone;
  String? _country;
  Gender? _gender;

  void setEmailAndPassword(String email, String password) {
    _email = email;
    _password = password;
  }

  void setName(String first, String last) {
    _firstName = first;
    _lastName = last;
  }

  void setPhoneAndCountry(String phone, String country) {
    _phone = phone;
    _country = country;
  }

  void setGender(Gender gender) {
    _gender = gender;
  }

  bool _createSpinner = false;

  bool get spinnerState => _createSpinner;

  set spinnerState(bool value) {
    _createSpinner = value;
    notifyListeners();
  }

  Future<void> checkEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
  }) async {
    try {
      spinnerState = true;

      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: email)
          .get(const GetOptions(source: Source.server));

      if (query.docs.isNotEmpty) {
        log('An account already exists for that email.');
      } else {
        setEmailAndPassword(email, password);

        onAuthenticate();
      }
    } on FirebaseException catch (e) {
      if (e.code == 'network-request-failed') {
        showSnackbar('Poor internet connection');
      } else {
        showSnackbar('Oops, an error occurred');
      }
    } catch (e) {
      // Handle exceptions
      showSnackbar('An error occurred while checking email and password.'
          ' Please try again later.');

      log(e.toString());
    } finally {
      spinnerState = false;
    }
  }

  Future<Map<String, dynamic>> isPhoneUnique(String phone) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('users')
          .where('phone_number', isEqualTo: phone)
          .get(const GetOptions(source: Source.server));

      bool isEmpty = result.docs.isEmpty;

      return {
        'isEmpty': isEmpty,
      };
    } on FirebaseException catch (e) {
      const message = 'Unable to check, device offline';

      log('Error checking if phone number is unique, '
          'A Firebase Exception occurred ${e.toString()}');

      return {
        'message': message,
      };
    } catch (e) {
      log('Error checking for unique phone number ${e.toString()}');
    }
    return {
      'message': 'Oops, an unknown error occurred',
    };
  }
}
