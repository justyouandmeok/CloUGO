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
      appBar: AppBar(
        title: Row(children: [
          const Icon(Icons.lock_outline, size: 16),
          const SizedBox(width: 6),
          Text(me.handle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const Icon(Icons.keyboard_arrow_down),
        ]),
        actions: [
          IconButton(onPressed: () => context.read<AppState>().logout(), icon: const Icon(Icons.menu)),
        ],
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            CircleAvatar(radius: 40, backgroundColor: const Color(0xFF1A1A1A), child: Text(me.name.isEmpty ? '?' : me.name[0], style: const TextStyle(fontSize: 28))),
            const SizedBox(width: 24),
            Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat('${mine.length}', 'publicaciones'),
              _stat('0', 'seguidores'),
              _stat('${s.following.length}', 'seguidos'),
            ])),
          ]),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(me.name, style: const TextStyle(fontWeight: FontWeight.w700))),
        Padding(padding: const EdgeInsets.fromLTRB(16, 2, 16, 12), child: Text(me.bio.isEmpty ? 'Bio' : me.bio, style: const TextStyle(color: C.muted))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Expanded(child: OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfile())), child: const Text('Editar perfil', style: TextStyle(color: Colors.white)))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Compartir perfil', style: TextStyle(color: Colors.white)))),
          ]),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: C.line),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mine.isEmpty ? 6 : mine.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1.5, mainAxisSpacing: 1.5),
          itemBuilder: (_, i) {
            final hue = (me.handle.hashCode + i * 40) % 360;
            return Container(color: HSLColor.fromAHSL(1, hue.toDouble(), 0.4, 0.3).toColor(), alignment: Alignment.center, child: mine.length > i ? const Icon(Icons.image, color: Colors.white54) : const SizedBox());
          },
        ),
      ]),
    );
  }

  Widget _stat(String n, String l) => Column(children: [
    Text(n, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
    Text(l, style: const TextStyle(fontSize: 12)),
  ]);
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
      appBar: AppBar(title: const Text('Editar perfil'), actions: [
        TextButton(onPressed: () { context.read<AppState>().saveProfile(name.text, bio.text); Navigator.pop(context); }, child: const Text('Listo')),
      ]),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre')),
        const SizedBox(height: 12),
        TextField(controller: bio, maxLines: 3, decoration: const InputDecoration(labelText: 'Bio')),
      ])),
    );
  }
}
