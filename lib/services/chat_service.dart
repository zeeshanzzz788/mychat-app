import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat.dart';
import 'auth_service.dart';

class ChatService {
  final String baseUrl = 'http://10.0.2.2:3000/api';

  Future<List<Chat>> getUserChats(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Chat.fromJson(json)).toList();
    }
    throw Exception('Failed to load chats');
  }
}
