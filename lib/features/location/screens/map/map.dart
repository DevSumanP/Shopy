import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'widgets/get_route.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationData _currentLocation;
  late RouteService routeService;
  List<LatLng> routePoints = [];
  LatLng startLatLng = const LatLng(0, 0);
  LatLng endLatLng = const LatLng(27.68406509350434, 85.33149379463046);
  late Timer _timer;
  int counter = 0;
  double moveStep =
      0.0001; // Amount by which the start point moves towards the endpoint

  Polyline routePolyline = Polyline(
    points: [],
    strokeWidth: 4.0,
    color: Colors.blue,
  );

  @override
  void initState() {
    super.initState();
    _getLocation();
    routeService = RouteService(
      apiKey:
          '5b3ce3597851110001cf624891825d43991842028d9eaa99c6e6a060', // Replace with secure method for API key
    );
    _initializeBackgroundService();
  }

  // Initialize background service to move start point
  Future<void> _initializeBackgroundService() async {
    await FlutterBackground.initialize();

    bool success = await FlutterBackground.enableBackgroundExecution();
    if (success) {
      // Start the background task
      _startBackgroundTask();
    } else {
      print("Background service initialization failed.");
    }
  }

  // Background task to move start point every 5 seconds
  void _startBackgroundTask() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _moveStartPoint();
    });
  }

  Future<void> _getLocation() async {
    Location location = Location();

    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      // Fetch new location
      _currentLocation = await location.getLocation();

      // Set the initial start and end points
      setState(() {
        startLatLng =
            LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
        endLatLng = LatLng(startLatLng.latitude, startLatLng.longitude);
      });

      fetchRoute();
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  Future<void> fetchRoute() async {
    try {
      final points = await routeService.getRoute(
        startLat: startLatLng.latitude,
        startLng: startLatLng.longitude,
        endLat: endLatLng.latitude,
        endLng: endLatLng.longitude,
      );

      setState(() {
        routePoints = points;
        routePolyline = Polyline(
          points: routePoints,
          strokeWidth: 4.0,
          color: Colors.blue,
        );
      });
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  // Function to move the start point towards the endpoint
  void _moveStartPoint() {
    setState(() {
      // Move start point closer to the end point
      double newLat = startLatLng.latitude + moveStep;
      double newLng = startLatLng.longitude + moveStep;
      startLatLng = LatLng(newLat, newLng);

      // If the start point reaches or exceeds the endpoint, stop the task
      if (_calculateDistance(startLatLng.latitude, startLatLng.longitude,
              endLatLng.latitude, endLatLng.longitude) <
          10) {
        _timer.cancel();
      }

      fetchRoute();
    });
  }

  double _calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    var start = LatLng(startLat, startLng);
    var end = LatLng(endLat, endLng);
    return const Distance()
        .as(LengthUnit.Meter, start, end); // Calculate distance in meters
  }

  @override
  void dispose() {
    // Stop the background service when the widget is disposed
    _timer.cancel();
    FlutterBackground.disableBackgroundExecution();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenStreetMap Route'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: startLatLng,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.maptiler.com/maps/basic/{z}/{x}/{y}.png?key=axAFiEEQK9OTJRHm8Jet',
            additionalOptions: const {
              'apiKey': 'axAFiEEQK9OTJRHm8Jet',
            },
          ),
          PolylineLayer(
            polylines: [routePolyline],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: startLatLng,
                child: FluttermojiCircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 100,
                ),
              ),
              Marker(
                point: endLatLng,
                child: FluttermojiCircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
