import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../theme.dart';
import 'story_page.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('CloUGO', style: TextStyle(fontWeight: FontWeight.w800, color: C.accent))),
      body: ListView(
        children: [
          SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final h in ['vos', 'nube', 'arte', 'ciudad'])
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryPage(name: h))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [C.accent, C.accent2])),
                          child: CircleAvatar(radius: 26, backgroundColor: C.bg, child: Text(h[0].toUpperCase())),
                        ),
                        const SizedBox(height: 4),
                        Text(h, style: const TextStyle(fontSize: 11)),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
          for (final p in s.posts) _card(context, s, p),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, AppState s, Post p) {
    final c = TextEditingController();
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: C.card, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${p.author}  @${p.handle}', style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(p.text),
        Row(children: [
          IconButton(onPressed: () => s.toggleLike(p), icon: Icon(p.liked ? Icons.favorite : Icons.favorite_border, color: p.liked ? Colors.pinkAccent : C.muted)),
          Text('${p.likes}'),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline, color: C.muted)),
          Text('${p.comments.length}'),
        ]),
        if (p.comments.isNotEmpty) Text(p.comments.last, style: const TextStyle(color: C.muted, fontSize: 13)),
        Row(children: [
          Expanded(child: TextField(controller: c, decoration: const InputDecoration(hintText: 'Comentar', isDense: true))),
          IconButton(onPressed: () { s.comment(p, c.text); c.clear(); }, icon: const Icon(Icons.send, color: C.accent)),
        ]),
      ]),
    );
  }
}
