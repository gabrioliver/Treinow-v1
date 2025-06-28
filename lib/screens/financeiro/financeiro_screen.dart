import 'package:flutter/material.dart';

class FinanceiroScreen extends StatefulWidget {
  const FinanceiroScreen({super.key});

  @override
  State<FinanceiroScreen> createState() => _FinanceiroScreenState();
}

class _FinanceiroScreenState extends State<FinanceiroScreen> {
  final List<Map<String, dynamic>> alunos = [
    {'nome': 'João Silva', 'status': true},
    {'nome': 'Maria Oliveira', 'status': false},
    {'nome': 'Carlos Pereira', 'status': true},
  ];

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _abrirFormularioCobranca() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nova Cobrança'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do aluno'),
              ),
              TextField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor'),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Salvar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFinanceiroTab() {
    return ListView.builder(
      itemCount: alunos.length,
      itemBuilder: (context, index) {
        final aluno = alunos[index];
        return Card(
          child: ListTile(
            leading: Icon(Icons.circle,
                color: aluno['status'] ? Colors.green : Colors.red),
            title: Text(aluno['nome']),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // editar cobrança futuramente
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildReciboTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recibo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("Profissional: Karlla"),
          const SizedBox(height: 10),
          TextField(decoration: const InputDecoration(labelText: "Nome do paciente")),
          TextField(decoration: const InputDecoration(labelText: "Serviço prestado")),
          TextField(decoration: const InputDecoration(labelText: "Valor")),
          TextField(decoration: const InputDecoration(labelText: "Data")),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // ação de gerar recibo em PDF (em breve)
            },
            child: const Text("Gerar PDF"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Financeiro")),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildFinanceiroTab(),
          _buildReciboTab(),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _abrirFormularioCobranca,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Cobranças'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Recibos'),
        ],
      ),
    );
  }
}