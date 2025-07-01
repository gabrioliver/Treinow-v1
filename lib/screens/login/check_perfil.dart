import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../painel_profissional/painel_profissional_screen.dart';
import '../painel_aluno/painel_aluno_screen.dart';
import 'criar_perfil_screen.dart';

class CheckPerfilScreen extends StatefulWidget {
  const CheckPerfilScreen({super.key});

  @override
  State<CheckPerfilScreen> createState() => _CheckPerfilScreenState();
}

class _CheckPerfilScreenState extends State<CheckPerfilScreen> {
  @override
  void initState() {
    super.initState();
    _verificarPerfil();
  }

  Future<void> _verificarPerfil() async {
    try {
      final usuarioAtual = FirebaseAuth.instance.currentUser;

      if (usuarioAtual == null) {
        Navigator.pushReplacementNamed(context, '/');
        return;
      }

      final docUsuario = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuarioAtual.uid)
          .get();

      final dados = docUsuario.data();
      final tipo = dados?['tipo'];

      if (tipo == 'profissional') {
        final perfilDoc = await FirebaseFirestore.instance
            .collection('perfis_profissionais')
            .doc(usuarioAtual.uid)
            .get();

        if (!perfilDoc.exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CriarPerfilScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PainelProfissionalScreen()),
          );
        }
      } else if (tipo == 'aluno') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PainelAlunoScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tipo de usuário desconhecido")),
        );
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao verificar perfil: $e")),
      );
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
