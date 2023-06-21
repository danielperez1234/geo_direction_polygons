import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geo_polygons_marks_google/controllador/map_functions.dart';
import 'package:geo_polygons_marks_google/controllador/ruta_controller.dart';
import 'package:geo_polygons_marks_google/controllador/sucursales_controller.dart';
import 'package:geo_polygons_marks_google/styles.dart';
import 'package:geo_polygons_marks_google/widget/cust_button.dart';
import 'package:geo_polygons_marks_google/widget/cust_form.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
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

  static final LatLng _kMapCenter = LatLng(0, 0);
  Widget? mySheet;
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  late GoogleMapController _mapController;

  Set<Marker> _markers = {};

  Set<Marker> _setMarkers() {
    print("hola0");
    _markers.forEach((element) {
      print(element.mapsId.value);
    });

    return _markers;
  }

  var sucursales = <LatLng>[];

  Set<Polygon> _polygons = {};

  _setPolygons() {
    return _polygons;
  }

  Future<void> _SetMarkers() async {
    final resList = await getApi();
    resList.forEach((element) {
      sucursales
          .add(LatLng(element.position.latitude, element.position.longitude));
    });
    _markers.addAll(resList);
  }

  Future<String> _dialogAddLongLat() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          final controller =
              TextEditingController(text: "21.157602,-101.6977828");
          final _formKey = GlobalKey<FormState>();

          return AlertDialog(
            title: Text("Ingresa una Ubicación"),
            content: CustForm(formKey: _formKey, controller: controller),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              CustButton(
                text: "Agregar",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var latlng = LatLng(
                        double.tryParse(controller.text.split(',')[0]) ?? 0.0,
                        double.tryParse(controller.text.split(',')[1]) ?? 0.0);
                    controller.text = "";

                    if (!estaDentroDelPoligono(sucursales, latlng)) {
                      controller.text = "Fuera de rango";
                      return;
                    }
                    List<Placemark>? location;
                    try {
                      var pruebaRuta = RutaController(
                          controller: _mapController,
                          initialPosition: latlng,
                          sucursales: sucursales);
                      _polygons.removeWhere(
                          (element) => element.mapsId.value == "route");
                      var resrute = (await pruebaRuta.calcRutaCompleta());
                      _polygons.add(resrute["polygon"]);
                      mySheet = Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25))),
                        child: Center(
                          child: Text(
                            "Tiempo de viaje ${resrute["duration"].toString()} min.",
                            style: TextStyle(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } catch (ex) {}
                    _markers.removeWhere(
                        (element) => element.mapsId.value == "Mio");
                    _markers.add(await createMarkerIngresado(context, latlng));

                    Navigator.pop(context);

                    showModalBottomSheet(
                        context: context, builder: (builder) => mySheet!);
                    setState(() {});
                  } else {}
                },
              )
            ],
          );
        });
    return "";
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    _setMarkers.call();
    _setPolygons.call();
    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Guruglu Matz",
        style: TextStyle(fontWeight: FontWeight.w700, color: kWhite),
      )),
      body: Center(
        child: GoogleMap(
          onMapCreated: (ctrl) async {
            _mapController = ctrl;
            _markers.clear();
            await _SetMarkers();
            _polygons.add(await addFirstPolygon(sucursales, _mapController));
            setState(() {});
          },
          markers: _setMarkers(),
          polygons: _setPolygons(),
          rotateGesturesEnabled: false,
          initialCameraPosition: _kInitialPosition,
        ),
      ),
      bottomNavigationBar: mySheet != null
          ? GestureDetector(
              onVerticalDragEnd: (x) {
                showModalBottomSheet(
                    context: context, builder: (builder) => mySheet!);
              },
              child: Container(
                color: Colors.white,
                height: 20,
                child: Center(
                    child: Text(
                  "=",
                  style: TextStyle(color: Colors.grey),
                )),
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrincipal,
        onPressed: _dialogAddLongLat,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
