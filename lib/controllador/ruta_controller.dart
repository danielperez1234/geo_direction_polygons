import 'package:google_distance_matrix/google_distance_matrix.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  int _duration = 0;
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
    _duration += sortedresp.first.rows.first.elements.first.duration.value;
    var newInitial = _sucursalesRestantes[resp.indexOf(sortedresp.first)];
    _sucursalesRestantes.removeAt(resp.indexOf(sortedresp.first));
    return newInitial;
  }

  calcRutaCompleta() async {
    var newinitial = await _calcMasCercanas(initialPosition);
    print("duracion ${_duration}\n\n");
    newinitial = await _calcMasCercanas(newinitial);
    print("duracion ${_duration}\n\n");
    newinitial = await _calcMasCercanas(newinitial);
    print("duracion ${_duration}\n\n");
  }
}
