import 'package:flutter/material.dart';
import 'package:geo_polygons_marks_google/styles.dart';
import 'package:geo_polygons_marks_google/widget/cust_show_info.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///Revisa si esta dentro de las sucursales
bool estaDentroDelPoligono(List<LatLng> sucursales, LatLng latlng) {
  var margin = .005;

  double minLat = sucursales
          .map((point) => point.latitude)
          .reduce((min, value) => value < min ? value : min) -
      margin;

  double maxLat = sucursales
          .map((point) => point.latitude)
          .reduce((max, value) => value > max ? value : max) +
      margin;

  double minLng = sucursales
          .map((point) => point.longitude)
          .reduce((min, value) => value < min ? value : min) -
      margin;

  double maxLng = sucursales
          .map((point) => point.longitude)
          .reduce((max, value) => value > max ? value : max) +
      margin;
  if (latlng.latitude >= minLat &&
      latlng.latitude <= maxLat &&
      latlng.longitude >= minLng &&
      latlng.longitude <= maxLng) {
    return true;
  }
  return false;
}

///CrearPoligono inicial a partir de las sucursales que se encontraron
Future<Polygon> addFirstPolygon(
    List<LatLng> sucursales, GoogleMapController controller) async {
  List<LatLng> poligonEdges() {
    var list =
        sucursales.map((e) => LatLng(e.latitude, (e.longitude))).toList();
    return list;
  }

  var margin = .005;
  double minLat = sucursales
          .map((point) => point.latitude)
          .reduce((min, value) => value < min ? value : min) -
      margin;

  double maxLat = sucursales
          .map((point) => point.latitude)
          .reduce((max, value) => value > max ? value : max) +
      margin;

  double minLng = sucursales
          .map((point) => point.longitude)
          .reduce((min, value) => value < min ? value : min) -
      margin;

  double maxLng = sucursales
          .map((point) => point.longitude)
          .reduce((max, value) => value > max ? value : max) +
      margin;
  print("${minLat} ${minLng}  ${maxLat}  ${maxLng} ");
  await Future.delayed(Duration(milliseconds: 1000));
  await controller.moveCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
          southwest: LatLng(minLat - margin, minLng - margin),
          northeast: LatLng(maxLat + margin, maxLng + margin)),
      margin));
  return Polygon(
      polygonId: PolygonId("Borders"),
      fillColor: kPrincipal.withOpacity(.25),
      strokeColor: kBlack.withOpacity(.45),
      strokeWidth: 2,
      points: [
        LatLng(minLat, minLng),
        LatLng(minLat, maxLng),
        LatLng(maxLat, maxLng),
        LatLng(maxLat, minLng),
      ]);
}

///Crear marcador sucursales
List<Marker> addSucursales(List<LatLng> sucursales) {
  List<Marker> list = [];
  sucursales.forEach((element) {
    list.add(Marker(
        markerId: MarkerId("sucursale${sucursales.indexOf(element)}"),
        position: element,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor
            .hueViolet) /*await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(30, 30)), "assets/ubicacion.png")*/
        ));
  });
  return list;
}

///Crea el marcador con id ingresado, solo se debe de usar cuando se agrega el marcador ingresado por el usuario
Marker createMarkerIngresado(
    BuildContext context, List<Placemark>? location, LatLng latlng) {
  return Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(
          title: location?.first.postalCode ?? "No Info",
          onTap: () async {
            print("hola");
            if (location != null) {
              await showDialog(
                  context: context,
                  builder: (_) => CustShowInfo(
                        place: location!.first,
                      ));
            }
          }),
      markerId: MarkerId("Mio"),
      position: latlng);
}
