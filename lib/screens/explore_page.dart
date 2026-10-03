import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../theme.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  @override
  Widget build(BuildContext context) {
    final posts = context.watch<AppState>().posts;
    return Scaffold(
      appBar: AppBar(title: const Text('Explorar')),
      body: GridView.builder(
        padding: const EdgeInsets.all(2),
        itemCount: posts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
        itemBuilder: (_, i) {
          final p = posts[i];
          return Container(
            color: HSLColor.fromAHSL(1, p.hue.toDouble(), 0.5, 0.4).toColor(),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(6),
            child: Text('@${p.user}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          );
        },
      ),
    );
  }
}
