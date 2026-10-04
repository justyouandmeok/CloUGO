import 'package:flutter/material.dart';
import '../services/sb.dart';
import '../theme.dart';
import '../widgets/media_view.dart';

class HashtagPage extends StatefulWidget {
  const HashtagPage({super.key, required this.tag});
  final String tag;
  @override
  State<HashtagPage> createState() => _HashtagPageState();
}

class _HashtagPageState extends State<HashtagPage> {
  List<Map<String, dynamic>> items = [];
  @override
  void initState() {
    super.initState();
    Sb.c.from('posts').select().ilike('caption', '%#${widget.tag}%').order('created_at', ascending: false).limit(40).then((r) {
      if (mounted) setState(() => items = List<Map<String, dynamic>>.from(r));
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('#${widget.tag}')),
      body: items.isEmpty
          ? const Center(child: Text('Nada con este hashtag', style: TextStyle(color: C.muted)))
          : GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 1.5, crossAxisSpacing: 1.5, childAspectRatio: 0.8),
              itemBuilder: (_, i) {
                final url = items[i]['media_url'] as String?;
                if (url == null || isVideo(url)) return const ColoredBox(color: Color(0xFF161616), child: Icon(Icons.play_arrow));
                return Image.network(url, fit: BoxFit.cover);
              },
            ),
    );
  }
}

class CaptionText extends StatelessWidget {
  const CaptionText({super.key, required this.handle, required this.caption});
  final String handle, caption;
  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[
      TextSpan(text: '$handle ', style: const TextStyle(fontWeight: FontWeight.w700)),
    ];
    for (final word in caption.split(' ')) {
      final tag = word.startsWith('#') && word.length > 1;
      spans.add(TextSpan(
        text: '$word ',
        style: TextStyle(color: tag ? const Color(0xFF4DA3FF) : null, fontWeight: tag ? FontWeight.w600 : null),
      ));
    }
    return GestureDetector(
      onTap: () {
        final tag = caption.split(' ').where((w) => w.startsWith('#') && w.length > 1).map((w) => w.substring(1)).firstOrNull;
        if (tag != null) Navigator.push(context, MaterialPageRoute(builder: (_) => HashtagPage(tag: tag)));
      },
      child: Text.rich(TextSpan(children: spans)),
    );
  }
}
