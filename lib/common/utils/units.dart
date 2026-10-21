/// Distance preferences and displays are miles everywhere in the UI (both
/// onboarding and Preferences sliders say "mi") — miles is the one
/// storage/display unit (C3/C6 decision). Geo libraries (geoflutterfire2,
/// Geolocator) work in kilometres, so convert only at the point of
/// consumption, never store or display km.
const _kKmPerMile = 1.609344;

double milesToKm(double miles) => miles * _kKmPerMile;

double kmToMiles(double km) => km / _kKmPerMile;
