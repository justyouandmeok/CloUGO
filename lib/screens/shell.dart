import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../theme.dart';
import 'create_page.dart';
import 'explore_page.dart';
import 'feed_page.dart';
import 'profile_page.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final pages = const [FeedPage(), ExplorePage(), CreatePage(), ProfilePage()];
    return Scaffold(
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.grid_view), selectedIcon: Icon(Icons.grid_view_rounded), label: 'Explorar'),
          NavigationDestination(icon: Icon(Icons.add_box_outlined), selectedIcon: Icon(Icons.add_box), label: 'Crear'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});
  final Post post;
  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    final liked = st.liked.contains(post.id);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      decoration: BoxDecoration(color: C.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.line)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(backgroundColor: HSLColor.fromAHSL(1, post.hue.toDouble(), 0.55, 0.45).toColor(), child: Text(post.user[0].toUpperCase())),
            title: Text('@${post.user}', style: const TextStyle(fontWeight: FontWeight.w700)),
            trailing: post.user == st.me?.user ? null : TextButton(onPressed: () => st.toggleFollow(post.user), child: Text(st.following.contains(post.user) ? 'Siguiendo' : 'Seguir')),
          ),
          Container(height: 180, margin: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: LinearGradient(colors: [HSLColor.fromAHSL(1, post.hue.toDouble(), 0.6, 0.35).toColor(), C.bg]))),
          Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text(post.text)),
          Row(
            children: [
              IconButton(onPressed: () => st.toggleLike(post), icon: Icon(liked ? Icons.favorite : Icons.favorite_border, color: liked ? Colors.pinkAccent : C.muted)),
              Text('${post.likes}'),
              IconButton(onPressed: () => _comments(context, post), icon: const Icon(Icons.chat_bubble_outline, color: C.muted)),
              Text('${post.comments.length}'),
            ],
          ),
        ],
      ),
    );
  }

  void _comments(BuildContext context, Post post) {
    final c = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: C.card,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 360,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('Comentarios', style: TextStyle(fontWeight: FontWeight.w700)),
              Expanded(child: ListView(children: post.comments.map((e) => ListTile(title: Text(e))).toList())),
              Row(children: [
                Expanded(child: TextField(controller: c, decoration: const InputDecoration(hintText: 'Escribí...', contentPadding: EdgeInsets.symmetric(horizontal: 12)))),
                IconButton(onPressed: () { context.read<AppState>().comment(post, c.text); Navigator.pop(context); }, icon: const Icon(Icons.send, color: C.accent)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
