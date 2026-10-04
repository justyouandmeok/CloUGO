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
  int tab = 0;

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
    final bio = '${profile?['bio'] ?? ''}';
    final avatar = profile?['avatar_url'] as String?;
    final posts = mine.where((e) => e['kind'] != 'reel' && e['kind'] != 'story').toList();
    final reels = mine.where((e) => e['kind'] == 'reel').toList();
    final shown = tab == 1 ? reels : posts;
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          const Icon(Icons.lock_outline, size: 16),
          const SizedBox(width: 6),
          GestureDetector(
            onLongPress: () {
              final created = profile?['created_at'] ?? 'fecha no disponible';
              showDialog(context: context, builder: (_) => AlertDialog(
                title: Text('@$handle'),
                content: Text('Cuenta desde: $created\nCambios de usuario: 0'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
              ));
            },
            child: Text(handle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          const Icon(Icons.keyboard_arrow_down),
        ]),
        actions: [
          IconButton(onPressed: load, icon: const Icon(Icons.add_box_outlined)),
          IconButton(
            onPressed: () async {
              await Sb.c.auth.signOut();
              if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SizedBox()), (_) => false);
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(children: [
          if (err != null) Padding(padding: const EdgeInsets.all(16), child: Text(err!, style: const TextStyle(color: Colors.redAccent))),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: const Color(0xFF262626),
                backgroundImage: avatar != null ? NetworkImage(avatar) : null,
                child: avatar == null ? Text(name.isEmpty ? '?' : name[0].toUpperCase(), style: const TextStyle(fontSize: 28)) : null,
              ),
              const SizedBox(width: 22),
              Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _stat('${posts.length + reels.length}', 'publicaciones'),
                _stat('0', 'seguidores'),
                _stat('0', 'seguidos'),
              ])),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
              if (bio.isNotEmpty) Text(bio),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfile(handle: handle, name: name, bio: bio)));
                  load();
                },
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Color(0xFF333333)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Editar perfil'),
              )),
              const SizedBox(width: 6),
              Expanded(child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Color(0xFF333333)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Compartir perfil'),
              )),
            ]),
          ),
          Row(children: [
            _tab(Icons.grid_on, 0),
            _tab(Icons.movie_outlined, 1),
          ]),
          const Divider(height: 1, color: C.line),
          if (shown.isEmpty)
            const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('Todavía no hay nada acá', style: TextStyle(color: C.muted))))
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shown.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1.5, mainAxisSpacing: 1.5, childAspectRatio: 0.8),
              itemBuilder: (_, i) => GestureDetector(
                onTap: shown[i]['kind'] == 'reel' ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReelsPage(startId: shown[i]['id']))) : null,
                child: _thumb(shown[i]),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _tab(IconData icon, int i) => Expanded(
    child: IconButton(
      onPressed: () => setState(() => tab = i),
      icon: Icon(icon, color: tab == i ? Colors.white : C.muted),
    ),
  );

  Widget _stat(String n, String l) => Column(children: [
    Text(n, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
    Text(l, style: const TextStyle(fontSize: 13)),
  ]);
}

Widget _thumb(Map<String, dynamic> p) {
  final url = p['media_url'] as String?;
  final video = url != null && (url.contains('.mp4') || url.contains('.mov'));
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
