import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_polygons_marks_google/controllador/places_controller.dart';
import 'package:geo_polygons_marks_google/styles.dart';
import 'package:geo_polygons_marks_google/widget/cust_show_info.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fl_geocoder/fl_geocoder.dart' as flGeo;

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
///YA NO SE USA----------------------------------------
Future<List<Marker>> addSucursales(List<LatLng> sucursales) async {
  List<Marker> list = [];
  var img = await rootBundle.load("assets/ubicacion.png");
  var fimg = img.buffer.asUint8List();
  sucursales.map((element) {
    list.add(Marker(
        markerId: MarkerId("sucursale${sucursales.indexOf(element)}"),
        position: element,
        icon: BitmapDescriptor.fromBytes(fimg,
            size: Size(25,
                25)) /*BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor
            .hueViolet) */ /*await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(30, 30)), "assets/ubicacion.png")*/
        ));
  });
  return list;
}

///Crea el marcador con id ingresado, solo se debe de usar cuando se agrega el marcador ingresado por el usuario
Future<Marker> createMarkerIngresado(
    BuildContext context, LatLng latlng) async {
  final locationGeocode =
      await getPlace(flGeo.Location(latlng.latitude, latlng.longitude));
  return Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(
          title: locationGeocode.formattedAddress ?? "No Info",
          onTap: () async {
            print("hola");
            if (locationGeocode != null) {
              await showDialog(
                  context: context,
                  builder: (_) => CustShowInfo(
                        place: locationGeocode,
                      ));
            }
          }),
      markerId: MarkerId("Mio"),
      position: latlng);
}
