import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

class MapUtils {
  static Future<void> openMap(LatLng location,
      {String? destinationName}) async {
    final query = Uri.encodeComponent(
        destinationName ?? '${location.latitude},${location.longitude}');
    final googleUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    try {
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch maps';
      }
    } on PlatformException catch (e) {
      throw 'Failed to open maps: ${e.message}';
    }
  }
}
