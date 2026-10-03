import 'package:flutter/material.dart';
import '../services/sb.dart';
import '../theme.dart';
import 'messages_page.dart';
import 'story_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> stories = [];
  bool loading = true;
  String? err;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() { loading = true; err = null; });
    try {
      final rows = await Sb.c.from('posts').select().order('created_at', ascending: false).limit(40);
      final all = List<Map<String, dynamic>>.from(rows);
      posts = all.where((e) => e['kind'] == 'post').toList();
      stories = all.where((e) => e['kind'] == 'story').toList();
    } catch (e) {
      err = '$e';
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CloUGO'),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MessagesPage())), icon: const Icon(Icons.favorite_border)),
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MessagesPage())), icon: const Icon(Icons.send_outlined)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          children: [
            SizedBox(
              height: 108,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                children: [
                  if (stories.isEmpty)
                    const Padding(padding: EdgeInsets.all(12), child: Text('Sin historias', style: TextStyle(color: C.muted))),
                  for (final s in stories)
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryPage(item: s))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.all(2.2),
                            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: C.story)),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                              child: CircleAvatar(radius: 28, backgroundImage: s['media_url'] != null ? NetworkImage(s['media_url']) : null, child: s['media_url'] == null ? Text('${s['handle'] ?? '?'}'[0].toUpperCase()) : null),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(width: 68, child: Text('${s['handle'] ?? ''}', maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11))),
                        ]),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: C.line),
            if (loading) const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
            if (err != null) Padding(padding: const EdgeInsets.all(16), child: Text(err!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && posts.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Text('Todavía no hay publicaciones. Tocá + para subir.', style: TextStyle(color: C.muted))),
            for (final p in posts) _PostTile(p),
          ],
        ),
      ),
    );
  }
}

class _PostTile extends StatelessWidget {
  const _PostTile(this.p);
  final Map<String, dynamic> p;
  @override
  Widget build(BuildContext context) {
    final url = p['media_url'] as String?;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListTile(
        leading: CircleAvatar(child: Text('${p['handle'] ?? '?'}'[0].toUpperCase())),
        title: Text('${p['handle'] ?? 'user'}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        trailing: const Icon(Icons.more_horiz),
      ),
      AspectRatio(
        aspectRatio: 1,
        child: url == null
            ? Container(color: const Color(0xFF161616), alignment: Alignment.center, child: Text('${p['caption'] ?? ''}', textAlign: TextAlign.center))
            : Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image))),
      ),
      const Row(children: [
        IconButton(onPressed: null, icon: Icon(Icons.favorite_border, color: Colors.white)),
        IconButton(onPressed: null, icon: Icon(Icons.chat_bubble_outline, color: Colors.white)),
        IconButton(onPressed: null, icon: Icon(Icons.send_outlined, color: Colors.white)),
        Spacer(),
        IconButton(onPressed: null, icon: Icon(Icons.bookmark_border, color: Colors.white)),
      ]),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
        child: Text.rich(TextSpan(children: [
          TextSpan(text: '${p['handle'] ?? ''} ', style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(text: '${p['caption'] ?? ''}'),
        ])),
      ),
    ]);
  }
}
