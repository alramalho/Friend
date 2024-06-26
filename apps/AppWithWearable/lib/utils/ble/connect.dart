import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:friend_private/backend/schema/structs/b_t_device_struct.dart';

Future<void> bleConnectDevice(BTDeviceStruct btDevice) async {
  final device = BluetoothDevice.fromId(btDevice.id);
  try {
    // Step 1: Connect with autoConnect
    // await device.connect(autoConnect: false);
    // return;
    await device.connect(autoConnect: true, mtu: null);
    // TODO: compare this with the connection state listener, both doing same thing? what's better?
    // Step 2: Listen to the connection state to ensure the device is connected
    await device.connectionState.where((state) => state == BluetoothConnectionState.connected).first;

    // Step 3: Request the desired MTU size if the platform is Android
    if (Platform.isAndroid) {
      int desiredMtu = 512; // Example MTU size
      await device.requestMtu(desiredMtu);
    }
  } catch (e) {
    debugPrint('bleConnectDevice failed: $e');
  }
}

Future bleDisconnectDevice(BTDeviceStruct btDevice) async {
  final device = BluetoothDevice.fromId(btDevice.id);
  try {
    await device.disconnect();
  } catch (e) {
    debugPrint('bleDisconnectDevice failed: $e');
  }
}
