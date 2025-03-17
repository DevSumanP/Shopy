import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Initialize connectivity status asynchronously
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result =
          await _connectivity.checkConnectivity(); // Fetch connectivity status
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status: $e');
      return;
    }

    return _updateConnectionStatus(result); // Update the connection status
  }

  // Update connectivity status
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    update();
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  Future<bool> isConnected() async {
    try {
      final result = _connectionStatus;
      if (result.contains(ConnectivityResult.none)) {
        return false;
      } else {
        return true;
      }
    } catch (_) {
      return false;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
