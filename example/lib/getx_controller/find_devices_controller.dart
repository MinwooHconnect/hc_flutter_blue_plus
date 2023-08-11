import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus_example/main.dart';
import 'package:get/get.dart';

class FindDevicesController extends GetxController {
  var isScanning = false.obs;
  var connectedDevices = <BluetoothDevice>[].obs;
  RxList<ScanResult> scanResults = <ScanResult>[].obs;

  @override
  void onInit() {
    super.onInit();

    FlutterBluePlus.isScanning.listen((scanning) {
      isScanning.value = scanning;
    });

    FlutterBluePlus.scanResults.listen((results) {
      scanResults.value = results;
    });

    Stream.periodic(const Duration(seconds: 5))
        .asyncMap((_) => FlutterBluePlus.connectedSystemDevices)
        .listen((devices) {
      connectedDevices.value = devices;
    });
  }

  Future<void> startOrStopScan() async {
    if (isScanning.value) {
      await FlutterBluePlus.stopScan();
    } else {
      try {
        await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 15),
          androidUsesFineLocation: false,
        );
      } catch (e) {
        Get.snackbar("Error", prettyException("Start Scan Error:", e));
      }
    }
  }

// ... (추가 메서드 및 로직이 필요한 경우 여기에 추가)
}
