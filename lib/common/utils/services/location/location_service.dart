import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';

import '../../utils.dart';

class LocationService {
  final _firestore = FirebaseFirestore.instance;
  final _geo = GeoFlutterFire();

  // Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Determine current position with proper error handling
  static Future<Position?> determinePosition(bool prevDenied) async {
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServicesNotEnabledException();
    }

    LocationPermission permission = await Geolocator.checkPermission();

    // If permission is denied and it hasn't been denied previously, ask for permission
    if (permission == LocationPermission.denied && !prevDenied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException();
      }
      if (permission == LocationPermission.deniedForever) {
        throw LocationPermissionDeniedForeverException();
      }
    }

    // If permission is denied forever, throw the appropriate exception
    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionDeniedForeverException();
    }

    // If permission is granted (whileInUse or always), fetch the location
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        return await Geolocator.getCurrentPosition();
      } catch (e) {
        throw LocationFetchFailedException(e.toString());
      }
    }

    if (prevDenied) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      throw LocationFetchFailedException(e.toString());
    }
  }

  // Method to update user location in Firestore
  Future<void> updateUserLocation(Position position) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      // Generate GeoFirePoint
      final geoPoint = _geo.point(
          latitude: position.latitude, longitude: position.longitude);

      // Extract latitude, longitude, and geohash
      final double lat = geoPoint.latitude;
      final double lon = geoPoint.longitude;
      final String geohash = geoPoint.hash;

      await _firestore.collection('users').doc(userId).update({
        'location': geoPoint.geoPoint,
        'latitude': lat,
        'longitude': lon,
        'geohash': geohash,
        'geography': geoPoint.data,
      });
    } catch (e) {
      throw LocationServiceException('Error updating location');
    }
  }
}
