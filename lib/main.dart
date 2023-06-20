import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as plp;
import 'package:geo_polygons_marks_google/controllador/map_functions.dart';
import 'package:geo_polygons_marks_google/controllador/ruta_controller.dart';
import 'package:geo_polygons_marks_google/styles.dart';
import 'package:geo_polygons_marks_google/widget/cust_button.dart';
import 'package:geo_polygons_marks_google/widget/cust_form.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  DirectionsService.init('AIzaSyA1teKX_ZHoJRmJZRJdof-fF3uNrQM-u50');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IndexPage(),
    );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({
    super.key,
  });

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // Funcion para desplegar dialogo de ingreso de datos

  static final LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  late GoogleMapController _mapController;
  Future<String> _dialogAddLongLat() async {
    await showDialog(
        context: context,
        builder: (_) {
          final controller =
              TextEditingController(text: "21.157602,-101.6977828,16.22");
          final _formKey = GlobalKey<FormState>();
          return AlertDialog(
            title: Text("Ingresa una Ubicación"),
            content: CustForm(formKey: _formKey, controller: controller),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              CustButton(
                text: "Agregar",
                onPressed: () async {
                  print(DirectionsService.apiKey);
                  directionsService.route(request, (p0, p1) {
                    if (p1 == DirectionsStatus.ok) {
                      var pointsFirst = plp.PolylinePoints().decodePolyline(
                          p0.routes!.first.overviewPolyline!.points!);
                      print(p0.routes![0].legs!.first.duration?.value);
                      var point = pointsFirst
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList();
                      _polygons.add(Polygon(
                          geodesic: false,
                          fillColor: Colors.transparent,
                          strokeColor: kPrincipal,
                          polygonId: PolygonId('route'),
                          points: point..addAll((point.reversed.toList()))));
                      setState(() {});
                    } else {
                      print(p0.errorMessage);
                      print("hola ${p1} ");
                    }
                  });
                  if (_formKey.currentState!.validate()) {
                    var latlng = LatLng(
                        double.tryParse(controller.text.split(',')[0]) ?? 0.0,
                        double.tryParse(controller.text.split(',')[1]) ?? 0.0);
                    List<Placemark>? location;
                    try {
                      var pruebaRuta = RutaController(
                          controller: _mapController,
                          initialPosition: latlng,
                          sucursales: sucursales);
                      pruebaRuta.calcRutaCompleta();
                      location = await placemarkFromCoordinates(
                          latlng.latitude, latlng.longitude);
                    } catch (ex) {}
                    _markers
                        .add(createMarkerIngresado(context, location, latlng));

                    await _mapController
                        .animateCamera(CameraUpdate.newLatLng(latlng));
                    Navigator.pop(context);
                    setState(() {});
                  } else {}
                },
              )
            ],
          );
        });
    return "";
  }

  final DirectionsService directionsService = DirectionsService();
  final request = DirectionsRequest(
      origin: GeoCoord(21.154267, -101.6499131),
      destination: GeoCoord(21.1578043, -101.7054954),
      travelMode: TravelMode.driving,
      optimizeWaypoints: false);

  Set<Marker> _markers = {};

  Set<Marker> _setMarkers() {
    return _markers;
  }

  var sucursales = [
    LatLng(21.1351879, -101.7045612),
    LatLng(21.1560366, -101.689841),
    LatLng(21.1549216, -101.6854447),
    LatLng(21.1494391, -101.6823523),
    LatLng(21.1513765, -101.6721473)
  ];

  Set<Polygon> _polygons = {};

  Set<Polygon> _setPolygons() {
    return _polygons;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GoogleMap(
          onMapCreated: (ctrl) async {
            _mapController = ctrl;
            _markers.addAll(addSucursales(sucursales));
            _polygons.add(await addFirstPolygon(sucursales, _mapController));
            setState(() {});
          },
          markers: _setMarkers(),
          polygons: _setPolygons(),
          rotateGesturesEnabled: false,
          initialCameraPosition: _kInitialPosition,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrincipal,
        onPressed: _dialogAddLongLat,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
