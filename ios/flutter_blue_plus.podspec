#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_blue_plus.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_blue_plus'
  s.version          = '1.12.9'
  s.summary          = 'Fork flutter_blue_plus'
  s.description      = 'Flutter plugin for connecting and communicationg with Bluetooth Low Energy devices, on Android and iOS'
  s.homepage         = 'https://github.com/boskokg/flutter_blue_plus'
  s.license          = { :type => 'BSD-3-Clause', :file => '../LICENSE' }
  s.author           = { 'Bosko Popovic' => 'kmwdev@hconnect.co.kr' }
  s.source           = { :git => 'https://github.com/MinwooHconnect/hc_flutter_blue_plus.git', :tag => s.version.to_s}
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.framework = 'CoreBluetooth'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', }
end
