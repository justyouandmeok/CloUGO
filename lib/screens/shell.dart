import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'create_page.dart';
import 'explore_page.dart';
import 'feed_page.dart';
import 'messages_page.dart';
import 'profile_page.dart';
import 'reels_page.dart';
import '../theme.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  static const icons = ['home', 'reels', 'messages', 'search', 'profile'];

  @override
  Widget build(BuildContext context) {
    const pages = [FeedPage(), ReelsPage(), MessagesPage(), ExplorePage(), ProfilePage()];
    return Scaffold(
      body: IndexedStack(index: i, children: pages),
      floatingActionButton: i == 0
          ? FloatingActionButton(backgroundColor: C.blue, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePage())), child: const Icon(Icons.add))
          : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.line, width: 0.4))),
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var n = 0; n < icons.length; n++)
              GestureDetector(
                onTap: () => setState(() => i = n),
                child: SvgPicture.asset(
                  'assets/nav/${icons[n]}.svg',
                  width: 26,
                  height: 26,
                  colorFilter: ColorFilter.mode(i == n ? Colors.white : const Color(0xFF8E8E8E), BlendMode.srcIn),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
