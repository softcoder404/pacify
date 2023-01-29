import 'package:flutter/material.dart';
import 'package:placify/core/config.dart';
import 'package:placify/core/model/place_prediction_model.dart';

class Helpers {
  static String getPhotoUrlFromPlacePhoto(PlacePhoto photo) {
    String photoReference = photo.reference!;
    num height = photo.height!;
    num width = photo.width!;
    return "${AppKeys.googlePhotoBaseUrl}?photo_reference=$photoReference&key=${AppKeys.apiKey}&maxheight=$height&maxwidth=$width";
  }

  static Color getColorFromHexString(String hexColor) {
    // remove the '#' character from the hex code string
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
