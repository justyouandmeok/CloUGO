import 'package:flutter/material.dart';
import '../theme.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  @override
  Widget build(BuildContext context) {
    const tags = ['nube', 'arte', 'música', 'ciudad', 'fotos', 'amigos'];
    return Scaffold(
      appBar: AppBar(title: const Text('Explorar')),
      body: Column(children: [
        const Padding(padding: EdgeInsets.all(12), child: TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar gente o temas'))),
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 4, crossAxisSpacing: 4),
          itemCount: 18,
          itemBuilder: (_, i) => Container(
            color: C.card,
            alignment: Alignment.center,
            child: Text('#${tags[i % tags.length]}', style: const TextStyle(color: C.accent2, fontSize: 12)),
          ),
        )),
      ]),
    );
  }
}
