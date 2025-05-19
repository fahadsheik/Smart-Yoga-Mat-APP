import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoUtils {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final Position position = await _getCurrentPosition();
    final DateTime now = DateTime.now();

    String deviceType = 'android';
    String deviceId = '';
    String deviceName = '';
    String deviceOSVersion = '';

    try {
      if (kIsWeb) {
        deviceType = 'web';
        final webInfo = await deviceInfoPlugin.webBrowserInfo;
        deviceId = webInfo.appName.replaceAll(' ', '') + DateTime.now().millisecondsSinceEpoch.toString();
        deviceName = webInfo.browserName.toString() + '-' + webInfo.platform.toString();
        deviceOSVersion = webInfo.appVersion.toString();
      } else if (Platform.isAndroid) {
        deviceType = 'android';
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id;
        deviceName = '${androidInfo.manufacturer}-${androidInfo.model}';
        deviceOSVersion = androidInfo.version.release;
      } else if (Platform.isIOS) {
        deviceType = 'ios';
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
        deviceName = iosInfo.name ?? '';
        deviceOSVersion = iosInfo.systemVersion ?? '';
      }
    } catch (e) {
      deviceId = 'unknown-${DateTime.now().millisecondsSinceEpoch}';
      deviceName = 'Unknown Device';
      deviceOSVersion = 'Unknown';
    }

    return {
      "deviceType": deviceType,
      "deviceId": deviceId,
      "deviceName": deviceName,
      "deviceOSVersion": deviceOSVersion,
      "deviceIPAddress": await _getIPAddress(),
      "lat": position.latitude,
      "long": position.longitude,
      "buyer_gcmid": "",
      "buyer_pemid": "",
      "app": {
        "version": packageInfo.version,
        "installTimeStamp": now.toIso8601String(),
        "uninstallTimeStamp": now.toIso8601String(),
        "downloadTimeStamp": now.toIso8601String()
      }
    };
  }

  static Future<String> _getIPAddress() async {
    try {
      final List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );
      
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          return addr.address;
        }
      }
      return '0.0.0.0';
    } catch (e) {
      return '0.0.0.0';
    }
  }

  static Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Position(
          longitude: 0,
          latitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Position(
            longitude: 0,
            latitude: 0,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return Position(
          longitude: 0,
          latitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
  }
}