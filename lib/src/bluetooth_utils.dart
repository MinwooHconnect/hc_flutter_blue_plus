part of flutter_blue_plus;

enum BluetoothDeviceType { unknown, classic, le, dual }

BluetoothDeviceType _bmToBluetoothDeviceType(BmBluetoothSpecEnum value) {
  switch (value) {
    case BmBluetoothSpecEnum.unknown:
      return BluetoothDeviceType.unknown;
    case BmBluetoothSpecEnum.classic:
      return BluetoothDeviceType.classic;
    case BmBluetoothSpecEnum.le:
      return BluetoothDeviceType.le;
    case BmBluetoothSpecEnum.dual:
      return BluetoothDeviceType.dual;
  }
}

enum BluetoothConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting
}

BluetoothConnectionState _bmToBluetoothConnectionState(
    BmConnectionStateEnum value) {
  switch (value) {
    case BmConnectionStateEnum.disconnected:
      return BluetoothConnectionState.disconnected;
    case BmConnectionStateEnum.connecting:
      return BluetoothConnectionState.connecting;
    case BmConnectionStateEnum.connected:
      return BluetoothConnectionState.connected;
    case BmConnectionStateEnum.disconnecting:
      return BluetoothConnectionState.disconnecting;
  }
}

BluetoothAdapterState _bmToBluetoothAdapterState(BmAdapterStateEnum value) {
  switch (value) {
    case BmAdapterStateEnum.unknown:
      return BluetoothAdapterState.unknown;
    case BmAdapterStateEnum.unavailable:
      return BluetoothAdapterState.unavailable;
    case BmAdapterStateEnum.unauthorized:
      return BluetoothAdapterState.unauthorized;
    case BmAdapterStateEnum.turningOn:
      return BluetoothAdapterState.turningOn;
    case BmAdapterStateEnum.on:
      return BluetoothAdapterState.on;
    case BmAdapterStateEnum.turningOff:
      return BluetoothAdapterState.turningOff;
    case BmAdapterStateEnum.off:
      return BluetoothAdapterState.off;
  }
}

BluetoothBondingState _bmToBluetoothBondingState(BmBondingStateEnum value) {
  switch (value) {
    case BmBondingStateEnum.unknown:
      return BluetoothBondingState.unknown;
    case BmBondingStateEnum.bonding:
      return BluetoothBondingState.bonding;
    case BmBondingStateEnum.bonded:
      return BluetoothBondingState.bonded;
    case BmBondingStateEnum.unbonding:
      return BluetoothBondingState.unbonding;
    default:
      return BluetoothBondingState.unknown; // 기본 값을 반환하거나 오류를 발생시킬 수 있다
  }
}

enum ConnectionPriority { balanced, high, lowPower }

enum Phy { le1m, le2m, leCoded }

enum PhyCoding { noPreferred, s2, s8 }

extension PhyExt on Phy {
  int get mask {
    switch (this) {
      case Phy.le1m:
        return 1;
      case Phy.le2m:
        return 2;
      case Phy.leCoded:
        return 3;
      default:
        return 1;
    }
  }
}

@Deprecated('Use PhyCoding instead')
enum PhyOption { noPreferred, s2, s8 }

@Deprecated('Use Phy instead')
enum PhyType { le1m, le2m, leCoded }
