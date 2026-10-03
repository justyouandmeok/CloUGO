import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../theme.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear'), actions: [
        TextButton(
          onPressed: () {
            context.read<AppState>().publish(text.text);
            text.clear();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicado en el inicio')));
          },
          child: const Text('Publicar'),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: text,
          maxLines: 8,
          decoration: InputDecoration(hintText: '¿Qué querés compartir?', filled: true, fillColor: C.card, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
        ),
      ),
    );
  }
}
