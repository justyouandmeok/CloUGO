import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../theme.dart';
import 'shell.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});
  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('CloUGO', style: TextStyle(fontWeight: FontWeight.w800, color: C.accent)), actions: [
        IconButton(onPressed: st.logout, icon: const Icon(Icons.logout)),
      ]),
      body: ListView(children: [for (final p in st.posts) PostCard(post: p), const SizedBox(height: 24)]),
    );
  }
}
