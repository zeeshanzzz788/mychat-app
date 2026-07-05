import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  IO.Socket? _socket;

  void connect(String token) {
    _socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.onConnect((_) {
      print('✅ Socket connected');
      // Join user room for notifications
      _socket!.emit('join_user', 'user_id_placeholder');
    });

    _socket!.onDisconnect((_) => print('❌ Socket disconnected'));
  }

  void joinChat(String chatId) {
    _socket?.emit('join_chat', chatId);
  }

  void sendMessage(String chatId, String content, String senderId) {
    _socket?.emit('send_message', {
      'chatId': chatId,
      'content': content,
      'senderId': senderId,
    });
  }

  void onNewMessage(Function(dynamic) callback) {
    _socket?.on('new_message', callback);
  }

  void disconnect() {
    _socket?.disconnect();
  }
}
