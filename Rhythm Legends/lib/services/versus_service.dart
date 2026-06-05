import 'dart:async';
import 'dart:convert';
import 'dart:io';

class VersusService {
  static ServerSocket? server;

  static Socket? socket;

  static StreamSubscription? subscription;

  static bool connected = false;

  static Function(String)? onMessage;

  static Future<void> host(int port) async {
    server = await ServerSocket.bind(
      InternetAddress.anyIPv4,
      port,
    );

    server!.listen((client) {
      socket = client;

      connected = true;

      listen();
    });
  }

  static Future<void> join(
    String ip,
    int port,
  ) async {
    socket = await Socket.connect(
      ip,
      port,
    );

    connected = true;

    listen();
  }

  static void listen() {
    subscription = socket?.listen((data) {
      String message = utf8.decode(data);

      if (onMessage != null) {
        onMessage!(message);
      }
    });
  }

  static void send(String message) {
    socket?.write(message);
  }

  static Future<void> dispose() async {
    await subscription?.cancel();

    await socket?.close();

    await server?.close();

    connected = false;
  }
}