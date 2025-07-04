import 'package:flutter/material.dart';

class DetalhesAlunoScreen extends StatelessWidget {
  final Map<String, dynamic> aluno;

  const DetalhesAlunoScreen({super.key, required this.aluno});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Aluno"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              aluno["nome"],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Idade: ${aluno["idade"]}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Status: ", style: TextStyle(fontSize: 18)),
                Icon(
                  Icons.circle,
                  color: aluno["ativo"] ? Colors.green : Colors.red,
                  size: 14,
                ),
                const SizedBox(width: 5),
                Text(
                  aluno["ativo"] ? "Ativo" : "Inativo",
                  style: TextStyle(fontSize: 18, color: aluno["ativo"] ? Colors.green : Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Mais informações poderão ser adicionadas aqui futuramente.",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
