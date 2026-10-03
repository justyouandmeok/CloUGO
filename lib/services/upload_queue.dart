import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'sb.dart';

class UploadQueue extends ChangeNotifier {
  final List<Map<String, dynamic>> pending = [];

  void enqueue(Map<String, dynamic> item) {
    pending.insert(0, item);
    notifyListeners();
    unawaited(_upload(item));
  }

  Future<void> retry(String id) async {
    final item = pending.cast<Map<String, dynamic>?>().firstWhere((e) => e?['id'] == id, orElse: () => null);
    if (item == null) return;
    item['status'] = 'uploading';
    notifyListeners();
    await _upload(item);
  }

  Future<void> _upload(Map<String, dynamic> item) async {
    try {
      final u = Sb.user;
      if (u == null) throw Exception('sin sesion');
      final file = File(item['local_path'] as String);
      final ext = file.path.split('.').last;
      final path = '${u.id}/${item['id']}.$ext';
      await Sb.c.storage.from('media').upload(path, file);
      final url = Sb.c.storage.from('media').getPublicUrl(path);
      final profile = await Sb.c.from('profiles').select('handle').eq('id', u.id).maybeSingle();
      await Sb.c.from('posts').insert({
        'user_id': u.id,
        'handle': profile?['handle'] ?? item['handle'],
        'kind': item['kind'],
        'caption': item['caption'],
        'media_url': url,
      });
      pending.removeWhere((e) => e['id'] == item['id']);
      item['status'] = 'done';
      item['media_url'] = url;
      notifyListeners();
    } catch (e) {
      item['status'] = 'error';
      item['error'] = '$e';
      notifyListeners();
    }
  }
}

final uploadQueue = UploadQueue();
