import 'dart:convert';

import 'package:fl_geocoder/fl_geocoder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
}

Future<Result> getPlace(Location location) async {
  final geocoder = FlGeocoder('AIzaSyA1teKX_ZHoJRmJZRJdof-fF3uNrQM-u50');
  final coordinates = Location(40.714224, -73.961452);
  final coordinates2 = Location(21.157602, -101.6977828);
  final results = await geocoder.findAddressesFromLocationCoordinates(
    location: location,
    // resultType: 'route', // Optional. For custom filtering.
  );
  return results.first;
}
