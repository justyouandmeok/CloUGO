import 'package:flutter/material.dart';
import '../theme.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Buscar', filled: true, fillColor: const Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), isDense: true)),
          ),
          Expanded(child: GridView.builder(
            itemCount: 24,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 1.5, crossAxisSpacing: 1.5),
            itemBuilder: (_, i) {
              final big = i % 9 == 0;
              return Container(color: HSLColor.fromAHSL(1, (i * 28).toDouble() % 360, 0.45, 0.32).toColor(), child: big ? const Align(alignment: Alignment.topRight, child: Padding(padding: EdgeInsets.all(4), child: Icon(Icons.collections, size: 16))) : null);
            },
          )),
        ]),
      ),
    );
  }
}
