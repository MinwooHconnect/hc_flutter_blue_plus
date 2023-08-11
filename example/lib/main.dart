// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus_example/route/route_info.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'widgets.dart';

final snackBarKeyA = GlobalKey<ScaffoldMessengerState>();
final snackBarKeyB = GlobalKey<ScaffoldMessengerState>();
final snackBarKeyC = GlobalKey<ScaffoldMessengerState>();

void main() {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) {
      runApp(const FlutterBlueApp());
    });
  } else {
    runApp(const FlutterBlueApp());
  }
}

class FlutterBlueApp extends StatelessWidget {
  const FlutterBlueApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: ThemeData(
            fontFamily: 'SpoqaHanSansNeo',
            scaffoldBackgroundColor: Colors.white),
        getPages: RouteInfo.pages,
        navigatorObservers: [BluetoothAdapterStateObserver()]);
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _btStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/deviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _btStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _btStateSubscription?.cancel();
    _btStateSubscription = null;
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(
      BuildContext context, List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () async {
                      try {
                        await c.read();
                      } catch (e) {
                        final snackBar = SnackBar(
                            content: Text(prettyException("Read Error:", e)));
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                    },
                    onWritePressed: () async {
                      try {
                        await c.write(_getRandomBytes(),
                            withoutResponse: c.properties.writeWithoutResponse);
                        if (c.properties.read) {
                          await c.read();
                        }
                      } catch (e) {
                        final snackBar = SnackBar(
                            content: Text(prettyException("Write Error:", e)));
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                    },
                    onNotificationPressed: () async {
                      try {
                        await c.setNotifyValue(c.isNotifying == false);
                        if (c.properties.read) {
                          await c.read();
                        }
                      } catch (e) {
                        final snackBar = SnackBar(
                            content:
                                Text(prettyException("Subscribe Error:", e)));
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () async {
                              try {
                                await d.read();
                              } catch (e) {
                                final snackBar = SnackBar(
                                    content: Text(
                                        prettyException("Read Error:", e)));
                                snackBarKeyC.currentState
                                    ?.showSnackBar(snackBar);
                              }
                            },
                            onWritePressed: () async {
                              try {
                                await d.write(_getRandomBytes());
                              } catch (e) {
                                final snackBar = SnackBar(
                                    content: Text(
                                        prettyException("Write Error:", e)));
                                snackBarKeyC.currentState
                                    ?.showSnackBar(snackBar);
                              }
                            },
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyC,
      child: Scaffold(
        appBar: AppBar(
          title: Text(device.localName),
          actions: <Widget>[
            StreamBuilder<BluetoothConnectionState>(
              stream: device.connectionState,
              initialData: BluetoothConnectionState.connecting,
              builder: (c, snapshot) {
                VoidCallback? onPressed;
                String text;
                switch (snapshot.data) {
                  case BluetoothConnectionState.connected:
                    onPressed = () async {
                      try {
                        await device.disconnect();
                      } catch (e) {
                        final snackBar = SnackBar(
                            content:
                                Text(prettyException("Disconnect Error:", e)));
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                    };
                    text = 'DISCONNECT';
                    break;
                  case BluetoothConnectionState.disconnected:
                    onPressed = () async {
                      try {
                        await device.connect(timeout: Duration(seconds: 4));
                      } catch (e) {
                        final snackBar = SnackBar(
                            content:
                                Text(prettyException("Connect Error:", e)));
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                    };
                    text = 'CONNECT';
                    break;
                  default:
                    onPressed = null;
                    text =
                        snapshot.data.toString().split(".").last.toUpperCase();
                    break;
                }
                return TextButton(
                    onPressed: onPressed,
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .labelLarge
                          ?.copyWith(color: Colors.white),
                    ));
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<BluetoothConnectionState>(
                stream: device.connectionState,
                initialData: BluetoothConnectionState.connecting,
                builder: (c, snapshot) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${device.remoteId}'),
                    ),
                    ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          snapshot.data == BluetoothConnectionState.connected
                              ? const Icon(Icons.bluetooth_connected)
                              : const Icon(Icons.bluetooth_disabled),
                          snapshot.data == BluetoothConnectionState.connected
                              ? StreamBuilder<int>(
                                  stream: rssiStream(),
                                  builder: (context, snapshot) {
                                    return Text(
                                        snapshot.hasData
                                            ? '${snapshot.data}dBm'
                                            : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall);
                                  })
                              : Text('',
                                  style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      title: Text(
                          'Device is ${snapshot.data.toString().split('.')[1]}.'),
                      trailing: StreamBuilder<bool>(
                        stream: device.isDiscoveringServices,
                        initialData: false,
                        builder: (c, snapshot) => IndexedStack(
                          index: (snapshot.data ?? false) ? 1 : 0,
                          children: <Widget>[
                            TextButton(
                              child: const Text("Get Services"),
                              onPressed: () async {
                                try {
                                  await device.discoverServices();
                                } catch (e) {
                                  final snackBar = SnackBar(
                                      content: Text(prettyException(
                                          "Discover Services Error:", e)));
                                  snackBarKeyC.currentState
                                      ?.showSnackBar(snackBar);
                                }
                              },
                            ),
                            const IconButton(
                              icon: SizedBox(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.grey),
                                ),
                                width: 18.0,
                                height: 18.0,
                              ),
                              onPressed: null,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<int>(
                stream: device.mtu,
                initialData: 0,
                builder: (c, snapshot) => ListTile(
                  title: const Text('MTU Size'),
                  subtitle: Text('${snapshot.data} bytes'),
                  trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        try {
                          await device.requestMtu(223);
                        } catch (e) {
                          final snackBar = SnackBar(
                              content: Text(
                                  prettyException("Change Mtu Error:", e)));
                          snackBarKeyC.currentState?.showSnackBar(snackBar);
                        }
                      }),
                ),
              ),
              StreamBuilder<List<BluetoothService>>(
                stream: device.servicesStream,
                initialData: const [],
                builder: (c, snapshot) {
                  return Column(
                    children: _buildServiceTiles(context, snapshot.data ?? []),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<int> rssiStream(
      {Duration frequency = const Duration(seconds: 5)}) async* {
    var isConnected = true;
    final subscription = device.connectionState.listen((v) {
      isConnected = v == BluetoothConnectionState.connected;
    });
    while (isConnected) {
      try {
        yield await device.readRssi();
      } catch (e) {
        print("Error reading RSSI: $e");
        break;
      }
      await Future.delayed(frequency);
    }
    // Device disconnected, stopping RSSI stream
    subscription.cancel();
  }
}

String prettyException(String prefix, dynamic e) {
  if (e is FlutterBluePlusException) {
    return "$prefix ${e.errorString}";
  } else if (e is PlatformException) {
    return "$prefix ${e.message}";
  }
  return prefix + e.toString();
}
