import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_openvpn/flutter_openvpn.dart';
import 'package:flutter_openvpn_example/newPage.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

Future<String> getFileData(String path) async {
  try {
    return await rootBundle.loadString(path);
  } catch (_) {
    return null;
  }
}

class MyApp extends StatefulWidget {
  static Future<void> initPlatformState() async {
    String fileData = await getFileData("assets/vpn.conf");

    int i = await FlutterOpenvpn.lunchVpn(
      fileData,
      (isProfileLoaded) {
        print('isProfileLoaded : $isProfileLoaded');
      },
      (vpnActivated) {
        print('vpnActivated : $vpnActivated');
      },
      user: 'SubUser-JVFUK5SEPV5UCTTT_67_234@HUB_MOD305',
      pass: 'MV3F22CIPBXEUYLVNRKVAYLUJZHWGQ25',
      onConnectionStatusChanged: (duration, lastPacketRecieve, byteIn, byteOut) =>
          print('BYEIN : $byteIn'),
      connectionId: "HUB_MOD305",
      connectionName: "cihantest",
      timeOut: Duration(seconds: 5),
      expireAt: DateTime.now().add(
        Duration(
          seconds: 180,
        ),
      ),
    );
    print("lunchVpn " + i.toString());
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => NewPAge(
              settings.name.contains(NewPAge.subPath)
                  ? settings.name.split(NewPAge.subPath)[1]
                  : '0',
              settings.name.split(NewPAge.subPath)[1].compareTo('2') < 0),
          settings: settings),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: NewPAge('0', true),
      ),
    );
  }
}
