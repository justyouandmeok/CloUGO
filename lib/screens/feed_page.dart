import 'package:flutter/material.dart';
import '../services/cache.dart';
import '../services/sb.dart';
import '../services/upload_queue.dart';
import '../theme.dart';
import 'hashtag_page.dart';
import '../widgets/media_view.dart';
import 'create_page.dart';
import 'messages_page.dart';
import 'notifications_page.dart';
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
    uploadQueue.addListener(_onQueue);
    load();
  }

  void _onQueue() { if (mounted) setState(() {}); }

  @override
  void dispose() { uploadQueue.removeListener(_onQueue); super.dispose(); }

  Future<void> load() async {
    final cached = await LocalCache.feed();
    if (cached.isNotEmpty && mounted) {
      setState(() {
        posts = cached.where((e) => e['kind'] != 'story').toList();
        stories = cached.where((e) => e['kind'] == 'story').toList();
        loading = false;
      });
    }
    try {
      final rows = await Sb.c.from('posts').select().order('created_at', ascending: false).limit(40);
      final all = List<Map<String, dynamic>>.from(rows);
      await LocalCache.saveFeed(all);
      posts = all.where((e) => e['kind'] != 'story').toList();
      stories = all.where((e) => e['kind'] == 'story').toList();
      err = null;
    } catch (e) {
      if (posts.isEmpty) err = '$e';
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePage())), icon: const Icon(Icons.add, size: 28)),
        title: const Text('CloUGO', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())), icon: const Icon(Icons.favorite_border)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          children: [
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                children: [
                  GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePage())),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: Column(children: [
                          CircleAvatar(radius: 30, backgroundColor: Color(0xFF1C1C1C), child: Icon(Icons.add, size: 22)),
                          SizedBox(height: 4),
                          SizedBox(width: 68, child: Text('Tu historia', maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TextStyle(fontSize: 11))),
                        ]),
                      ),
                    ),
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
            for (final p in uploadQueue.pending.where((e) => e['kind']=='post')) _PendingTile(p),
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
    final handle = '${p['handle'] ?? 'user'}';
    final kind = '${p['kind'] ?? 'post'}';
    final caption = '${p['caption'] ?? ''}'.trim();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
        child: Row(children: [
          CircleAvatar(radius: 16, backgroundColor: const Color(0xFF262626), child: Text(handle.isEmpty ? '?' : handle[0].toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(handle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            Text(kind == 'reel' ? 'Reel' : 'Publicación', style: const TextStyle(color: C.muted, fontSize: 12)),
          ])),
          const Icon(Icons.more_horiz),
        ]),
      ),
      AspectRatio(
        aspectRatio: kind == 'reel' ? 4 / 5 : 1,
        child: ClipRect(
          child: url == null
              ? Container(color: const Color(0xFF161616), alignment: Alignment.center, child: Text(caption, textAlign: TextAlign.center))
              : MediaView(url: url, play: kind == 'reel'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 0),
        child: Row(children: [
          IconButton(onPressed: () {}, visualDensity: VisualDensity.compact, icon: const Icon(Icons.favorite_border, size: 26)),
          IconButton(onPressed: () {}, visualDensity: VisualDensity.compact, icon: const Icon(Icons.chat_bubble_outline, size: 24)),
          IconButton(onPressed: () {}, visualDensity: VisualDensity.compact, icon: const Icon(Icons.send_outlined, size: 24)),
          const Spacer(),
          IconButton(onPressed: () {}, visualDensity: VisualDensity.compact, icon: const Icon(Icons.bookmark_border, size: 26)),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 2),
        child: Text('0 me gusta', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 2, 14, 2),
        child: CaptionText(handle: handle, caption: caption.isEmpty ? '' : caption),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(14, 2, 14, 16), child: Text('Ver comentarios', style: TextStyle(color: C.muted, fontSize: 13))),
    ]);
  }
}

class _PendingTile extends StatelessWidget {
  const _PendingTile(this.p);
  final Map<String, dynamic> p;
  @override
  Widget build(BuildContext context) {
    final failed = p['status'] == 'error';
    return ListTile(
      leading: const Icon(Icons.cloud_upload_outlined),
      title: Text(failed ? 'No se pudo publicar' : 'Subiendo...'),
      subtitle: Text('${p['caption'] ?? ''}'),
      trailing: failed ? TextButton(onPressed: () => uploadQueue.retry('${p['id']}'), child: const Text('Reintentar')) : const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
