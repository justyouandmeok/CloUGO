import 'package:flutter/material.dart';
import '../services/sb.dart';
import '../theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes', style: TextStyle(fontWeight: FontWeight.w700))),
      body: ListView(children: [
        const _Head('Cuenta'),
        _tile(Icons.person_outline, 'Editar perfil', 'Nombre, usuario y bio'),
        _tile(Icons.lock_outline, 'Contraseña y seguridad', 'Sesión y acceso'),
        _tile(Icons.alternate_email, 'Usuario', 'Tu @ público'),
        const _Head('Privacidad'),
        _tile(Icons.visibility_outlined, 'Privacidad de la cuenta', 'Pública o privada'),
        _tile(Icons.chat_bubble_outline, 'Mensajes', 'Quién puede escribirte'),
        _tile(Icons.block, 'Bloqueados', 'Cuentas que no ves'),
        const _Head('Datos y calidad'),
        _tile(Icons.data_usage, 'Uso de datos', 'Alta calidad o ahorro'),
        _tile(Icons.hd_outlined, 'Calidad de subida', 'Fotos y videos'),
        _tile(Icons.download_outlined, 'Descargas', 'Guardar en el teléfono'),
        const _Head('Notificaciones'),
        _tile(Icons.notifications_none, 'Notificaciones', 'Me gusta, comentarios y seguidores'),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: OutlinedButton(
            onPressed: () async {
              await Sb.c.auth.signOut();
              if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SizedBox()), (_) => false);
            },
            style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent), minimumSize: const Size.fromHeight(48)),
            child: const Text('Cerrar sesión'),
          ),
        ),
      ]),
    );
  }

  Widget _tile(IconData icon, String title, String sub) => ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(title),
    subtitle: Text(sub, style: const TextStyle(color: C.muted, fontSize: 12)),
    trailing: const Icon(Icons.chevron_right, color: C.muted),
    onTap: () {},
  );
}

class _Head extends StatelessWidget {
  const _Head(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
  );
}
