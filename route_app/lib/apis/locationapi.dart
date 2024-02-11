import 'package:geolocator/geolocator.dart';

Future<bool> handleLocationPermission() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    return false;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission =
        await Geolocator.requestPermission(); // * Requesting location service

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
  }
  return true;
}
