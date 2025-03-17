import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:flutter/material.dart';

class RouteService {
  final OpenRouteService _client;

  RouteService({required String apiKey})
      : _client = OpenRouteService(apiKey: apiKey);

  Future<List<LatLng>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      final List<ORSCoordinate> routeCoordinates =
          await _client.directionsRouteCoordsGet(
        startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng),
        endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
      );

      // Convert ORSCoordinate to LatLng
      return routeCoordinates
          .map(
              (coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch route: $e');
    }
  }

  Polyline createRoutePolyline(List<LatLng> routePoints) {
    return Polyline(
      points: routePoints,
      color: Colors.red,
      strokeWidth: 4.0,
    );
  }
}
