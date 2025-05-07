import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse("ws://192.168.229.133:8000/ws/alerts")

  );

  Stream<Map<String, dynamic>> get alertsStream =>
      _channel.stream.map((event) => json.decode(event));
}
