import 'dart:convert';

import 'package:fl_geocoder/fl_geocoder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  getApi();
}

Future<List<Marker>> getApi() async {
  Map<String, dynamic> _header = {};
  final resp = await http
      .get(Uri.parse("http://192.168.0.10:4000/api/sucursales/findall"));
  switch (resp.statusCode) {
    case 200:
      {
        dev.log("----------RESPONSE OK");

        return json.decode(resp.body).map<Marker>((e) {
          final geo = e["geometry"];
          final props = e["properties"];
          return Marker(
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet),
              markerId: MarkerId(e["id"]),
              position: LatLng(double.tryParse(geo["coordinates"][0]) ?? 0,
                  double.tryParse(geo["coordinates"][1]) ?? 0),
              infoWindow: InfoWindow(title: props["name"]));
        }).toList();
      }
  }
  return [];
}
