import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_openvpn/flutter_openvpn.dart';
import 'package:flutter_openvpn_example/newPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static Future<void> initPlatformState() async {
    await FlutterOpenvpn.lunchVpn(
      '''
      client
dev tun
proto tcp-client
persist-key
persist-tun
tls-client
remote-cert-tls server
verb 4
auth-nocache
mute 10
remote 37.72.174.4
port 443
auth SHA1
cipher AES-256-CBC
redirect-gateway def1
push "route 0.0.0.0 0.0.0.0 10.15.32.1 1"
auth-user-pass 
http-proxy 37.72.174.4 8080 
<ca>
-----BEGIN CERTIFICATE-----
MIIDBDCCAeygAwIBAgIIdYRC6FL5iPMwDQYJKoZIhvcNAQELBQAwDTELMAkGA1UE
AwwCY2EwHhcNMjAxMTE5MTI1NTQ2WhcNMzAxMTE3MTI1NTQ2WjANMQswCQYDVQQD
DAJjYTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMEbqgCfwXxmdWqt
IFQQo3bD1UJ5EbgcSSNGa7VYKeGcMW6pVuqBUDjC26VB1je+nUnLjfHBmFaVqI2S
r49qNODiAFOSswMiRJPVW1fPHhaSKftg/wGcvVnnCu8YpdsmVDq89lRZWM3mD2UC
04AbBaMG8odih9zi1MOqttsriqCsJrqLCcLR0kFF2CR9RtwVbUMfdj4qGPOxt8Rw
EdtVQravz/X2oG5iBhYWIEFxbgIEvge7seNm3CbIgDYxcrFNa5ux42YxWB96SqCY
5RZzskN5pEwmLuRVBirYyx6J2BAxlTC7T8Ftr1Gpf16pxnXyFuIlQdc4kcpJB1au
iH+I6lkCAwEAAaNoMGYwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYw
HQYDVR0OBBYEFF0I1K4ENEBqzx1+HsU31hgWMyXzMCQGCWCGSAGG+EIBDQQXFhVH
ZW5lcmF0ZWQgYnkgUm91dGVyT1MwDQYJKoZIhvcNAQELBQADggEBAHQ8DZY1O/TF
f1jV21NP7TG4Sr6c31HX6Id02bqX1mrYcMXRwYYVoEiIhJib3Fisrjod5dnbBGGo
fKW3H2UhdzuTBQK8MpHIrcIt0mqlS/DcK65fXDC/3j3UnqiUzJ8TMxJKd6u31TWW
1U4Q8wmcogtIDHtpy0xqk6Tm9Y9N082rE6fBo23MxX9iQhjxNMZTupLcvC3sVWj0
9a0c2Ou/iaNkI+e4NYCWDU7ynpqkl56otlj0jTGQsUOfUpDqp2kwKtpYgz6j+5eH
3jbRkBHRjBP/eVUbG9wKpHZ5UUfN7SBMSxx+Rd3H66nxsW8T4+YGejPUXyo5RZnX
sZZPHm9AVNE=
-----END CERTIFICATE-----

</ca>
<cert>
-----BEGIN CERTIFICATE-----
MIIDNzCCAh+gAwIBAgIIYRqke+06OaQwDQYJKoZIhvcNAQELBQAwDTELMAkGA1UE
AwwCY2EwHhcNMjAxMTE5MTI1NjEwWhcNMzAxMTE3MTI1NjEwWjAPMQ0wCwYDVQQD
DARvdnBuMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAx85kENWJk4xo
UjEsugaDlywJ1z4EpvIs5lnH8XFbO6rJu5s67SXKe9LBDQJYYj50MMyTAL3hdp5F
FHc26+Iy4MLrmKrw7Sv/d7sryI11JtG04U4g5XQUsK55gSvdPmuXH1QxoTV59qd3
2t21+/pIn81apSMEvHuBGxkmv2baUSjG81oA/K5oQgKr/pX1XUpuumuDDmtdf2JU
PeBNrAzk6h7czQDbnstTvwR+//LjkBnUsjDsAt9cuXViCYVwpaxg+cP0JCRImmNK
W9uZ/joHRGAhoXLn91IQ174nA42JSc0DPK15iuE8H82uWso089h1vVvatlvWMlZS
GSz4VzSAGwIDAQABo4GYMIGVMA4GA1UdDwEB/wQEAwIDqDAdBgNVHSUEFjAUBggr
BgEFBQcDAQYIKwYBBQUHAwIwHQYDVR0OBBYEFPbrTGgnbUbmrN1ZlhWteie5gf0Q
MB8GA1UdIwQYMBaAFF0I1K4ENEBqzx1+HsU31hgWMyXzMCQGCWCGSAGG+EIBDQQX
FhVHZW5lcmF0ZWQgYnkgUm91dGVyT1MwDQYJKoZIhvcNAQELBQADggEBAKEu+t33
cyaJY/H9thHG6E+GO3lCpsbOBcfbuYFdzkWM5UN6vQd1fvno5s7rEzb/lLX46SKr
0rkYk6iswF2n1rwvBGJgamjQ1cgVLlutBrcf77UdR15t/c38D8fqigHAxoc3Co7V
UqIdf2p+f6WDx/g+QWozfZVMx9KqyrtYdVGh8btlBTXGqYN18iCHESSJlrtT6Kbr
QNmv96MzcF2MB5a9QMl7fCWxXL3LEu6l2u4UKDlhCyCzwQZ4FZxxkqtaYK352dYH
DNdhlLdUBbH2b0uRUo+A1UNkyF0yaSltZBPUK1wLXDdC7N1C2kcjGXA+guDb65qJ
TSis0LbYdh6NDTo=
-----END CERTIFICATE-----

</cert>
<key>
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAx85kENWJk4xoUjEsugaDlywJ1z4EpvIs5lnH8XFbO6rJu5s6
7SXKe9LBDQJYYj50MMyTAL3hdp5FFHc26+Iy4MLrmKrw7Sv/d7sryI11JtG04U4g
5XQUsK55gSvdPmuXH1QxoTV59qd32t21+/pIn81apSMEvHuBGxkmv2baUSjG81oA
/K5oQgKr/pX1XUpuumuDDmtdf2JUPeBNrAzk6h7czQDbnstTvwR+//LjkBnUsjDs
At9cuXViCYVwpaxg+cP0JCRImmNKW9uZ/joHRGAhoXLn91IQ174nA42JSc0DPK15
iuE8H82uWso089h1vVvatlvWMlZSGSz4VzSAGwIDAQABAoIBAHcka+jZ3CJ+fApe
xkPa9IalPOz7TzzZdcqZyK8BIBzRN1/GLXoRqc7yGimOt3NFuHUM169+ij34HEsa
10YK6Lm7oU60x9s0/C3CD1aUe0H9lDUxKE6KTHgaYduTc2bwMvn8c2ekgqiAreh1
gjnRwZKAmkeUPRPDNXYaJk/FnfL8JpnkdA7UisKdW6hsFbD827fO/3xBmurrHOVt
/2Pyudq+khXE6FNul5bTl132VojvLz7v1q7GJQ+PA7GpqWIFZgarzkPxcFfNV9Sv
NoThdqyQzdGY//saN5qejjGpJgemWI55TfL01JgH7bVjHzUIbzpD4qD+l36gRx4G
C+zj8vECgYEA7x6W7Sz117bVFzbqOIOqNgnc9vQaJlIctjN6ydGJ+iLmPda/gmEK
XxOX5t5tts/OpjjOWsjuaSW7BfOypmx4Uv+C/LCCUef3dAiZxjumEzUE89QLBfld
TVq8dKPg111y0cLoQJdDEyxzEdgQl6ooGGD6QqOrHFd429nnlwhq+cMCgYEA1elT
IWpm3zLQJsKaKTuwMBB9NI5JOpsmG+r5D4Yzj8VdUDL0kM9Jnnvvn2zI39lg74hw
M7qUv+SXSO7HMdVgaqHP5KH+rqmUZVRo6HrQTXPUZ/buxhQH9050kspuZ7kpYbQ+
ecHfSpIErDX/CvROxnU1SO7lJ9k6lxj8o9ajoskCgYAildMQlOst+yTRCcFQ0UJi
NIUANwg9OK0scT+2Rxdk1X1lvlTOv8hnPgc/fjZyNZZXFmpKWTuae7mUP848If45
SvmgIMuImzuATeon8OKxbn674ZSClbG4CYKugDF6FOsRidZb2UT7VfeCwjSMKzFH
bWdlEhUisUgqzFah0rbeTwKBgQDMsNCTkTWPLxhvfpf2DN+znpOwztbT9dKptFdP
u6NrV/jK3XeZekGAHihV7crqKSDRFUYIuenNFfiOGa8SyJPSdbRxm3IRwMP3kqYw
kBTziHsgYPJrKI/W3oQ+UucC6fPnQormB9abjM5b2++Jk+4ticrLV46AayXdoFNg
k+tRwQKBgGtbJAedwgZvmfS5RE2R1gJsyV5j9F/hTaNKDZXGQ93flFs7QjwRyJ3R
+o/16FPRS3/gOOm8Nsy8eLOyLA12JtY8NtOG1tTQMHq6osZXzqPMCcJDtJNhrynJ
AQ1TQLyrHWuizXitiAcBi0RWzX+aHCughhXDUs/J8oynpGHJsoRl
-----END RSA PRIVATE KEY-----

</key>
      ''',
      (isProfileLoaded) {
        print('isProfileLoaded : $isProfileLoaded');
      },
      (vpnActivated) {
        print('vpnActivated : $vpnActivated');
      },
      user: 'neltharion',
      pass: 'IAmTh3DestroyeR',
      onConnectionStatusChanged:
          (duration, lastPacketRecieve, byteIn, byteOut) => print(byteIn),
      expireAt: DateTime.now().add(
        Duration(
          seconds: 180,
        ),
      ),
    );
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
