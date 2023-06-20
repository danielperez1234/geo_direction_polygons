import 'package:flutter/material.dart';
import 'package:geo_polygons_marks_google/styles.dart';
import 'package:geocoding/geocoding.dart';

class CustShowInfo extends StatelessWidget {
  CustShowInfo({Key? key, required this.place}) : super(key: key);
  Placemark place;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(place.name ?? ""),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (place.street != null && place.street != "")
            Row(
              children: [
                Text(
                  "Calle: ",
                  style:
                      TextStyle(color: kPrincipal, fontWeight: FontWeight.w700),
                ),
                Text(place.street ?? "")
              ],
            ),
          if (place.country != null && place.country != "")
            Row(
              children: [
                Text(
                  "Pais: ",
                  style:
                      TextStyle(color: kPrincipal, fontWeight: FontWeight.w700),
                ),
                Text(place.country ?? "")
              ],
            ),
          if (place.postalCode != null && place.postalCode != "")
            Row(
              children: [
                Text(
                  "Código postal: ",
                  style:
                      TextStyle(color: kPrincipal, fontWeight: FontWeight.w700),
                ),
                Text(place.postalCode ?? "")
              ],
            ),
          if (place.locality != null && place.locality != "")
            Row(
              children: [
                Text(
                  "Localidad: ",
                  style:
                      TextStyle(color: kPrincipal, fontWeight: FontWeight.w700),
                ),
                Text(place.locality ?? "")
              ],
            )
        ],
      ),
    );
  }
}
