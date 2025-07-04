import 'package:flutter/material.dart';

class ReciboCompletoScreen extends StatefulWidget {
  const ReciboCompletoScreen({super.key});

  @override
  State<ReciboCompletoScreen> createState() => _ReciboCompletoScreenState();
}

class _ReciboCompletoScreenState extends State<ReciboCompletoScreen> {
  final TextEditingController _nomeAluno = TextEditingController();
  final TextEditingController _descricaoServico = TextEditingController();
  final TextEditingController _valor = TextEditingController();
  final TextEditingController _data = TextEditingController();
  final TextEditingController _profissionalNome = TextEditingController(text: "Karlla");
  final TextEditingController _profissionalCpf = TextEditingController();

  void _salvarModelo() {
    // Aqui você pode salvar o modelo localmente com shared_preferences ou outro método.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Modelo salvo com sucesso.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recibo Completo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Salvar modelo",
            onPressed: _salvarModelo,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Informações do Aluno", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: _nomeAluno,
                decoration: const InputDecoration(labelText: "Nome do aluno/paciente"),
              ),
              TextField(
                controller: _descricaoServico,
                decoration: const InputDecoration(labelText: "Descrição do serviço realizado"),
              ),
              TextField(
                controller: _valor,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Valor"),
              ),
              TextField(
                controller: _data,
                decoration: const InputDecoration(labelText: "Data"),
              ),
              const SizedBox(height: 20),
              const Text("Profissional", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: _profissionalNome,
                decoration: const InputDecoration(labelText: "Nome do profissional"),
              ),
              TextField(
                controller: _profissionalCpf,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "CPF do profissional"),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // Em breve: gerar PDF
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Função de PDF em breve.")),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Gerar PDF"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
