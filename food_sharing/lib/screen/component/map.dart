import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

class MapPicker extends StatelessWidget {
  const MapPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(14.1650, 121.2410), // UPLB
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(14.1650, 121.2410),
              width: 40,
              height: 40,
              child: Icon(Icons.location_pin, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}