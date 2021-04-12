import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/src/app.dart';
import 'package:flutter_chat_socket/src/common/app_initializer.dart';
import 'package:flutter_chat_socket/src/common/dependecy_injection.dart';
import 'package:flutter_chat_socket/src/services/socket_service.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

Injector injector;

void main() async {
  DependencyInjection().initialise(Injector.getInjector());
  injector = Injector.getInjector();
  await AppInitializer().initialise(injector);
  final SocketService socketService = injector.get<SocketService>();
  socketService.createSocketConnection();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat Realtime',
      home: App(),
    ),
  );
}
