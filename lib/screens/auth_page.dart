import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../theme.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool reg = false;
  final name = TextEditingController();
  final handle = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  String? err;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 36),
            const Text('CloUGO', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: C.accent)),
            const Text('Tu nube social', style: TextStyle(color: C.muted)),
            const SizedBox(height: 28),
            if (reg) TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre')),
            if (reg) const SizedBox(height: 10),
            if (reg) TextField(controller: handle, decoration: const InputDecoration(labelText: 'Usuario')),
            if (reg) const SizedBox(height: 10),
            TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Mail')),
            const SizedBox(height: 10),
            TextField(controller: pass, obscureText: true, decoration: const InputDecoration(labelText: 'Clave')),
            if (err != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(err!, style: const TextStyle(color: Colors.redAccent))),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                final s = context.read<AppState>();
                setState(() {
                  err = reg
                      ? s.register(name.text, email.text, pass.text, handle.text)
                      : s.login(email.text, pass.text);
                });
              },
              child: Text(reg ? 'Crear cuenta' : 'Entrar'),
            ),
            TextButton(onPressed: () => setState(() { reg = !reg; err = null; }), child: Text(reg ? 'Ya tengo cuenta' : 'Crear cuenta')),
          ],
        ),
      ),
    );
  }
}
