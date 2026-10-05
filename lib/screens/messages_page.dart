import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../services/sb.dart';
import '../theme.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});
  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Map<String, dynamic>> people = [];
  String q = '';
  @override
  void initState() {
    super.initState();
    Sb.c.from('profiles').select().limit(40).then((r) {
      if (mounted) setState(() => people = List<Map<String, dynamic>>.from(r));
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final shown = people.where((p) => '${p['handle'] ?? ''}'.toLowerCase().contains(q.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: Text(Sb.user?.email?.split('@').first ?? 'Mensajes', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Buscar', filled: true, fillColor: const Color(0xFF1C1C1C), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), isDense: true),
          ),
        ),
        ListTile(title: const Text('Solicitudes prioritarias'), subtitle: const Text('Cuentas que se siguen entre sí'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ListTile(title: const Text('Solicitudes secundarias'), subtitle: const Text('Cuentas públicas que todavía no seguís'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        const Divider(color: C.line),
        for (final p in shown)
          ListTile(
            leading: CircleAvatar(child: Text('${p['handle'] ?? '?'}'[0].toUpperCase())),
            title: Text('@${p['handle'] ?? ''}'),
            subtitle: Text(s.chats['${p['handle']}']?.isNotEmpty == true ? s.chats['${p['handle']}']!.last.text : '${p['name'] ?? 'Enviar mensaje'}'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(handle: '${p['handle']}'))),
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
