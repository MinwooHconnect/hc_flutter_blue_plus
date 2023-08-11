import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus_example/getx_controller/bluetooth_controller.dart';
import 'package:get/get.dart';

class BluetoothOffView extends GetView<BluetoothController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Obx(() => Text(
                  'Bluetooth Adapter is ${controller.adapterState.value != null ? controller.adapterState.value.toString().split(".").last : 'not available'}.',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                )),
            if (Platform.isAndroid)
              ElevatedButton(
                child: const Text('TURN ON'),
                onPressed: controller.turnOnBluetooth,
              ),
          ],
        ),
      ),
    );
  }
}
