import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/sb.dart';
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
      setState(() => err = 'Entrá con tu cuenta para publicar en la nube');
      return;
    }
    setState(() { busy = true; err = null; });
    try {
      String? url;
      if (file != null) {
        final ext = file!.path.split('.').last;
        final path = '${u.id}/${DateTime.now().millisecondsSinceEpoch}.$ext';
        await Sb.c.storage.from('media').upload(path, File(file!.path));
        url = Sb.c.storage.from('media').getPublicUrl(path);
      }
      final profile = await Sb.c.from('profiles').select('handle').eq('id', u.id).maybeSingle();
      await Sb.c.from('posts').insert({
        'user_id': u.id,
        'handle': profile?['handle'] ?? 'user',
        'kind': kind,
        'caption': caption.text.trim(),
        'media_url': url,
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => err = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva publicación'), actions: [
        TextButton(onPressed: busy ? null : _publish, child: busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Compartir')),
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'post', label: Text('Publicación')),
            ButtonSegment(value: 'story', label: Text('Historia')),
            ButtonSegment(value: 'reel', label: Text('Reel')),
          ],
          selected: {kind},
          onSelectionChanged: (v) => setState(() => kind = v.first),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: kind == 'post' ? 1 : 9 / 16,
          child: InkWell(
            onTap: _pick,
            child: Container(
              color: const Color(0xFF121212),
              alignment: Alignment.center,
              child: file == null ? const Text('Tocá para elegir foto o video', style: TextStyle(color: C.muted)) : Text(file!.name),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(controller: caption, maxLines: 3, decoration: const InputDecoration(hintText: 'Escribí un pie...')),
        if (err != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(err!, style: const TextStyle(color: Colors.redAccent))),
      ]),
    );
  }
}
