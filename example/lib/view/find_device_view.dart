import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus_example/getx_controller/find_devices_controller.dart';
import 'package:flutter_blue_plus_example/main.dart';
import 'package:flutter_blue_plus_example/widgets.dart';
import 'package:get/get.dart';

class FindDevicesView extends GetView<FindDevicesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: controller.startOrStopScan,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Obx(() => Column(
                    children: controller.connectedDevices
                        .map((d) => ListTile(
                              title: Text(d.localName),
                              subtitle: Text(d.remoteId.toString()),
                              trailing: StreamBuilder<BluetoothConnectionState>(
                                stream: d.connectionState,
                                initialData:
                                    BluetoothConnectionState.disconnected,
                                builder: (c, snapshot) {
                                  if (snapshot.data ==
                                      BluetoothConnectionState.connected) {
                                    return ElevatedButton(
                                      child: const Text('OPEN'),
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  DeviceScreen(device: d),
                                              settings: RouteSettings(
                                                  name: '/deviceScreen'))),
                                    );
                                  }
                                  if (snapshot.data ==
                                      BluetoothConnectionState.disconnected) {
                                    return ElevatedButton(
                                        child: const Text('CONNECT'),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    d
                                                        .connect(
                                                            timeout: Duration(
                                                                seconds: 4))
                                                        .catchError((e) {
                                                      final snackBar = SnackBar(
                                                          content: Text(
                                                              prettyException(
                                                                  "Connect Error:",
                                                                  e)));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    });
                                                    return DeviceScreen(
                                                        device: d);
                                                  },
                                                  settings: RouteSettings(
                                                      name: '/deviceScreen')));
                                        });
                                  }
                                  return Text(snapshot.data
                                      .toString()
                                      .toUpperCase()
                                      .split('.')[1]);
                                },
                              ),
                            ))
                        .toList(),
                  )),
              Obx(() => Column(
                    children: controller.scanResults
                        .map((r) => ScanResultTile(
                              result: r,
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) {
                                        r.device
                                            .connect(
                                                timeout: Duration(seconds: 4))
                                            .catchError((e) {
                                          final snackBar = SnackBar(
                                              content: Text(prettyException(
                                                  "Connect Error:", e)));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        });
                                        return DeviceScreen(device: r.device);
                                      },
                                      settings: RouteSettings(
                                          name: '/deviceScreen'))),
                            ))
                        .toList(),
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() {
        if (controller.isScanning.value) {
          return FloatingActionButton(
            child: const Icon(Icons.stop),
            onPressed: controller.startOrStopScan,
            backgroundColor: Colors.red,
          );
        } else {
          return FloatingActionButton(
            child: const Icon(Icons.search),
            onPressed: controller.startOrStopScan,
          );
        }
      }),
    );
  }
}
