import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final t = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear'), actions: [
        TextButton(onPressed: () { context.read<AppState>().publish(t.text); Navigator.pop(context); }, child: const Text('Publicar')),
      ]),
      body: Padding(padding: const EdgeInsets.all(16), child: TextField(controller: t, maxLines: 8, decoration: const InputDecoration(hintText: '¿Qué está pasando en tu nube?'))),
    );
  }
}
