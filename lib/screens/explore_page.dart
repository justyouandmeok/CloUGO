import 'package:flutter/material.dart';
import '../services/sb.dart';
import '../theme.dart';
import '../widgets/media_view.dart';
import 'hashtag_page.dart';
import 'reels_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> people = [];
  String q = '';
  int tab = 0;

  @override
  void initState() {
    super.initState();
    Sb.c.from('posts').select().neq('kind', 'story').order('created_at', ascending: false).limit(60).then((r) {
      if (mounted) setState(() => items = List<Map<String, dynamic>>.from(r));
    }).catchError((_) {});
    Sb.c.from('profiles').select().limit(30).then((r) {
      if (mounted) setState(() => people = List<Map<String, dynamic>>.from(r));
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final query = q.trim().toLowerCase();
    final shown = items.where((e) {
      final h = '${e['handle'] ?? ''} ${e['caption'] ?? ''}'.toLowerCase();
      return query.isEmpty || h.contains(query);
    }).toList();
    final users = people.where((p) => '${p['handle'] ?? ''}'.toLowerCase().contains(query)).toList();
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          child: TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: C.muted, size: 20),
              hintText: 'Buscar',
              hintStyle: const TextStyle(color: C.muted),
              filled: true,
              fillColor: const Color(0xFF1C1C1C),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final e in ['Para ti', 'Cuentas', 'Hashtags'])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(e),
                    selected: tab == ['Para ti', 'Cuentas', 'Hashtags'].indexOf(e),
                    onSelected: (_) => setState(() => tab = ['Para ti', 'Cuentas', 'Hashtags'].indexOf(e)),
                    selectedColor: Colors.white,
                    labelStyle: TextStyle(color: tab == ['Para ti', 'Cuentas', 'Hashtags'].indexOf(e) ? Colors.black : Colors.white, fontSize: 13),
                    backgroundColor: const Color(0xFF1C1C1C),
                    side: BorderSide.none,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: tab == 1
            ? ListView(children: [
                for (final p in users)
                  ListTile(
                    leading: CircleAvatar(child: Text('${p['handle'] ?? '?'}'[0].toUpperCase())),
                    title: Text('${p['handle'] ?? ''}'),
                    subtitle: Text('${p['name'] ?? ''}', style: const TextStyle(color: C.muted)),
                  ),
              ])
            : tab == 2
                ? ListView(children: [
                    if (query.startsWith('#') || query.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.tag),
                        title: Text('#${query.replaceAll('#', '')}'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HashtagPage(tag: query.replaceAll('#', '')))),
                      ),
                  ])
                : shown.isEmpty
                    ? const Center(child: Text('Nada para mostrar', style: TextStyle(color: C.muted)))
                    : GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: shown.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 1, crossAxisSpacing: 1),
                        itemBuilder: (_, i) {
                          final item = shown[i];
                          final url = item['media_url'] as String?;
                          return GestureDetector(
                            onTap: item['kind'] == 'reel' ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReelsPage(startId: item['id']))) : null,
                            child: Stack(fit: StackFit.expand, children: [
                              if (url == null || isVideo(url)) const ColoredBox(color: Color(0xFF161616), child: Icon(Icons.play_arrow, color: Colors.white54)) else Image.network(url, fit: BoxFit.cover),
                              if (item['kind'] == 'reel') const Positioned(right: 6, top: 6, child: Icon(Icons.play_arrow, size: 16, color: Colors.white)),
                            ]),
                          );
                        },
                      )),
      ])),
    );
  }
}
