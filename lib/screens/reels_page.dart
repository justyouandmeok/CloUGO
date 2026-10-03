import 'package:flutter/material.dart';
import '../services/sb.dart';
import '../theme.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});
  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  List<Map<String, dynamic>> items = [];
  @override
  void initState() {
    super.initState();
    Sb.c.from('posts').select().eq('kind', 'reel').order('created_at', ascending: false).limit(20).then((r) {
      if (mounted) setState(() => items = List<Map<String, dynamic>>.from(r));
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Scaffold(body: Center(child: Text('Todavía no hay reels', style: TextStyle(color: C.muted))));
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (_, i) {
          final url = items[i]['media_url'] as String?;
          return Stack(fit: StackFit.expand, children: [
            if (url != null) Image.network(url, fit: BoxFit.cover) else const ColoredBox(color: Color(0xFF111111)),
            Positioned(left: 16, bottom: 24, right: 70, child: Text('@${items[i]['handle'] ?? ''}\n${items[i]['caption'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w600))),
          ]);
        },
      ),
    );
  }
}
