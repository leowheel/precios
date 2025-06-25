import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Simple connectivity service as fallback if connectivity_plus fails
class SimpleConnectivityService {
  static StreamController<bool>? _connectivityController;
  static bool _isOnline = true;
  static Timer? _connectivityTimer;

  static bool get isOnline => _isOnline;

  static Stream<bool> get connectivityStream {
    _connectivityController ??= StreamController<bool>.broadcast();
    return _connectivityController!.stream;
  }

  static Future<void> initialize() async {
    // Start periodic connectivity checks
    _connectivityTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _checkConnectivity(),
    );
    
    // Initial check
    await _checkConnectivity();
  }

  static Future<void> _checkConnectivity() async {
    final wasOnline = _isOnline;
    _isOnline = await hasInternetConnection();
    
    if (wasOnline != _isOnline) {
      _connectivityController?.add(_isOnline);
      debugPrint('Connectivity changed: ${_isOnline ? "Online" : "Offline"}');
    }
  }

  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      debugPrint('Internet check failed: $e');
      return false;
    }
  }

  static void dispose() {
    _connectivityTimer?.cancel();
    _connectivityController?.close();
    _connectivityController = null;
  }
}