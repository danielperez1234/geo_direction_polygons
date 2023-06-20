import 'package:flutter/material.dart';
import 'package:geo_polygons_marks_google/styles.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_distance_matrix/google_distance_matrix.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as plp;

class RutaController {
  RutaController(
      {required this.controller,
      required this.initialPosition,
      required this.sucursales}) {
    _sucursalesRestantes.addAll(sucursales);
  }
  GoogleMapController controller;
  List<LatLng> sucursales;
  List<LatLng> _sucursalesRestantes = [];
  LatLng initialPosition;
  double _duration = 0;
  List<LatLng> _point = [];
  Future<LatLng> _calcMasCercanas(LatLng inicial) async {
    var distanceMatrix = GoogleDistanceMatrix();
    print("SUCURSALES LENGHT:${sucursales.length}");
    List<DistanceMatrixModel> resp = [];
    await Future.forEach(_sucursalesRestantes, (e) async {
      resp.add(await distanceMatrix.getDistanceMatrix(
          "AIzaSyA1teKX_ZHoJRmJZRJdof-fF3uNrQM-u50",
          origin: Coordinate(
              latitude: inicial.latitude.toString(),
              longitude: inicial.longitude.toString()),
          destination: Coordinate(
              latitude: e.latitude.toString(),
              longitude: e.longitude.toString())));
    });
    List<DistanceMatrixModel> sortedresp = [];
    sortedresp.addAll(resp);
    sortedresp.sort((a, b) => a.rows.first.elements.first.duration.value
        .compareTo(b.rows.first.elements.first.duration.value));
    print('\nNormales');
    resp.forEach((e) {
      print(e.rows.first.elements.first.duration.value);
    });
    print('\nSortded');
    sortedresp.forEach((e) {
      print(e.rows.first.elements.first.duration.value);
    });
    //_duration += sortedresp.first.rows.first.elements.first.duration.value;
    var newInitial = _sucursalesRestantes[resp.indexOf(sortedresp.first)];
    _sucursalesRestantes.removeAt(resp.indexOf(sortedresp.first));
    return newInitial;
  }

  Future<Map<String, dynamic>> calcRutaCompleta() async {
    var newinitial = await _calcMasCercanas(initialPosition);
    //print("duracion ${_duration}\n\n");
    await _addRuta(initialPosition, newinitial);

    var auxExinit = newinitial;
    newinitial = await _calcMasCercanas(newinitial);
    await _addRuta(auxExinit, newinitial);
    auxExinit = newinitial;
    //print("duracion ${_duration}\n\n");
    newinitial = await _calcMasCercanas(newinitial);
    await _addRuta(auxExinit, newinitial);
    //regreso
    await _addRuta(newinitial, initialPosition);
    _createRoutePolygon();
    _duration = (_duration / 60) + 90;
    //print("duracion ${_duration}\n\n");
    return {"polygon": _createRoutePolygon(), "duration": _duration};
  }

  Future<void> _addRuta(LatLng origin, LatLng destination) async {
    final request = DirectionsRequest(
        origin: GeoCoord(origin.latitude, origin.longitude),
        destination: GeoCoord(destination.latitude, destination.longitude),
        travelMode: TravelMode.driving,
        optimizeWaypoints: false);
    DirectionsService.init('AIzaSyA1teKX_ZHoJRmJZRJdof-fF3uNrQM-u50');
    final DirectionsService directionsService = DirectionsService();
    await directionsService.route(request, (routeResult, status) {
      if (status == DirectionsStatus.ok) {
        _duration +=
            routeResult.routes!.first.legs!.first.duration!.value!.floor();
        var pointsFirst = plp.PolylinePoints().decodePolyline(
            routeResult.routes!.first.overviewPolyline!.points!);
        print(routeResult.routes![0].legs!.first.duration?.value);
        _point.addAll(
            pointsFirst.map((e) => LatLng(e.latitude, e.longitude)).toList());
      } else {
        print(routeResult.errorMessage);
      }
    });
  }

  _createRoutePolygon() {
    return Polygon(
        geodesic: false,
        fillColor: Colors.transparent,
        strokeColor: kPrincipal,
        polygonId: PolygonId('route'),
        points: _point..addAll((_point.reversed.toList())));
  }
}
