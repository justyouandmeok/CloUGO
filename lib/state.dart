import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAcc {
  final String user;
  final String name;
  final String pass;
  final String bio;
  UserAcc({required this.user, required this.name, required this.pass, this.bio = ''});
  Map<String, dynamic> toJson() => {'user': user, 'name': name, 'pass': pass, 'bio': bio};
  factory UserAcc.fromJson(Map<String, dynamic> j) => UserAcc(user: j['user'], name: j['name'], pass: j['pass'], bio: j['bio'] ?? '');
}

class Post {
  final String id;
  final String user;
  final String text;
  final int hue;
  int likes;
  final List<String> comments;
  Post({required this.id, required this.user, required this.text, required this.hue, this.likes = 0, List<String>? comments}) : comments = comments ?? [];
  Map<String, dynamic> toJson() => {'id': id, 'user': user, 'text': text, 'hue': hue, 'likes': likes, 'comments': comments};
  factory Post.fromJson(Map<String, dynamic> j) => Post(
        id: j['id'],
        user: j['user'],
        text: j['text'],
        hue: j['hue'],
        likes: j['likes'] ?? 0,
        comments: List<String>.from(j['comments'] ?? []),
      );
}

class AppState extends ChangeNotifier {
  UserAcc? me;
  List<UserAcc> users = [];
  List<Post> posts = [];
  Set<String> liked = {};
  Set<String> following = {};

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    users = (p.getStringList('users') ?? []).map((s) => UserAcc.fromJson(jsonDecode(s))).toList();
    posts = (p.getStringList('posts') ?? []).map((s) => Post.fromJson(jsonDecode(s))).toList();
    liked = (p.getStringList('liked') ?? []).toSet();
    following = (p.getStringList('following') ?? []).toSet();
    final cur = p.getString('me');
    if (cur != null) {
      me = users.cast<UserAcc?>().firstWhere((u) => u!.user == cur, orElse: () => null);
    }
    if (posts.isEmpty) {
      posts = [
        Post(id: '1', user: 'nube', text: 'Primer día en CloUGO. El cielo se ve distinto desde acá.', hue: 210, likes: 24, comments: ['bienvenido']),
        Post(id: '2', user: 'luma', text: 'Compartí una foto del atardecer. ¿Quién más está en Buenos Aires?', hue: 28, likes: 41),
        Post(id: '3', user: 'rio', text: 'Idea: una red donde el feed no premie solo a los que ya tienen seguidores.', hue: 160, likes: 18, comments: ['eso', 'dale']),
      ];
      users.addAll([
        UserAcc(user: 'nube', name: 'Nube', pass: '', bio: 'Cielo y código'),
        UserAcc(user: 'luma', name: 'Luma', pass: '', bio: 'Atardeceres'),
        UserAcc(user: 'rio', name: 'Río', pass: '', bio: 'Ideas sueltas'),
      ]);
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList('users', users.map((u) => jsonEncode(u.toJson())).toList());
    await p.setStringList('posts', posts.map((e) => jsonEncode(e.toJson())).toList());
    await p.setStringList('liked', liked.toList());
    await p.setStringList('following', following.toList());
    if (me != null) await p.setString('me', me!.user);
  }

  String? register(String user, String name, String pass) {
    user = user.trim().toLowerCase().replaceAll('@', '');
    if (user.length < 3) return 'Usuario muy corto';
    if (users.any((u) => u.user == user && u.pass.isNotEmpty)) return 'Ese usuario ya existe';
    users.removeWhere((u) => u.user == user);
    final acc = UserAcc(user: user, name: name.trim().isEmpty ? user : name.trim(), pass: pass, bio: 'Nuevo en CloUGO');
    users.insert(0, acc);
    me = acc;
    _save();
    notifyListeners();
    return null;
  }

  String? login(String user, String pass) {
    user = user.trim().toLowerCase().replaceAll('@', '');
    final acc = users.cast<UserAcc?>().firstWhere((u) => u!.user == user && u.pass == pass && u.pass.isNotEmpty, orElse: () => null);
    if (acc == null) return 'Usuario o contraseña incorrectos';
    me = acc;
    _save();
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    me = null;
    final p = await SharedPreferences.getInstance();
    await p.remove('me');
    notifyListeners();
  }

  void publish(String text) {
    if (me == null || text.trim().isEmpty) return;
    posts.insert(0, Post(id: DateTime.now().millisecondsSinceEpoch.toString(), user: me!.user, text: text.trim(), hue: text.hashCode % 360));
    _save();
    notifyListeners();
  }

  void toggleLike(Post post) {
    if (liked.contains(post.id)) {
      liked.remove(post.id);
      post.likes = (post.likes - 1).clamp(0, 1 << 30);
    } else {
      liked.add(post.id);
      post.likes++;
    }
    _save();
    notifyListeners();
  }

  void comment(Post post, String text) {
    if (text.trim().isEmpty || me == null) return;
    post.comments.add('${me!.user}: ${text.trim()}');
    _save();
    notifyListeners();
  }

  void toggleFollow(String user) {
    if (following.contains(user)) {
      following.remove(user);
    } else {
      following.add(user);
    }
    _save();
    notifyListeners();
  }

  void updateMe({String? name, String? bio}) {
    if (me == null) return;
    final n = UserAcc(user: me!.user, name: name ?? me!.name, pass: me!.pass, bio: bio ?? me!.bio);
    users = users.map((u) => u.user == n.user ? n : u).toList();
    me = n;
    _save();
    notifyListeners();
  }
}
