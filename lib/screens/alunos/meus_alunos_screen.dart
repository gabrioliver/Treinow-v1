import 'package:flutter/material.dart';

class MeusAlunosScreen extends StatelessWidget {
  const MeusAlunosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A lista deve estar dentro do build ou ser passada por construtor (aqui simplificado)
    final List<Map<String, dynamic>> alunos = [
      {
        "nome": "João Silva",
        "idade": 28,
        "ativo": true,
      },
      {
        "nome": "Maria Oliveira",
        "idade": 34,
        "ativo": false,
      },
      {
        "nome": "Pedro Lima",
        "idade": 21,
        "ativo": true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Alunos'),
      ),
      body: ListView.builder(
        itemCount: alunos.length,
        itemBuilder: (context, index) {
          final aluno = alunos[index];
          return _buildAlunoCard(aluno, context);
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
          backgroundColor: aluno["ativo"] ? Colors.green : Colors.red,
        ),
        title: Text(aluno["nome"]),
        subtitle: Text("Idade: ${aluno["idade"]}"),
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
