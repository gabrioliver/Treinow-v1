import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_nupe/screens/painel_profissional/perfil_profissional_screen.dart'; // ajuste o caminho conforme seu projeto

class BuscarProfissionalScreen extends StatefulWidget {
  const BuscarProfissionalScreen({super.key});

  @override
  State<BuscarProfissionalScreen> createState() => _BuscarProfissionalScreenState();
}

class _BuscarProfissionalScreenState extends State<BuscarProfissionalScreen> {
  String filtroTipo = 'Todos';
  String filtroModalidade = 'Todos';
  String buscaNome = '';
  bool apenasComHorarios = false;

  final List<String> tipos = ['Todos', 'personal', 'nutricionista', 'fisioterapeuta'];
  final List<String> modalidades = ['Todos', 'presencial', 'online'];

  void _limparFiltros() {
    setState(() {
      filtroTipo = 'Todos';
      filtroModalidade = 'Todos';
      buscaNome = '';
      apenasComHorarios = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Profissional")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nome',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  buscaNome = value.toLowerCase().trim();
                });
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: "Tipo de Profissional",
                    items: tipos,
                    value: filtroTipo,
                    onChanged: (value) {
                      if (value != null) setState(() => filtroTipo = value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    label: "Modalidade",
                    items: modalidades,
                    value: filtroModalidade,
                    onChanged: (value) {
                      if (value != null) setState(() => filtroModalidade = value);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text("Somente com horários"),
                    value: apenasComHorarios,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          apenasComHorarios = value;
                        });
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                TextButton.icon(
                  onPressed: _limparFiltros,
                  icon: const Icon(Icons.clear),
                  label: const Text("Limpar filtros"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildListaProfissionais()),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item[0].toUpperCase() + item.substring(1)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildListaProfissionais() {
    Query query = FirebaseFirestore.instance.collection('perfis_profissionais');

    if (filtroTipo != 'Todos') {
      query = query.where('tipo', isEqualTo: filtroTipo);
    }

    if (filtroModalidade != 'Todos') {
      query = query.where('modalidades', arrayContains: filtroModalidade);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Nenhum profissional encontrado."));
        }

        var docs = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where((data) {
          final nome = (data['nome'] ?? '').toString().toLowerCase();
          final atendeNome = nome.contains(buscaNome);
          final horarios = (data['agendaPresencial'] as List?) ?? [];
          final atendeHorario = !apenasComHorarios || horarios.isNotEmpty;
          return atendeNome && atendeHorario;
        })
            .toList();

        docs.sort((a, b) =>
            (a['nome'] ?? '').toString().compareTo((b['nome'] ?? '').toString()));

        if (docs.isEmpty) {
          return const Center(child: Text("Nenhum profissional encontrado com os critérios."));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index];
            final horarios = (data['agendaPresencial'] as List?)?.take(3).join(" • ") ?? '';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: data['fotoUrl'] != null
                      ? NetworkImage(data['fotoUrl'])
                      : const AssetImage('lib/assets/user_placeholder.png') as ImageProvider,
                ),
                title: Text(data['nome'] ?? 'Sem nome'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${data['tipo']}"),
                    if (horarios.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text("Presencial: $horarios"),
                      ),
                  ],
                ),
                onTap: () {
                  if (data['uid'] == null) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PerfilProfissionalScreen(uidProfissional: data['uid']),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
