import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  // Coordenadas de Santiago, Chile
  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-33.4489, -70.6693),
    zoom: 14.4746,
  );

  // Lista de marcadores para las cafeterías
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Agregamos cafeterías de ejemplo
    _markers.add(
      Marker(
        markerId: MarkerId('We Are Four Pedro De Valdivia'),
        position: LatLng(-33.424194, -70.612295),
        infoWindow: InfoWindow(title: 'We Are Four',),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('The Elephant Coffee'),
        position: LatLng(-33.41865456282185, -70.5995433066291),
        infoWindow: InfoWindow(title: 'The Elephant Coffee',),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('R3 Coffee'),
        position: LatLng(-33.4362875, -70.6457344),
        infoWindow: InfoWindow(title: 'R3 Coffee',),
      ),
    );

    // Puedes agregar más cafeterías de la misma manera
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cafeterías de Especialidad'),
      ),
      body: GoogleMap(
        markers: _markers,  // Asignamos los marcadores al mapa
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
        },
      ),
    );
  }
}
