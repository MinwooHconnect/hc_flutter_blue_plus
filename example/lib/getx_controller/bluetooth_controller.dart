import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus_example/main.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  var adapterState = BluetoothAdapterState.unknown.obs;

  Future<void> turnOnBluetooth() async {
    try {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }
    } catch (e) {
      Get.snackbar("Error", prettyException("Error Turning On:", e));
    }
  }

  @override
  void onInit() {
    super.onInit();
    // FlutterBluePlus의 adapterState 스트림을 adapterState 변수에 바인딩
    FlutterBluePlus.adapterState.listen((state) {
      adapterState.value = state;
    });
  }
}
