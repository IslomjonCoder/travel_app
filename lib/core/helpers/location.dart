import 'package:geobase/geobase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper {
  static LatLng convertWkb(String locationHEX) {
    final pointFromWKB = Point.decodeHex(locationHEX);
    return LatLng(pointFromWKB.position.x,pointFromWKB.position.y);
  }
}
