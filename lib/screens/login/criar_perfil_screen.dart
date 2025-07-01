import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CriarPerfilScreen extends StatefulWidget {
  const CriarPerfilScreen({super.key});

  @override
  State<CriarPerfilScreen> createState() => _CriarPerfilScreenState();
}

class _CriarPerfilScreenState extends State<CriarPerfilScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sobreController = TextEditingController();
  final Map<String, TextEditingController> _conselhos = {
    'personal': TextEditingController(),
    'nutricionista': TextEditingController(),
    'fisioterapeuta': TextEditingController(),
  };

  final List<String> _profissoesSelecionadas = [];
  final List<String> _modalidades = [];
  final List<String> _horarios = [];
  final TextEditingController _novoHorarioController = TextEditingController();

  bool carregando = false;

  @override
  void initState() {
    super.initState();
    carregarDadosIniciais();
  }

  Future<void> carregarDadosIniciais() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        _nomeController.text = data['nome'] ?? '';
        _emailController.text = data['email'] ?? '';
      }
    }
  }

  Future<void> salvarPerfil() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (_profissoesSelecionadas.isEmpty ||
        _modalidades.isEmpty ||
        _nomeController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos obrigatórios.")),
      );
      return;
    }

    for (final prof in _profissoesSelecionadas) {
      if (_conselhos[prof]!.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Informe o número do conselho para ${_nomeConselho(prof)}")),
        );
        return;
      }
    }

    try {
      setState(() => carregando = true);

      await FirebaseFirestore.instance.collection('perfis_profissionais').doc(uid).set({
        'uid': uid,
        'nome': _nomeController.text.trim(),
        'email': _emailController.text.trim(),
        'profissoes': _profissoesSelecionadas,
        'registroConselho': {
          for (final prof in _profissoesSelecionadas)
            prof: _conselhos[prof]!.text.trim(),
        },
        'sobre': _sobreController.text.trim(),
        'modalidades': _modalidades,
        'agendaPresencial': _modalidades.contains('presencial') ? _horarios : [],
        'fotoUrl': null,
        'criadoEm': Timestamp.now(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil criado com sucesso!')),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/painel', (_) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar perfil: $e')),
      );
    } finally {
      setState(() => carregando = false);
    }
  }

  String _nomeConselho(String profissao) {
    switch (profissao.toLowerCase()) {
      case 'personal':
        return 'CREF';
      case 'nutricionista':
        return 'CRN';
      case 'fisioterapeuta':
        return 'CREFITO';
      default:
        return profissao.toUpperCase();
    }
  }

  Widget _buildCheckboxList(String title, List<String> options, List<String> selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((opt) {
        return CheckboxListTile(
          title: Text(opt[0].toUpperCase() + opt.substring(1)),
          value: selected.contains(opt),
          onChanged: (val) {
            setState(() {
              if (val == true) {
                selected.add(opt);
              } else {
                selected.remove(opt);
              }
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Perfil Profissional")),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 20),
            const Text("Profissões (selecione ao menos uma):", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildCheckboxList('Profissões', ['personal', 'nutricionista', 'fisioterapeuta'], _profissoesSelecionadas),
            ..._profissoesSelecionadas.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: _conselhos[p],
                decoration: InputDecoration(
                  labelText: 'Número do conselho (${_nomeConselho(p)})',
                ),
              ),
            )),
            const SizedBox(height: 20),
            TextField(
              controller: _sobreController,
              decoration: const InputDecoration(labelText: 'Sobre você'),
              maxLength: 200,
            ),
            const SizedBox(height: 12),
            const Text("Modalidade de atendimento:"),
            _buildCheckboxList('Modalidades', ['presencial', 'online'], _modalidades),
            const SizedBox(height: 12),
            if (_modalidades.contains('presencial')) ...[
              const Text("Horários disponíveis (Presencial):"),
              Wrap(
                spacing: 8,
                children: _horarios
                    .map((h) => Chip(
                  label: Text(h),
                  onDeleted: () => setState(() => _horarios.remove(h)),
                ))
                    .toList(),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _novoHorarioController,
                      decoration: const InputDecoration(hintText: 'Ex: Segunda 08:00'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final texto = _novoHorarioController.text.trim();
                      if (texto.isNotEmpty) {
                        setState(() {
                          _horarios.add(texto);
                          _novoHorarioController.clear();
                        });
                      }
                    },
                  )
                ],
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: salvarPerfil,
              child: const Text("Salvar perfil"),
            ),
          ],
        ),
      ),
    );
  }
}
