import 'package:flutter_blue_plus_example/binding/Init_binding.dart';
import 'package:flutter_blue_plus_example/view/find_device_view.dart';
import 'package:flutter_blue_plus_example/view/home_view.dart';
import 'package:get/get.dart';

class RouteInfo {
  static const String routeRoot = '/';
  static List<GetPage> pages = [
    GetPage(name: routeRoot, page: () => HomeView(), binding: InitBinding()),
    GetPage(name: '/findDevices', page: () => FindDevicesView()),
    //GetPage(name: '/deviceScreen', page: () => DeviceScreen()),
  ];
}
