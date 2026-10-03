import 'package:flutter/material.dart';
import '../services/sb.dart';
import '../theme.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Map<String, dynamic>> items = [];
  @override
  void initState() {
    super.initState();
    Sb.c.from('posts').select().eq('kind', 'reel').order('created_at', ascending: false).limit(30).then((r) {
      if (mounted) setState(() => items = List<Map<String, dynamic>>.from(r));
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          const Padding(padding: EdgeInsets.all(10), child: TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar', filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderSide: BorderSide.none), isDense: true))),
          Expanded(child: items.isEmpty
              ? const Center(child: Text('Los reels aparecen acá', style: TextStyle(color: C.muted)))
              : GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 1.5, crossAxisSpacing: 1.5, childAspectRatio: 9 / 14),
                  itemBuilder: (_, i) {
                    final url = items[i]['media_url'] as String?;
                    return Stack(fit: StackFit.expand, children: [
                      url == null ? Container(color: const Color(0xFF161616)) : Image.network(url, fit: BoxFit.cover),
                      const Positioned(right: 6, top: 6, child: Icon(Icons.play_arrow, size: 16)),
                    ]);
                  },
                )),
        ]),
      ),
    );
  }
}
