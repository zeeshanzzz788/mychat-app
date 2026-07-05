import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/socket_service.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat> chats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);
    if (auth.token != null) {
      Provider.of<SocketService>(context, listen: false).connect(auth.token!);
      _loadChats();
    }
  }

  Future<void> _loadChats() async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final chatService = ChatService();
      final fetchedChats = await chatService.getUserChats(auth.token!);
      setState(() {
        chats = fetchedChats;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final otherUser = chat.participants.firstWhere(
                  (u) => u.id != auth.user?.id,
                  orElse: () => chat.participants.first,
                );

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: otherUser.avatar != null
                        ? NetworkImage(otherUser.avatar!)
                        : null,
                    child: otherUser.avatar == null
                        ? Text(otherUser.name[0])
                        : null,
                  ),
                  title: Text(otherUser.name),
                  subtitle: const Text('Tap to open chat'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(chat: chat),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
