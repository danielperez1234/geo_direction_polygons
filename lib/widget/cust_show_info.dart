import 'package:fl_geocoder/fl_geocoder.dart';
import 'package:flutter/material.dart';
import 'package:geo_polygons_marks_google/styles.dart';

class CustShowInfo extends StatelessWidget {
  CustShowInfo({Key? key, required this.place}) : super(key: key);
  Result place;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(place.formattedAddress ?? ""),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (place.formattedStreet != null && place.formattedStreet != "")
            Row(
              children: [
                Text(
                  "Calle: ",
                  style:
                      TextStyle(color: kPrincipal, fontWeight: FontWeight.w700),
                ),
                Text(place.formattedStreet ?? "")
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
                Text(place.country?.longName ?? "")
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
                Text(place.postalCode?.longName ?? "")
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
                Text(place.locality?.longName ?? "")
              ],
            )
        ],
      ),
    );
  }
}
