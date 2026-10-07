import 'package:flutter/material.dart';
import '../services/sb.dart';
import '../theme.dart';
import '../widgets/media_view.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key, this.startId});
  final String? startId;
  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  List<Map<String, dynamic>> items = [];
  int index = 0;
  @override
  void initState() {
    super.initState();
    Sb.c.from('posts').select().eq('kind', 'reel').order('created_at', ascending: false).limit(30).then((r) {
      final list = List<Map<String, dynamic>>.from(r);
      final i = widget.startId == null ? 0 : list.indexWhere((e) => e['id'] == widget.startId);
      if (mounted) setState(() { items = list; index = i < 0 ? 0 : i; });
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: Text('Todavía no hay reels', style: TextStyle(color: C.muted))));
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        PageView.builder(
          controller: PageController(initialPage: index),
          scrollDirection: Axis.vertical,
          itemCount: items.length,
          onPageChanged: (v) => setState(() => index = v),
          itemBuilder: (_, i) => _Reel(item: items[i], play: i == index),
        ),
        const Positioned(top: 48, left: 16, child: Text('Reels', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700))),
      ]),
    );
  }
}

class _Reel extends StatelessWidget {
  const _Reel({required this.item, required this.play});
  final Map<String, dynamic> item;
  final bool play;
  @override
  Widget build(BuildContext context) {
    final handle = '${item['handle'] ?? 'user'}';
    final url = '${item['media_url'] ?? ''}';
    return Stack(fit: StackFit.expand, children: [
      if (url.isNotEmpty) MediaView(url: url, play: play) else const ColoredBox(color: Color(0xFF111111)),
      const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.center, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black54]))),
      Positioned(
        right: 8, bottom: 88,
        child: Column(children: [
          _act(Icons.favorite_border, '0'),
          _act(Icons.chat_bubble_outline, '0'),
          _act(Icons.send_outlined, ''),
          _act(Icons.bookmark_border, ''),
          _act(Icons.more_horiz, ''),
          const SizedBox(height: 10),
          const CircleAvatar(radius: 14, backgroundColor: Color(0xFF222222), child: Icon(Icons.music_note, size: 16)),
        ]),
      ),
      Positioned(
        left: 12, right: 72, bottom: 28,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(radius: 16, child: Text(handle[0].toUpperCase())),
            const SizedBox(width: 8),
            Text(handle, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(minimumSize: const Size(72, 28), padding: const EdgeInsets.symmetric(horizontal: 10), side: const BorderSide(color: Colors.white)), child: const Text('Seguir', style: TextStyle(fontSize: 12))),
          ]),
          const SizedBox(height: 8),
          Text('${item['caption'] ?? ''}', maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          const Row(children: [Icon(Icons.music_note, size: 14), SizedBox(width: 4), Text('Audio original', style: TextStyle(fontSize: 12))]),
        ]),
      ),
      const Positioned(left: 0, right: 0, bottom: 8, child: LinearProgressIndicator(value: 0.35, minHeight: 2, color: Colors.white, backgroundColor: Colors.white24)),
    ]);
  }

  Widget _act(IconData icon, String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(children: [
      Icon(icon, color: Colors.white, size: 28),
      if (label.isNotEmpty) Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );
}
