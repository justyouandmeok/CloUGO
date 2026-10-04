import 'package:flutter/material.dart';
import '../services/sb.dart';
import '../theme.dart';
import '../widgets/media_view.dart';
import 'reels_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Map<String, dynamic>> items = [];
  String q = '';

  @override
  void initState() {
    super.initState();
    Sb.c.from('posts').select().order('created_at', ascending: false).limit(60).then((r) {
      if (mounted) setState(() => items = List<Map<String, dynamic>>.from(r));
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final shown = items.where((e) {
      final h = '${e['handle'] ?? ''} ${e['caption'] ?? ''}'.toLowerCase();
      return q.isEmpty || h.contains(q.toLowerCase());
    }).toList();
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: C.muted),
              hintText: 'Buscar',
              filled: true,
              fillColor: const Color(0xFF1C1C1C),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              isDense: true,
            ),
          ),
        ),
        Expanded(child: shown.isEmpty
            ? const Center(child: Text('Nada para mostrar', style: TextStyle(color: C.muted)))
            : GridView.builder(
                itemCount: shown.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 1.5, crossAxisSpacing: 1.5, childAspectRatio: 0.8),
                itemBuilder: (_, i) {
                  final item = shown[i];
                  final url = item['media_url'] as String?;
                  return GestureDetector(
                    onTap: item['kind'] == 'reel' ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReelsPage(startId: item['id']))) : null,
                    child: Stack(fit: StackFit.expand, children: [
                      if (url == null || isVideo(url)) const ColoredBox(color: Color(0xFF161616)) else Image.network(url, fit: BoxFit.cover),
                      if (item['kind'] == 'reel' || isVideo(url)) const Positioned(right: 6, top: 6, child: Icon(Icons.play_arrow, size: 18, color: Colors.white)),
                    ]),
                  );
                },
              )),
      ]),
    );
  }
}
