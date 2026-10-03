import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/sb.dart';
import '../services/upload_queue.dart';
import '../theme.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String kind = 'post';
  final caption = TextEditingController();
  XFile? file;
  bool busy = false;
  String? err;

  Future<void> _pick() async {
    final x = await ImagePicker().pickMedia();
    if (x != null) setState(() => file = x);
  }

  Future<void> _publish() async {
    final u = Sb.user;
    if (u == null) {
      setState(() => err = 'Entrá con tu cuenta para publicar');
      return;
    }
    if (file == null) {
      setState(() => err = 'Elegí una foto o un video');
      return;
    }
    final item = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'kind': kind,
      'caption': caption.text.trim(),
      'local_path': file!.path,
      'handle': 'vos',
      'status': 'uploading',
    };
    uploadQueue.enqueue(item);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final square = kind == 'post';
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(kind == 'post' ? 'Nueva publicación' : kind == 'story' ? 'Nueva historia' : 'Nuevo reel', style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: busy ? null : _publish,
            child: busy
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: C.blue))
                : const Text('Compartir', style: TextStyle(color: C.blue, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              for (final item in [('post', 'Publicación'), ('story', 'Historia'), ('reel', 'Reel')])
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => kind = item.$1),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: kind == item.$1 ? const Color(0xFF262626) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(item.$2, style: TextStyle(fontWeight: kind == item.$1 ? FontWeight.w700 : FontWeight.w500, color: kind == item.$1 ? Colors.white : C.muted)),
                    ),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _pick,
            child: AspectRatio(
              aspectRatio: square ? 1 : 9 / 14,
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFF121212), borderRadius: BorderRadius.circular(12), border: Border.all(color: C.line)),
                clipBehavior: Clip.antiAlias,
                child: file == null
                    ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.photo_library_outlined, size: 42, color: Colors.white),
                        SizedBox(height: 8),
                        Text('Elegí de la galería', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        Text('Foto o video', style: TextStyle(color: C.muted, fontSize: 13)),
                      ])
                    : Image.file(File(file!.path), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Center(child: Text(file!.name))),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: caption,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Escribí un pie de foto...',
              filled: true,
              fillColor: const Color(0xFF121212),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          if (err != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(err!, style: const TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
  }
}
