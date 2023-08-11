import 'package:flutter_blue_plus_example/getx_controller/bluetooth_controller.dart';
import 'package:flutter_blue_plus_example/getx_controller/find_devices_controller.dart';
import 'package:flutter_blue_plus_example/getx_controller/home_controller.dart';
import 'package:get/get.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BluetoothController());
    Get.put(FindDevicesController());
    Get.put(HomeController());
  }
}
