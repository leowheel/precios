import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'simple_connectivity_service.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static StreamController<bool>? _connectivityController;
  static bool _isOnline = true; // Default to true to prevent blocking
  static bool _isInitialized = false;
  static bool _useSimpleService = false;

  static bool get isOnline =>
      _useSimpleService ? SimpleConnectivityService.isOnline : _isOnline;

  static Stream<bool> get connectivityStream {
    _connectivityController ??= StreamController<bool>.broadcast();
    return _connectivityController!.stream;
  }

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Check initial connectivity
      final connectivityResults = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(connectivityResults);

      // Listen for changes
      _connectivity.onConnectivityChanged.listen(
        (results) {
          _updateConnectivityStatus(results);
        },
        onError: (error) {
          debugPrint('Connectivity listener error: $error');
          // Assume online if we can't detect connectivity
          _isOnline = true;
          _connectivityController?.add(_isOnline);
        },
      );

      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize connectivity_plus: $e');
      debugPrint('Falling back to simple connectivity service');

      // Fallback to simple connectivity service
      try {
        await SimpleConnectivityService.initialize();
        _useSimpleService = true;

        // Forward simple service stream to our stream
        SimpleConnectivityService.connectivityStream.listen((isOnline) {
          _connectivityController?.add(isOnline);
        });

        _isInitialized = true;
      } catch (e) {
        debugPrint('Failed to initialize simple connectivity service: $e');
        // Default to online if all fails
        _isOnline = true;
        _connectivityController?.add(_isOnline);
        _isInitialized = true;
      }
    }
  }

  static void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline = results.any((result) => result != ConnectivityResult.none);

    if (wasOnline != _isOnline) {
      _connectivityController?.add(_isOnline);
    }
  }

  static Future<bool> hasInternetConnection() async {
    if (_useSimpleService) {
      return await SimpleConnectivityService.hasInternetConnection();
    }

    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      return connectivityResults.any(
        (result) => result != ConnectivityResult.none,
      );
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      // Try simple service as fallback
      return await SimpleConnectivityService.hasInternetConnection();
    }
  }

  static void dispose() {
    _connectivityController?.close();
    _connectivityController = null;
    _isInitialized = false;
    if (_useSimpleService) {
      SimpleConnectivityService.dispose();
    }
  }
}
