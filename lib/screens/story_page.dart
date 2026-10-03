import 'package:flutter/material.dart';

class StoryPage extends StatelessWidget {
  const StoryPage({super.key, required this.item});
  final Map<String, dynamic> item;
  @override
  Widget build(BuildContext context) {
    final url = item['media_url'] as String?;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(fit: StackFit.expand, children: [
          if (url != null) Image.network(url, fit: BoxFit.contain) else const Center(child: Icon(Icons.cloud, size: 80)),
          Positioned(top: 48, left: 12, right: 12, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const LinearProgressIndicator(value: 0.35, color: Colors.white),
            const SizedBox(height: 10),
            Text('@${item['handle'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('${item['caption'] ?? ''}', style: const TextStyle(color: Colors.white70)),
          ])),
        ]),
      ),
    );
  }
}
