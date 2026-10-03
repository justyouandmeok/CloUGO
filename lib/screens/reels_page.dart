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
      body: PageView.builder(
        controller: PageController(initialPage: index),
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        onPageChanged: (v) => setState(() => index = v),
        itemBuilder: (_, i) {
          final item = items[i];
          final url = '${item['media_url'] ?? ''}';
          return Stack(fit: StackFit.expand, children: [
            if (url.isNotEmpty) MediaView(url: url, play: i == index) else const ColoredBox(color: Color(0xFF111111)),
            Positioned(left: 14, right: 72, bottom: 18, child: Text('@${item['handle'] ?? ''}\n${item['caption'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w600))),
            const Positioned(right: 8, bottom: 24, child: Column(children: [
              Icon(Icons.favorite_border, color: Colors.white, size: 30),
              SizedBox(height: 18),
              Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
              SizedBox(height: 18),
              Icon(Icons.send_outlined, color: Colors.white, size: 28),
            ])),
          ]);
        },
      ),
    );
  }
}
