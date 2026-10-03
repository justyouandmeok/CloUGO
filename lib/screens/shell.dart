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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.line, width: 0.5))),
        child: NavigationBar(
          height: 52,
          backgroundColor: C.bg,
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: i >= 2 ? i + 1 : i,
          onDestinationSelected: (v) {
            if (v == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePage()));
              return;
            }
            setState(() => i = v > 2 ? v - 1 : v);
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
            NavigationDestination(icon: Icon(Icons.search), selectedIcon: Icon(Icons.search, weight: 700), label: 'Buscar'),
            NavigationDestination(icon: Icon(Icons.add_box_outlined), selectedIcon: Icon(Icons.add_box), label: 'Crear'),
            NavigationDestination(icon: Icon(Icons.send_outlined), selectedIcon: Icon(Icons.send), label: 'Mensajes'),
            NavigationDestination(icon: Icon(Icons.account_circle_outlined), selectedIcon: Icon(Icons.account_circle), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
