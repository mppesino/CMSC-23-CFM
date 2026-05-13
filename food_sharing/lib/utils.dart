import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';


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
    img.encodeJpg(resized, quality: 60),
  );
}
