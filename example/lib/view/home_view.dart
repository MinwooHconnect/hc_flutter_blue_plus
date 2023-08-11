import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus_example/getx_controller/bluetooth_controller.dart';
import 'package:flutter_blue_plus_example/getx_controller/home_controller.dart';
import 'package:flutter_blue_plus_example/view/bluetooth_off_view.dart';
import 'package:flutter_blue_plus_example/view/find_device_view.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final state = Get.find<BluetoothController>().adapterState.value;
        if (state == BluetoothAdapterState.on) {
          return FindDevicesView();
        } else {
          FlutterBluePlus.stopScan();
          return BluetoothOffView();
        }
      }),
    );
  }
}
