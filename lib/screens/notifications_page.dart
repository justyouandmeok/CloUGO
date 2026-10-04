import 'package:flutter/material.dart';
import '../services/sb.dart';
import '../theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> items = [];
  @override
  void initState() {
    super.initState();
    Sb.c.from('posts').select().order('created_at', ascending: false).limit(20).then((r) {
      if (mounted) setState(() => items = List<Map<String, dynamic>>.from(r));
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
      body: items.isEmpty
          ? const Center(child: Text('Todavía no hay actividad', style: TextStyle(color: C.muted)))
          : ListView(children: [
              for (final p in items)
                ListTile(
                  leading: CircleAvatar(child: Text('${p['handle'] ?? '?'}'[0].toUpperCase())),
                  title: Text('${p['handle'] ?? 'alguien'} publicó'),
                  subtitle: Text('${p['caption'] ?? p['kind'] ?? ''}', maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
            ]),
    );
  }
}
