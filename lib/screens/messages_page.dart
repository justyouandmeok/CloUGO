import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../theme.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final people = {'nube', 'arte', ...s.chats.keys};
    return Scaffold(
      appBar: AppBar(title: const Text('justyouandmeok', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
      body: ListView(children: [
        for (final h in people)
          ListTile(
            leading: CircleAvatar(child: Text(h[0].toUpperCase())),
            title: Text('@$h'),
            subtitle: Text(s.chats[h]?.isNotEmpty == true ? s.chats[h]!.last.text : 'Escribí un mensaje'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(handle: h))),
          ),
      ]),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.handle});
  final String handle;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final t = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final msgs = s.chats[widget.handle] ?? [];
    return Scaffold(
      appBar: AppBar(title: Text('@${widget.handle}')),
      body: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.all(12), children: [
          for (final m in msgs)
            Align(
              alignment: m.from == s.me?.handle ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: C.card, borderRadius: BorderRadius.circular(12)),
                child: Text(m.text),
              ),
            ),
        ])),
        Row(children: [
          Expanded(child: TextField(controller: t, decoration: const InputDecoration(hintText: 'Mensaje'))),
          IconButton(onPressed: () { s.send(widget.handle, t.text); t.clear(); }, icon: const Icon(Icons.send, color: C.accent)),
        ]),
      ]),
    );
  }
}
