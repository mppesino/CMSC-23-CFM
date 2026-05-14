import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:food_sharing/theme/app_theme.dart';

class PickLocationPage extends StatelessWidget {
  const PickLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.white,
      appBar: AppBar(title: Text("Pick Location", style: TextStyleTheme.titleXs), backgroundColor: BrandColors.white,),
      body: OpenStreetMapSearchAndPick(
        initialCenter: LatLong(14.1653, 121.2410),
        
        onPicked: (pickedData) {
          Navigator.pop(context, {
            "lat": round(pickedData.latLong.latitude,decimals:4),
            "lng": round(pickedData.latLong.longitude,decimals:4),
            "address": addressFormat(pickedData.address),
          });
        },
      ),
    );
  }

    String addressFormat(Map<String, dynamic> address) {
      final addressLines = [
        address['road'],
        address['quarter'],
        address['town'],
        address['state'],
      ];

      return addressLines
          .where((e) => e != null && e.toString().trim().isNotEmpty)
          .join(', ');
    }
}