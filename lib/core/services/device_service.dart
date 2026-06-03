import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeviceService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<Map<String, dynamic>> getDeviceInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String appVersion = packageInfo.version;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      return {
        'deviceInfo': {
          'os': 'android',
          'osVersion': androidInfo.version.release,
          'brand': androidInfo.brand,
          'model': androidInfo.model,
          'appVersion': appVersion,
        }
      };
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      return {
        'deviceInfo': {
          'os': 'ios',
          'osVersion': iosInfo.systemVersion,
          'brand': 'Apple',
          'model': iosInfo.utsname.machine,
          'appVersion': appVersion,
        }
      };
    }
    return {};
  }
}
