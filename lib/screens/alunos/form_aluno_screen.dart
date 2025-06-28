// tela para adicionar ou editar aluno
import 'package:flutter/material.dart';

class FormAlunoScreen extends StatefulWidget {
  final Map<String, dynamic>? alunoExistente;

  const FormAlunoScreen({super.key, this.alunoExistente});

  @override
  State<FormAlunoScreen> createState() => _FormAlunoScreenState();
}

class _FormAlunoScreenState extends State<FormAlunoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _idadeController;
  bool _ativo = true;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.alunoExistente?["nome"] ?? "");
    _idadeController = TextEditingController(text: widget.alunoExistente?["idade"]?.toString() ?? "");
    _ativo = widget.alunoExistente?["ativo"] ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    super.dispose();
  }

  void _salvarAluno() {
    if (_formKey.currentState!.validate()) {
      final novoAluno = {
        "nome": _nomeController.text.trim(),
        "idade": int.tryParse(_idadeController.text.trim()) ?? 0,
        "ativo": _ativo,
      };

      Navigator.pop(context, novoAluno); // retorna aluno para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    final ehEdicao = widget.alunoExistente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(ehEdicao ? 'Editar Aluno' : 'Novo Aluno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do aluno'),
                validator: (value) => value == null || value.isEmpty ? 'Digite um nome' : null,
              ),
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null ? 'Digite uma idade válida' : null,
              ),
              SwitchListTile(
                title: const Text("Ativo"),
                value: _ativo,
                onChanged: (value) => setState(() => _ativo = value),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(ehEdicao ? 'Atualizar' : 'Adicionar'),
                onPressed: _salvarAluno,
              )
            ],
          ),
        ),
      ),
    );
  }
}
