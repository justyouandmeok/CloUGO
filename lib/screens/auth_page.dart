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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(children: [
            const Spacer(),
            const Text('CloUGO', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, letterSpacing: -1)),
            const SizedBox(height: 28),
            if (reg) _f(name, 'Nombre'),
            if (reg) _f(handle, 'Usuario'),
            _f(email, 'Correo'),
            _f(pass, 'Contraseña', obscure: true),
            if (err != null) Text(err!, style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: C.accent, minimumSize: const Size.fromHeight(44)),
              onPressed: () {
                final s = context.read<AppState>();
                setState(() => err = reg ? s.register(name.text, email.text, pass.text, handle.text) : s.login(email.text, pass.text));
              },
              child: Text(reg ? 'Registrarte' : 'Iniciar sesión'),
            )),
            const Spacer(),
            TextButton(onPressed: () => setState(() { reg = !reg; err = null; }), child: Text(reg ? '¿Ya tenés cuenta? Iniciá sesión' : '¿No tenés cuenta? Registrate', style: const TextStyle(color: C.accent))),
            const SizedBox(height: 12),
          ]),
        ),
      ),
    );
  }

  Widget _f(TextEditingController c, String h, {bool obscure = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextField(controller: c, obscureText: obscure, decoration: InputDecoration(hintText: h, filled: true, fillColor: const Color(0xFF121212), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: C.line)))),
  );
}
