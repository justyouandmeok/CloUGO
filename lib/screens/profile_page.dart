import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    final me = st.me!;
    final mine = st.posts.where((p) => p.user == me.user).toList();
    return Scaffold(
      appBar: AppBar(title: Text('@${me.user}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            CircleAvatar(radius: 32, backgroundColor: C.accent, child: Text(me.name[0].toUpperCase(), style: const TextStyle(fontSize: 24))),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(me.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              Text(me.bio, style: const TextStyle(color: C.muted)),
              Text('${mine.length} publicaciones · ${st.following.length} siguiendo', style: const TextStyle(color: C.muted, fontSize: 12)),
            ]),
          ]),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () => _edit(context, me), child: const Text('Editar perfil')),
          const SizedBox(height: 12),
          for (final p in mine)
            ListTile(title: Text(p.text, maxLines: 2, overflow: TextOverflow.ellipsis), subtitle: Text('${p.likes} me gusta')),
        ],
      ),
    );
  }

  void _edit(BuildContext context, UserAcc me) {
    final name = TextEditingController(text: me.name);
    final bio = TextEditingController(text: me.bio);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: C.card,
        title: const Text('Editar perfil'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre')),
          TextField(controller: bio, decoration: const InputDecoration(labelText: 'Bio')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(onPressed: () { context.read<AppState>().updateMe(name: name.text, bio: bio.text); Navigator.pop(context); }, child: const Text('Guardar')),
        ],
      ),
    );
  }
}
