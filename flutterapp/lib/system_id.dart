
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

Future<String?> getId() async {

  try {
    if (Platform.isAndroid) {
      //final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
      //var build = await deviceInfoPlugin.androidInfo;
      //return build.fingerprint;
      const androidIdPlugin = AndroidId();
      try {
        return await androidIdPlugin.getId();
      } on MissingPluginException {
        print('Failed to get Android ID: MissingPluginException');
        return null;
      } on PlatformException catch (e) {
        print('Failed to get Android ID: ${e.message}');
        return null;
      }
    } else if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
      var build = await deviceInfoPlugin.iosInfo;
      return build.identifierForVendor;
    }else if(Platform.isMacOS){
      final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
      var build = await deviceInfoPlugin.macOsInfo;
      return build.systemGUID;
    }
  } on PlatformException {
    print('Failed to get platform version');
  }

  return "";
}