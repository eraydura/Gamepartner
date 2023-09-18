import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'CRUD.dart';
import '../Models/cache.dart';

Future<void> main() async {
  await execute(InternetConnectionChecker());

  final InternetConnectionChecker customInstance =
  InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 1),
    checkInterval: const Duration(seconds: 1),
  );

  await execute(customInstance);
}

Future<void> execute(InternetConnectionChecker internetConnectionChecker) async {

  final bool isConnected = await InternetConnectionChecker().hasConnection;

  final StreamSubscription<InternetConnectionStatus> listener =
  InternetConnectionChecker().onStatusChange.listen(
        (InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          changeStatus("closed",AppCache.steamid());
          break;
        case InternetConnectionStatus.disconnected:
          changeStatus("closed",AppCache.steamid());
          break;
      }
    },
  );

  await Future<void>.delayed(const Duration(seconds: 30));
  await listener.cancel();
}