import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MeusAlunosScreen extends StatelessWidget {
  const MeusAlunosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado')),
      );
    }

    final alunosRef = FirebaseFirestore.instance
        .collection('alunos')
        .where('uid_profissional', isEqualTo: uid)
        .orderBy('dataCadastro', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Alunos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: alunosRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum aluno cadastrado.'));
          }

          final alunos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: alunos.length,
            itemBuilder: (context, index) {
              final doc = alunos[index];
              final aluno = doc.data() as Map<String, dynamic>;
              return _buildAlunoCard(aluno, context);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar aluno',
      ),
    );
  }

  Widget _buildAlunoCard(Map<String, dynamic> aluno, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          radius: 8,
          backgroundColor: Colors.blue,
        ),
        title: Text(aluno["nome"] ?? 'Sem nome'),
        subtitle: Text("Idade: ${aluno["idade"] ?? '-'}"),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility),
              tooltip: "Ver detalhes",
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/detalhes_aluno',
                  arguments: aluno,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Editar aluno",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Editar aluno em construção')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
