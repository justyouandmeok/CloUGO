import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAcc {
  String email;
  String password;
  String name;
  String handle;
  String bio;
  UserAcc({required this.email, required this.password, required this.name, required this.handle, this.bio = ''});
  Map<String, dynamic> toJson() => {'email': email, 'password': password, 'name': name, 'handle': handle, 'bio': bio};
  factory UserAcc.fromJson(Map<String, dynamic> j) => UserAcc(email: j['email'], password: j['password'], name: j['name'], handle: j['handle'], bio: j['bio'] ?? '');
}

class Post {
  final String id;
  final String author;
  final String handle;
  String text;
  int likes;
  bool liked;
  final List<String> comments;
  final DateTime at;
  Post({required this.id, required this.author, required this.handle, required this.text, this.likes = 0, this.liked = false, List<String>? comments, DateTime? at})
      : comments = comments ?? [],
        at = at ?? DateTime.now();
  Map<String, dynamic> toJson() => {
        'id': id, 'author': author, 'handle': handle, 'text': text, 'likes': likes, 'liked': liked, 'comments': comments, 'at': at.toIso8601String()
      };
  factory Post.fromJson(Map<String, dynamic> j) => Post(
        id: j['id'], author: j['author'], handle: j['handle'], text: j['text'], likes: j['likes'] ?? 0, liked: j['liked'] ?? false,
        comments: List<String>.from(j['comments'] ?? []), at: DateTime.tryParse(j['at'] ?? '') ?? DateTime.now());
}

class ChatMsg {
  final String from;
  final String text;
  final DateTime at;
  ChatMsg(this.from, this.text, this.at);
  Map<String, dynamic> toJson() => {'from': from, 'text': text, 'at': at.toIso8601String()};
  factory ChatMsg.fromJson(Map<String, dynamic> j) => ChatMsg(j['from'], j['text'], DateTime.parse(j['at']));
}

class AppState extends ChangeNotifier {
  List<UserAcc> users = [];
  UserAcc? me;
  List<Post> posts = [];
  Map<String, List<ChatMsg>> chats = {};
  final Set<String> following = {};

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    users = (jsonDecode(p.getString('cu_users') ?? '[]') as List).map((e) => UserAcc.fromJson(e)).toList();
    posts = (jsonDecode(p.getString('cu_posts') ?? '[]') as List).map((e) => Post.fromJson(e)).toList();
    final rawChats = jsonDecode(p.getString('cu_chats') ?? '{}') as Map<String, dynamic>;
    chats = rawChats.map((k, v) => MapEntry(k, (v as List).map((e) => ChatMsg.fromJson(e)).toList()));
    following.addAll(p.getStringList('cu_follow') ?? []);
    final mail = p.getString('cu_me');
    if (mail != null) me = users.cast<UserAcc?>().firstWhere((u) => u!.email == mail, orElse: () => null);
    if (posts.isEmpty) {
      posts = [
        Post(id: '1', author: 'CloUGO', handle: 'clougo', text: 'Bienvenido a CloUGO. Publicá, seguí y chateá.', likes: 12),
        Post(id: '2', author: 'Nube', handle: 'nube', text: 'Primera nube en la red.', likes: 4),
      ];
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('cu_users', jsonEncode(users.map((e) => e.toJson()).toList()));
    await p.setString('cu_posts', jsonEncode(posts.map((e) => e.toJson()).toList()));
    await p.setString('cu_chats', jsonEncode(chats.map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()))));
    await p.setStringList('cu_follow', following.toList());
    if (me != null) await p.setString('cu_me', me!.email);
  }

  String? register(String name, String email, String pass, String handle) {
    email = email.trim().toLowerCase();
    handle = handle.trim().toLowerCase().replaceAll('@', '');
    if (name.isEmpty || email.isEmpty || pass.length < 4 || handle.isEmpty) return 'Completá todos los campos (clave de 4+)';
    if (users.any((u) => u.email == email)) return 'Ese mail ya existe';
    if (users.any((u) => u.handle == handle)) return 'Ese usuario ya existe';
    final u = UserAcc(email: email, password: pass, name: name, handle: handle);
    users.add(u);
    me = u;
    _save();
    notifyListeners();
    return null;
  }

  String? login(String email, String pass) {
    email = email.trim().toLowerCase();
    final u = users.cast<UserAcc?>().firstWhere((x) => x!.email == email, orElse: () => null);
    if (u == null || u.password != pass) return 'Mail o clave incorrectos';
    me = u;
    _save();
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    me = null;
    final p = await SharedPreferences.getInstance();
    await p.remove('cu_me');
    notifyListeners();
  }

  void publish(String text) {
    if (me == null || text.trim().isEmpty) return;
    posts.insert(0, Post(id: DateTime.now().millisecondsSinceEpoch.toString(), author: me!.name, handle: me!.handle, text: text.trim()));
    _save();
    notifyListeners();
  }

  void toggleLike(Post post) {
    post.liked = !post.liked;
    post.likes += post.liked ? 1 : -1;
    _save();
    notifyListeners();
  }

  void comment(Post post, String text) {
    if (text.trim().isEmpty || me == null) return;
    post.comments.add('${me!.handle}: ${text.trim()}');
    _save();
    notifyListeners();
  }

  void toggleFollow(String handle) {
    if (following.contains(handle)) {
      following.remove(handle);
    } else {
      following.add(handle);
    }
    _save();
    notifyListeners();
  }

  void send(String handle, String text) {
    if (me == null || text.trim().isEmpty) return;
    chats.putIfAbsent(handle, () => []);
    chats[handle]!.add(ChatMsg(me!.handle, text.trim(), DateTime.now()));
    _save();
    notifyListeners();
  }

  void saveProfile(String name, String bio) {
    if (me == null) return;
    me!.name = name.trim().isEmpty ? me!.name : name.trim();
    me!.bio = bio.trim();
    _save();
    notifyListeners();
  }
}
