import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarPerfilProfissionalScreen extends StatefulWidget {
  final String uidProfissional;

  const EditarPerfilProfissionalScreen({super.key, required this.uidProfissional});

  @override
  State<EditarPerfilProfissionalScreen> createState() => _EditarPerfilProfissionalScreenState();
}

class _EditarPerfilProfissionalScreenState extends State<EditarPerfilProfissionalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController registroController = TextEditingController();
  final TextEditingController sobreController = TextEditingController();
  final TextEditingController novoHorarioController = TextEditingController();

  List<String> modalidades = [];
  List<String> horarios = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final doc = await FirebaseFirestore.instance
        .collection('perfis_profissionais')
        .doc(widget.uidProfissional)
        .get();

    final data = doc.data() ?? {};

    nomeController.text = data['nome'] ?? '';
    tipoController.text = data['tipo'] ?? '';
    registroController.text = data['registro'] ?? '';
    sobreController.text = data['sobre'] ?? '';
    modalidades = List<String>.from(data['modalidades'] ?? []);
    horarios = List<String>.from(data['agendaPresencial'] ?? []);

    setState(() => carregando = false);
  }

  Future<void> salvar() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('perfis_profissionais')
          .doc(widget.uidProfissional)
          .set({
        'nome': nomeController.text.trim(),
        'tipo': tipoController.text.trim(),
        'registro': registroController.text.trim(),
        'sobre': sobreController.text.trim(),
        'modalidades': modalidades,
        'agendaPresencial': horarios,
      }, SetOptions(merge: true));

      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  void toggleModalidade(String valor) {
    setState(() {
      if (modalidades.contains(valor)) {
        modalidades.remove(valor);
      } else {
        modalidades.add(valor);
      }
    });
  }

  void adicionarHorario() {
    final novo = novoHorarioController.text.trim();
    if (novo.isNotEmpty && !horarios.contains(novo)) {
      setState(() {
        horarios.add(novo);
        novoHorarioController.clear();
      });
    }
  }

  void removerHorario(String horario) {
    setState(() {
      horarios.remove(horario);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
                validator: (value) => value!.isEmpty ? "Informe o nome" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: tipoController,
                decoration: const InputDecoration(labelText: "Tipo de profissional"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: registroController,
                decoration: const InputDecoration(labelText: "CRN ou outro registro"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: sobreController,
                decoration: const InputDecoration(labelText: "Sobre"),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Modalidades de atendimento:", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              CheckboxListTile(
                title: const Text("Presencial"),
                value: modalidades.contains("presencial"),
                onChanged: (_) => toggleModalidade("presencial"),
              ),
              CheckboxListTile(
                title: const Text("Online"),
                value: modalidades.contains("online"),
                onChanged: (_) => toggleModalidade("online"),
              ),
              const SizedBox(height: 20),
              if (modalidades.contains("presencial")) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Horários presenciais:", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: novoHorarioController,
                        decoration: const InputDecoration(labelText: "Novo horário (ex: Seg 09:00)"),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: adicionarHorario,
                    )
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: horarios.map((h) {
                    return Chip(
                      label: Text(h),
                      onDeleted: () => removerHorario(h),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: salvar,
                child: const Text("Salvar alterações"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
