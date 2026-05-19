import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:food_sharing/provider/users_provider.dart';


class FoodTags {
  static const List<String> dietaryTags = [
    'Vegan',
    'Vegetarian',
    'Halal',
    'Pescetarian',
    'Gluten-Free',
    'Dairy-Free',
  ];

  static const List<String> categoryTags = [
    'Canned / Packaged',
    'Raw Ingredients',
    'Grains',
    'Proteins & Dairy',
    'Beverage',
    'Snacks',
  ];
}


Uint8List base64ToImage(String base64String) {
  return base64Decode(base64String);
}

String imageToBase64(Uint8List bytes) {
  return base64Encode(bytes);
}

Future<Uint8List> compressImage(XFile file) async {
  final bytes = await file.readAsBytes();
  final image = img.decodeImage(bytes)!;

  final resized = img.copyResize(image, width: 300);

  return Uint8List.fromList(
    img.encodeJpg(resized, quality: 80),
  );
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2){ //using Haversine formula:
  const double p = pi/180;  //to radians
  const double r = 6371;    //earth's radius in km

  final double a = 0.5 - cos((lat2-lat1)*p)/2 + cos(lat1*p) * cos(lat2*p) * (1-cos((lon2-lon1)*p))/2;

  return r * 2 * asin(sqrt(a));  //return distance (km)
}

Future<void> updateUserLocation(BuildContext context) async{
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled) return;

  LocationPermission permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) return;
  }

  if(permission == LocationPermission.deniedForever) return;

  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  if(context.mounted){
    final usersProvider = context.read<UsersProvider>();
    final uid = usersProvider.currentUser?.userId;
    if(uid != null){
      await usersProvider.editUser(uid, {
        'lat':position.latitude,
        'lng':position.longitude,
      });
    }
  }
}

