import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth_page.dart';
import 'screens/shell.dart';
import 'state.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CloUGOApp());
}

class CloUGOApp extends StatefulWidget {
  const CloUGOApp({super.key});
  @override
  State<CloUGOApp> createState() => _CloUGOAppState();
}

class _CloUGOAppState extends State<CloUGOApp> {
  final state = AppState();
  @override
  void initState() {
    super.initState();
    state.load();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CloUGO',
        theme: clougoTheme(),
        home: const Gate(),
      ),
    );
  }
}

class Gate extends StatelessWidget {
  const Gate({super.key});
  @override
  Widget build(BuildContext context) {
    final me = context.watch<AppState>().me;
    return me == null ? const AuthPage() : const Shell();
  }
}
