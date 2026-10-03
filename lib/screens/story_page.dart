import 'package:flutter/material.dart';
import '../theme.dart';

class StoryPage extends StatelessWidget {
  const StoryPage({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(children: [
          const Center(child: Icon(Icons.cloud, size: 120, color: C.accent)),
          Positioned(top: 48, left: 16, right: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            LinearProgressIndicator(value: 0.4, color: C.accent, backgroundColor: Colors.white24),
            const SizedBox(height: 12),
            Text('@$name', style: const TextStyle(fontWeight: FontWeight.w700)),
            const Text('Historia de CloUGO', style: TextStyle(color: C.muted)),
          ])),
        ]),
      ),
    );
  }
}
