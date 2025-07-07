import 'package:flutter/material.dart';

class RelatoriosScreen extends StatelessWidget {
  const RelatoriosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatórios"),
        backgroundColor: const Color(0xFF0077B6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filtros rápidos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _filterChip("Todos"),
                _filterChip("Alunos"),
                _filterChip("Financeiro"),
                _filterChip("Treinos"),
              ],
            ),
            const SizedBox(height: 20),

            // Cards resumidos
            Expanded(
              child: ListView(
                children: [
                  _reportCard(
                    title: "Total de Alunos Ativos",
                    value: "24",
                    icon: Icons.group,
                    color: Colors.blue,
                  ),
                  _reportCard(
                    title: "Receita do Mês",
                    value: "R\$ 3.200",
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                  _reportCard(
                    title: "Avaliações Realizadas",
                    value: "15",
                    icon: Icons.bar_chart,
                    color: Colors.orange,
                  ),
                  _reportCard(
                    title: "Adesões a Treinos",
                    value: "12",
                    icon: Icons.fitness_center,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label) {
    return FilterChip(
      label: Text(label),
      onSelected: (_) {},
      selected: label == "Todos",
      selectedColor: const Color(0xFF5DE6DE),
    );
  }

  Widget _reportCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text("Atualizado hoje"),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
