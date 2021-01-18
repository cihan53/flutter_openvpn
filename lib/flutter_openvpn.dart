import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

typedef OnConnectionStatusChanged = Function(
    String duration, String lastPacketRecieve, String byteIn, String byteOut);

/// Track vpn profile status.
typedef OnProfileStatusChanged = Function(bool isProfileLoaded);

/// Track Vpn status.
///
/// Status strings are but not limited to:
/// "CONNECTING", "CONNECTED", "DISCONNECTING", "DISCONNECTED", "TIMEOUT", "EXPIRED", "INVALID", "REASSERING", "AUTH", ...
/// print status to get full insight.
/// status might change depending on platform.
typedef OnVPNStatusChanged = Function(String status);

const String _profile = "profile";
const String _connectionUpdate = 'connectionUpdate';
const String _vpnStatus = 'vpnStatus';
const String _vpnStatusGroup = "vpnStatusGroup";
const String _connectionId = "connectionId";

class FlutterOpenvpn {
  static const MethodChannel _channel = const MethodChannel('flutter_openvpn');
  static OnProfileStatusChanged _onProfileStatusChanged;
  static OnVPNStatusChanged _onVPNStatusChanged;
  static OnConnectionStatusChanged _onConnectionStatusChanged;
  static String _vpnState = "";
  static Random random = new Random();

  /// Initialize plugin.
  ///
  /// Must be called before any use.
  ///
  /// localizedDescription and providerBundleIdentifier is only required on iOS.
  ///
  /// localizedDescription : Name of vpn profile in settings.
  ///
  /// providerBundleIdentifier : Bundle id of your vpn extension.
  ///
  /// returns {"currentStatus" : "VPN_CURRENT_STATUS",
  ///
  /// "expireAt" : "VPN_EXPIRE_DATE_STRING_IN_FORMAT(yyyy-MM-dd HH:mm:ss)",} if successful
  ///
  ///  returns null if failed
  static Future<dynamic> init(
      {String providerBundleIdentifier,
      String localizedDescription,
      String groupIdentifier}) async {
    if (Platform.isIOS) assert(groupIdentifier != null);

    /**
     * last value clear
     */
    StreamingSharedPreferences sp = StreamingSharedPreferences();

    await sp.setValue(_profile, (random.nextInt(100) + 10).toString());

    SharedPreferences spId = await SharedPreferences.getInstance();

    dynamic isInited = await _channel.invokeMethod("init", {
      'localizedDescription': localizedDescription,
      'providerBundleIdentifier': providerBundleIdentifier,
    }).catchError((error) => error);
    if (!(isInited is PlatformException) || isInited == null) {
      sp.addObserver(_connectionUpdate, (value) {
        List<String> values = value.split('_');
        _onConnectionStatusChanged?.call(values[0], values[1], values[2], value[3]);
      });

      sp.addObserver(_profile, (value) {
        _onProfileStatusChanged?.call(value == '0' ? false : true);
      });
      sp.addObserver(_vpnStatus, (value) {
        _vpnState = value;
        _onVPNStatusChanged?.call(value);
      });

      sp.run();

      if (Platform.isIOS) {
        StreamingSharedPreferences spGroup = StreamingSharedPreferences();
        spGroup.setPrefsName(groupIdentifier);
        spGroup.addObserver(_connectionUpdate, (value) {
          List<String> values = value.split('_');
          _onConnectionStatusChanged?.call(values[0], values[1], values[2], value[3]);
        });
        spGroup.addObserver(_vpnStatusGroup, (value) {
          _vpnState = value;
          _onVPNStatusChanged?.call(value);
        });
        spGroup.run();
      }

      if (spId.containsKey(_connectionId)) {
        List<String> splited = spId.getString(_connectionId).split('{||}');
        isInited.putIfAbsent('connectionId', () => splited[1]);
        isInited.putIfAbsent('connectionName', () => splited[0]);
      }
      return isInited;
    } else {
      print('OpenVPN Initilization failed');
      print((isInited as PlatformException).message);
      print((isInited as PlatformException).details);
      return null;
    }
  }

  static Future<String> _currentCon() async =>
      (await SharedPreferences.getInstance()).getString(_connectionId);

  static Future<String> get currentProfileId async {
    List<String> vars = (await _currentCon())?.split('{||}');
    if (vars == null) return null;
    return vars.last;
  }

  static Future<String> get currentProfileName async {
    List<String> vars = (await _currentCon())?.split('{||}');
    if (vars == null || vars.length != 2) return null;
    return vars.first;
  }

  /// Load profile and start connecting.
  ///
  /// if expireAt is provided
  /// Vpn session stops itself at given date.
  static Future<int> lunchVpn(
    String ovpnFileContents,
    OnProfileStatusChanged onProfileStatusChanged,
    OnVPNStatusChanged onVPNStatusChanged, {
    DateTime expireAt,
    String user = '',
    String pass = '',
    OnConnectionStatusChanged onConnectionStatusChanged,
    String connectionName,
    String connectionId,
    Duration timeOut = const Duration(seconds: 60),
  }) async {
    _onProfileStatusChanged = onProfileStatusChanged;
    _onVPNStatusChanged = onVPNStatusChanged;
    _onConnectionStatusChanged = onConnectionStatusChanged;
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(_connectionId, '$connectionName{||}$connectionId');

    dynamic isLunched = await _channel.invokeMethod(
      "lunch",
      {
        'ovpnFileContent': ovpnFileContents,
        'user': user ?? "",
        'pass': pass ?? "",
        'conName': connectionName ?? "",
        'conId': connectionId ?? "",
        'timeOut': Platform.isIOS ? timeOut?.inSeconds?.toString() : timeOut?.inSeconds,
        'expireAt': expireAt == null ? null : DateFormat("yyyy-MM-dd HH:mm:ss").format(expireAt),
      },
    ).catchError((error) => error);
    if (isLunched == null) return 0;
    print((isLunched as PlatformException).message);
    return int.tryParse((isLunched as PlatformException).code);
  }

  /// stops any connected session.
  static Future<void> stopVPN() async {
    try {
      await _channel.invokeMethod("stop");
    } catch (err) {
      print(err);
    }
  }
}
