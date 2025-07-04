import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'editar_perfil_profissional_screen.dart';



class PerfilProfissionalScreen extends StatefulWidget {
  final String uidProfissional;

  const PerfilProfissionalScreen({super.key, required this.uidProfissional});

  @override
  State<PerfilProfissionalScreen> createState() => _PerfilProfissionalScreenState();
}

class _PerfilProfissionalScreenState extends State<PerfilProfissionalScreen> {
  Map<String, dynamic>? perfil;
  bool isDonoDoPerfil = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarPerfil();
  }

  Future<void> carregarPerfil() async {
    final doc = await FirebaseFirestore.instance
        .collection('perfis_profissionais')
        .doc(widget.uidProfissional)
        .get();

    final usuarioAtual = FirebaseAuth.instance.currentUser;

    setState(() {
      perfil = doc.data();
      isDonoDoPerfil = usuarioAtual?.uid == widget.uidProfissional;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (perfil == null) {
      return const Scaffold(
        body: Center(child: Text("Perfil não encontrado.")),
      );
    }

    final nome = perfil!['nome'] ?? '';
    final tipo = perfil!['tipo'] ?? '';
    final registro = perfil!['registro'] ?? '';
    final sobre = perfil!['sobre'] ?? '';
    final fotoUrl = perfil!['fotoUrl'];
    final modalidades = List<String>.from(perfil!['modalidades'] ?? []);
    final horarios = List<String>.from(perfil!['agendaPresencial'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(nome),
        actions: [
          if (isDonoDoPerfil)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditarPerfilProfissionalScreen(uidProfissional: widget.uidProfissional),
                  ),
                );
              },
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: fotoUrl != null
                  ? NetworkImage(fotoUrl)
                  : const AssetImage('lib/assets/user_placeholder.png') as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(nome, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(tipo, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            if (registro.isNotEmpty) Text("Registro: $registro"),
            const SizedBox(height: 16),
            if (sobre.isNotEmpty)
              Text(
                sobre,
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: modalidades.map((m) {
                return Chip(
                  label: Text(m.toUpperCase()),
                  backgroundColor: m == 'presencial' ? Colors.blue[50] : Colors.green[50],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (modalidades.contains('presencial') && horarios.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Horários disponíveis (presencial):",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: horarios.map((h) => Chip(label: Text(h))).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
