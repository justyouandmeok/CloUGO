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
      appBar: AppBar(
        title: Text(Sb.user?.email?.split('@').first ?? 'Mensajes', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        actions: const [Icon(Icons.edit_outlined), SizedBox(width: 16)],
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, size: 20),
              hintText: 'Buscar',
              hintStyle: const TextStyle(color: C.muted),
              filled: true,
              fillColor: const Color(0xFF1C1C1C),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFF1C1C1C), child: Icon(Icons.mail_outline, size: 20)),
          title: const Text('Solicitudes', style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: const Text('Prioritarias y secundarias', style: TextStyle(color: C.muted, fontSize: 12)),
          trailing: const Icon(Icons.chevron_right, color: C.muted),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RequestsPage())),
        ),
        const Divider(height: 1, color: C.line),
        for (final p in shown)
          ListTile(
            leading: CircleAvatar(radius: 26, backgroundColor: const Color(0xFF262626), child: Text('${p['handle'] ?? '?'}'[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w700))),
            title: Text('${p['handle'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              s.chats['${p['handle']}']?.isNotEmpty == true ? s.chats['${p['handle']}']!.last.text : '${p['name'] ?? 'Enviar mensaje'}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: C.muted, fontSize: 13),
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(handle: '${p['handle']}'))),
          ),
      ]),
    );
  }
}

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes')),
      body: ListView(children: const [
        ListTile(title: Text('Prioritarias'), subtitle: Text('Cuentas que se siguen entre sí', style: TextStyle(color: C.muted))),
        ListTile(title: Text('Secundarias'), subtitle: Text('Cuentas públicas que todavía no seguís', style: TextStyle(color: C.muted))),
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
      appBar: AppBar(title: Row(children: [
        CircleAvatar(radius: 16, child: Text(widget.handle.isEmpty ? '?' : widget.handle[0].toUpperCase())),
        const SizedBox(width: 8),
        Text(widget.handle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ])),
      body: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.all(12), children: [
          for (final m in msgs)
            Align(
              alignment: m.from == s.me?.handle ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                constraints: const BoxConstraints(maxWidth: 280),
                decoration: BoxDecoration(
                  color: m.from == s.me?.handle ? C.blue : const Color(0xFF262626),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(m.text),
              ),
            ),
        ])),
        SafeArea(child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 8, 8),
          child: Row(children: [
            Expanded(child: TextField(
              controller: t,
              decoration: InputDecoration(hintText: 'Mensaje...', filled: true, fillColor: const Color(0xFF1C1C1C), border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
            )),
            IconButton(onPressed: () { if (t.text.trim().isEmpty) return; s.send(widget.handle, t.text); t.clear(); }, icon: const Icon(Icons.send, color: C.blue)),
          ]),
        )),
      ]),
    );
  }
}
