import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../theme.dart';
import 'messages_page.dart';
import 'story_page.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('CloUGO'),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MessagesPage())), icon: const Icon(Icons.send_outlined)),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 104,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                for (final h in ['Tu historia', 'nube', 'arte', 'ciudad', 'musica'])
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryPage(name: h))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.all(2.2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: C.story, begin: Alignment.topRight, end: Alignment.bottomLeft),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: C.bg, shape: BoxShape.circle),
                            child: CircleAvatar(radius: 28, backgroundColor: const Color(0xFF1A1A1A), child: Text(h[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600))),
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(width: 68, child: Text(h, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11))),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: C.line),
          for (final p in s.posts) _PostCard(post: p),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final Post post;
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = TextEditingController();
    final hue = post.handle.hashCode % 360;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListTile(
        leading: CircleAvatar(backgroundColor: HSLColor.fromAHSL(1, hue.toDouble(), 0.5, 0.35).toColor(), child: Text(post.handle[0].toUpperCase())),
        title: Text(post.handle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        trailing: const Icon(Icons.more_horiz),
      ),
      AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: HSLColor.fromAHSL(1, hue.toDouble(), 0.45, 0.28).toColor(),
          alignment: Alignment.center,
          child: Padding(padding: const EdgeInsets.all(24), child: Text(post.text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
        ),
      ),
      Row(children: [
        IconButton(onPressed: () => s.toggleLike(post), icon: Icon(post.liked ? Icons.favorite : Icons.favorite_border, color: post.liked ? Colors.red : Colors.white)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.send_outlined)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
      ]),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: Text('${post.likes} Me gusta', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 2),
        child: RichText(text: TextSpan(style: const TextStyle(color: Colors.white, fontSize: 13), children: [
          TextSpan(text: '${post.handle} ', style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(text: post.text),
        ])),
      ),
      if (post.comments.isNotEmpty)
        Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), child: Text('Ver los ${post.comments.length} comentarios', style: const TextStyle(color: C.muted, fontSize: 13))),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 8, 12),
        child: Row(children: [
          Expanded(child: TextField(controller: c, style: const TextStyle(fontSize: 13), decoration: const InputDecoration(hintText: 'Agrega un comentario...', border: InputBorder.none, isDense: true))),
          TextButton(onPressed: () { s.comment(post, c.text); c.clear(); }, child: const Text('Publicar')),
        ]),
      ),
    ]);
  }
}
