import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastroAlunoScreen extends StatefulWidget {
  const CadastroAlunoScreen({super.key});

  @override
  State<CadastroAlunoScreen> createState() => _CadastroAlunoScreenState();
}

class _CadastroAlunoScreenState extends State<CadastroAlunoScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool salvando = false;

  Future<void> salvarAluno() async {
    setState(() => salvando = true);

    if (nomeController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      setState(() => salvando = false);
      return;
    }

    try {
      final uidProf = _auth.currentUser!.uid;
      await _firestore.collection('alunos').add({
        'nome': nomeController.text.trim(),
        'email': emailController.text.trim(),
        'uid_profissional': uidProf,
        'criado_em': Timestamp.now(),
      });

      Navigator.pop(context, true); // <- Confirma sucesso
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }

    setState(() => salvando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar Aluno")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome do aluno"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "E-mail do aluno"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            salvando
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: salvarAluno,
              child: const Text("Salvar aluno"),
            ),
          ],
        ),
      ),
    );
  }
}
