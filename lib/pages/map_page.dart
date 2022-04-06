import 'dart:async';

import 'package:flutter/material.dart';

import '../models/scan_model.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const zoom = 18.0;
  static const tilt = 35.0;

  final Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context)!.settings.arguments as ScanModel;

    final CameraPosition puntoInicial = CameraPosition(target: scan.getLatLng(), zoom: zoom, tilt: tilt);
    //Marcadores

    Set<Marker> markers = <Marker>{};
    markers.add(Marker(markerId: const MarkerId('geo-location'), position: scan.getLatLng()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            onPressed: () => _sendToCenter(scan.getLatLng()),
            icon: const Icon(Icons.location_pin),
          )
        ],
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: false,
        mapType: mapType,
        markers: markers,
        initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          setState(() {
            switch (mapType) {
              case MapType.normal:
                mapType = MapType.hybrid;
                break;
              case MapType.hybrid:
                mapType = MapType.satellite;
                break;
              case MapType.satellite:
                mapType = MapType.terrain;
                break;
              case MapType.terrain:
                mapType = MapType.normal;
                break;
              default:
            }
          })
        },
        child: const Icon(Icons.layers),
      ),
    );
  }

  _sendToCenter(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: zoom, tilt: tilt)));
  }

  
}
