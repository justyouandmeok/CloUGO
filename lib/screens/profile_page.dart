import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sb.dart';
import '../state.dart';
import '../theme.dart';
import 'reels_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profile;
  List<Map<String, dynamic>> mine = [];
  String? err;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final u = Sb.user;
    if (u == null) {
      setState(() => err = 'No hay sesión');
      return;
    }
    try {
      var row = await Sb.c.from('profiles').select().eq('id', u.id).maybeSingle();
      row ??= {'id': u.id, 'handle': u.email?.split('@').first ?? 'user', 'name': u.email ?? ''};
      final posts = await Sb.c.from('posts').select().eq('user_id', u.id).order('created_at', ascending: false);
      if (!mounted) return;
      setState(() {
        profile = Map<String, dynamic>.from(row!);
        mine = List<Map<String, dynamic>>.from(posts);
        err = null;
      });
    } catch (e) {
      if (mounted) setState(() => err = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final handle = '${profile?['handle'] ?? '...'}';
    final name = '${profile?['name'] ?? handle}';
    return Scaffold(
      appBar: AppBar(
        title: Text(handle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(onPressed: load, icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () async {
              await Sb.c.auth.signOut();
              if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SizedBox()), (_) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(children: [
        if (err != null) Padding(padding: const EdgeInsets.all(16), child: Text(err!, style: const TextStyle(color: Colors.redAccent))),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            CircleAvatar(radius: 40, backgroundColor: const Color(0xFF1A1A1A), child: Text(name.isEmpty ? '?' : name[0].toUpperCase(), style: const TextStyle(fontSize: 28))),
            const SizedBox(width: 24),
            Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat('${mine.length}', 'publicaciones'),
              _stat('0', 'seguidores'),
              _stat('0', 'seguidos'),
            ])),
          ]),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700))),
        Padding(padding: const EdgeInsets.fromLTRB(16, 2, 16, 12), child: Text('${profile?['bio'] ?? ''}', style: const TextStyle(color: C.muted))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton(onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfile(handle: handle, name: name, bio: '${profile?['bio'] ?? ''}')));
            load();
          }, child: const Text('Editar perfil', style: TextStyle(color: Colors.white))),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: C.line),
        if (mine.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Text('Todavía no publicaste', style: TextStyle(color: C.muted))),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mine.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1.5, mainAxisSpacing: 1.5, childAspectRatio: 0.8),
          itemBuilder: (_, i) => GestureDetector(
            onTap: () {
              if (mine[i]['kind'] == 'reel') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ReelsPage(startId: mine[i]['id'])));
              }
            },
            child: _thumb(mine[i]),
          ),
        ),
      ]),
    );
  }

  Widget _stat(String n, String l) => Column(children: [
    Text(n, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
    Text(l, style: const TextStyle(fontSize: 12)),
  ]);
}

Widget _thumb(Map<String, dynamic> p) {
  final url = p['media_url'] as String?;
  final video = url != null && (url.endsWith('.mp4') || url.endsWith('.mov'));
  return Stack(fit: StackFit.expand, children: [
    if (url != null && !video) Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF161616)))
    else const ColoredBox(color: Color(0xFF161616)),
    if (video || p['kind'] == 'reel') const Positioned(right: 6, top: 6, child: Icon(Icons.play_arrow, color: Colors.white, size: 18)),
  ]);
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.handle, required this.name, required this.bio});
  final String handle, name, bio;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late final name = TextEditingController(text: widget.name);
  late final bio = TextEditingController(text: widget.bio);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil'), actions: [
        TextButton(onPressed: () async {
          final u = Sb.user;
          if (u != null) {
            await Sb.c.from('profiles').upsert({'id': u.id, 'handle': widget.handle, 'name': name.text, 'bio': bio.text});
            context.read<AppState>().saveProfile(name.text, bio.text);
          }
          if (context.mounted) Navigator.pop(context);
        }, child: const Text('Listo')),
      ]),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre')),
        const SizedBox(height: 12),
        TextField(controller: bio, maxLines: 3, decoration: const InputDecoration(labelText: 'Bio')),
      ])),
    );
  }
}
