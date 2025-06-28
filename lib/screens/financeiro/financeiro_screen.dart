import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinanceiroScreen extends StatefulWidget {
  const FinanceiroScreen({super.key});

  @override
  State<FinanceiroScreen> createState() => _FinanceiroScreenState();
}

class _FinanceiroScreenState extends State<FinanceiroScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> alunos = [
    {'nome': 'João Silva', 'status': true, 'vencimento': DateTime(2024, 6, 30), 'valor': 500.0},
    {'nome': 'Maria Oliveira', 'status': false, 'vencimento': DateTime(2024, 7, 5), 'valor': 300.0},
    {'nome': 'Carlos Pereira', 'status': false, 'vencimento': DateTime(2024, 7, 2), 'valor': 300.0},
  ];

  late TabController _tabController;
  int abaSelecionada = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        abaSelecionada = _tabController.index;
      });
    });
  }

  List<Map<String, dynamic>> get ativos => alunos.where((a) => a['status'] == true).toList();
  List<Map<String, dynamic>> get pendentes => alunos.where((a) => a['status'] == false).toList();
  List<Map<String, dynamic>> get vencimentoProximo => alunos.where((a) =>
      a['vencimento'] != null &&
      a['vencimento'].isBefore(DateTime.now().add(const Duration(days: 5)))).toList();

  double get valorAtivos => ativos.fold(0.0, (sum, a) => sum + (a['valor'] ?? 0.0));
  double get valorPendentes => pendentes.fold(0.0, (sum, a) => sum + (a['valor'] ?? 0.0));
  double get valorVencProx => vencimentoProximo.fold(0.0, (sum, a) => sum + (a['valor'] ?? 0.0));

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 50,
        startDegreeOffset: -90,
        borderData: FlBorderData(show: false),
        sections: [
          PieChartSectionData(
            value: valorAtivos,
            color: Colors.green.shade600,
            title: 'Ativos\nR\$ ${valorAtivos.toStringAsFixed(2)}',
            radius: 110,
            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            value: valorPendentes,
            color: Colors.red.shade400,
            title: 'Pendentes\nR\$ ${valorPendentes.toStringAsFixed(2)}',
            radius: 110,
            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            value: valorVencProx,
            color: Colors.orange.shade400,
            title: 'Venc. Próx.\nR\$ ${valorVencProx.toStringAsFixed(2)}',
            radius: 110,
            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _editarStatusPagamento(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar pagamento de \${alunos[index]['nome']}"),
          content: const Text("Deseja alterar o status de pagamento?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Alterar"),
              onPressed: () {
                setState(() {
                  alunos[index]['status'] = !alunos[index]['status'];
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlunoList(List<Map<String, dynamic>> lista) {
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final aluno = lista[index];
        final alunoIndex = alunos.indexOf(aluno);
        return Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.circle,
                color: aluno['status'] ? Colors.green : Colors.red),
            title: Text(aluno['nome']),
            subtitle: aluno['vencimento'] != null
                ? Text("Vencimento: ${aluno['vencimento'].day}/${aluno['vencimento'].month}")
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editarStatusPagamento(alunoIndex),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Financeiro"),
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_money),
            tooltip: 'Cobrança',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Recibo',
            onPressed: () {
              Navigator.pushNamed(context, '/recibo_completo');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Ativos"),
            Tab(text: "Pendentes"),
            Tab(text: "Próx. Vencimento"),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.group, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "Ativos: ${ativos.length} | Pendentes: ${pendentes.length} | Próx. Venc.: ${vencimentoProximo.length}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAlunoList(ativos),
                      _buildAlunoList(pendentes),
                      _buildAlunoList(vencimentoProximo),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: _buildPieChart(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
