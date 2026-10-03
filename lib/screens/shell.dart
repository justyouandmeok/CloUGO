import 'package:flutter/material.dart';
import 'create_page.dart';
import 'explore_page.dart';
import 'feed_page.dart';
import 'messages_page.dart';
import 'profile_page.dart';
import '../theme.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    const pages = [FeedPage(), ExplorePage(), MessagesPage(), ProfilePage()];
    return Scaffold(
      body: IndexedStack(index: i, children: pages),
      floatingActionButton: i == 0
          ? FloatingActionButton(backgroundColor: C.accent, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePage())), child: const Icon(Icons.add))
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: i,
        onDestinationSelected: (v) => setState(() => i = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Explorar'),
          NavigationDestination(icon: Icon(Icons.send_outlined), selectedIcon: Icon(Icons.send), label: 'Mensajes'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
