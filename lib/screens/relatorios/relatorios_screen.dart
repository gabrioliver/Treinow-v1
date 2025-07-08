// Tela baseada na imagem enviada e com as funcionalidades solicitadas para os relatórios
import 'package:flutter/material.dart';

class RelatoriosScreen extends StatefulWidget {
  const RelatoriosScreen({super.key});

  @override
  State<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends State<RelatoriosScreen> {
  String abaSelecionada = 'Todos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _filtro('Todos'),
                _filtro('Alunos'),
                _filtro('Financeiro'),
                _filtro('Treinos'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildConteudo(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filtro(String nome) {
    final selecionado = abaSelecionada == nome;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ChoiceChip(
        label: Text(nome),
        selected: selecionado,
        onSelected: (_) => setState(() => abaSelecionada = nome),
        selectedColor: Colors.teal.shade300,
        labelStyle: TextStyle(color: selecionado ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildConteudo() {
    switch (abaSelecionada) {
      case 'Alunos':
        return _relatorioAlunos();
      case 'Financeiro':
        return _relatorioFinanceiro();
      case 'Treinos':
        return _relatorioTreinos();
      case 'Todos':
      default:
        return _relatorioGeral();
    }
  }

  Widget _relatorioGeral() {
    return ListView(
      children: [
        _cardRelatorio(Icons.group, 'Total de Alunos Ativos', '24'),
        _cardRelatorio(Icons.attach_money, 'Receita do Mês', 'R\$ 3.200'),
        _cardRelatorio(Icons.bar_chart, 'Avaliações Realizadas', '15'),
        _cardRelatorio(Icons.fitness_center, 'Adesões a Treinos', '12'),
      ],
    );
  }

  Widget _relatorioAlunos() {
    return ListView(
      children: [
        _cardAlunoComGrafico('João Silva', 70, 80),
        _cardAlunoComGrafico('Maria Souza', 60, 75),
      ],
    );
  }

  Widget _relatorioFinanceiro() {
    return ListView(
      children: [
        _cardRelatorio(Icons.attach_money, 'Pagamentos realizados', 'R\$ 2.400'),
        _cardRelatorio(Icons.warning, 'Pagamentos pendentes', 'R\$ 800'),
      ],
    );
  }

  Widget _relatorioTreinos() {
    return ListView(
      children: [
        _cardTreino('João Silva', 'Treino A - Peito e Tríceps', true),
        _cardTreino('Maria Souza', 'Treino B - Pernas', false),
      ],
    );
  }

  Widget _cardRelatorio(IconData icone, String titulo, String valor) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icone, size: 32, color: Colors.blueAccent),
        title: Text(titulo),
        subtitle: const Text('Atualizado hoje'),
        trailing: Text(valor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _cardAlunoComGrafico(String nome, int pesoAtual, int metaPeso) {
    final progresso = pesoAtual / metaPeso;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Meta de peso'),
            LinearProgressIndicator(
              value: progresso > 1 ? 1 : progresso,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            const SizedBox(height: 6),
            Text('Peso: $pesoAtual kg / Meta: $metaPeso kg'),
          ],
        ),
      ),
    );
  }

  Widget _cardTreino(String nome, String treino, bool compareceu) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(compareceu ? Icons.check_circle : Icons.cancel, color: compareceu ? Colors.green : Colors.red),
        title: Text(nome),
        subtitle: Text(treino),
        trailing: Text(compareceu ? 'Compareceu' : 'Faltou', style: TextStyle(color: compareceu ? Colors.green : Colors.red)),
      ),
    );
  }
}
