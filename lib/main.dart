import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return me == null ? const AuthScreen() : const Shell();
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final user = TextEditingController();
  final name = TextEditingController();
  final pass = TextEditingController();
  bool reg = true;
  String? err;

  @override
  Widget build(BuildContext context) {
    final st = context.read<AppState>();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 36),
            const Text('CloUGO', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: C.accent)),
            const SizedBox(height: 8),
            const Text('Una red para compartir, no para desaparecer.', style: TextStyle(color: C.muted)),
            const SizedBox(height: 28),
            if (reg) _field(name, 'Nombre'),
            _field(user, 'Usuario'),
            _field(pass, 'Contraseña', obscure: true),
            if (err != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(err!, style: const TextStyle(color: Colors.redAccent))),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final e = reg ? st.register(user.text, name.text, pass.text) : st.login(user.text, pass.text);
                setState(() => err = e);
              },
              child: Text(reg ? 'Crear cuenta' : 'Entrar'),
            ),
            TextButton(onPressed: () => setState(() => reg = !reg), child: Text(reg ? 'Ya tengo cuenta' : 'Crear cuenta')),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(labelText: label, filled: true, fillColor: C.card, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
      ),
    );
  }
}
