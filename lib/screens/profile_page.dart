import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final me = s.me!;
    final mine = s.posts.where((p) => p.handle == me.handle).toList();
    return Scaffold(
      appBar: AppBar(title: Text('@${me.handle}'), actions: [
        IconButton(onPressed: () => context.read<AppState>().logout(), icon: const Icon(Icons.logout)),
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [
          CircleAvatar(radius: 36, child: Text(me.name.isEmpty ? '?' : me.name[0])),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(me.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            Text(me.bio.isEmpty ? 'Sin bio' : me.bio, style: const TextStyle(color: C.muted)),
            Text('${mine.length} publicaciones · ${s.following.length} siguiendo'),
          ]),
        ]),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfile())), child: const Text('Editar perfil')),
        const SizedBox(height: 16),
        for (final p in mine) ListTile(title: Text(p.text), subtitle: Text('${p.likes} me gusta')),
      ]),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late final name = TextEditingController(text: context.read<AppState>().me?.name);
  late final bio = TextEditingController(text: context.read<AppState>().me?.bio);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar'), actions: [
        TextButton(onPressed: () { context.read<AppState>().saveProfile(name.text, bio.text); Navigator.pop(context); }, child: const Text('Guardar')),
      ]),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre')),
        const SizedBox(height: 12),
        TextField(controller: bio, decoration: const InputDecoration(labelText: 'Bio')),
      ])),
    );
  }
}
