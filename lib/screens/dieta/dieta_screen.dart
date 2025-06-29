// lib/screens/dieta/dieta_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DietaScreen extends StatefulWidget {
  const DietaScreen({super.key});

  @override
  State<DietaScreen> createState() => _DietaScreenState();
}

class _DietaScreenState extends State<DietaScreen> {
  int calorias = 0;
  int proteinas = 0;
  int gorduras = 0;
  int carboidratos = 0;
  int agua = 0;

  void adicionarAgua() {
    setState(() {
      agua++;
    });
  }

  void adicionarNutriente({required int cal, required int prot, required int gord, required int carb}) {
    setState(() {
      calorias += cal;
      proteinas += prot;
      gorduras += gord;
      carboidratos += carb;
    });
  }

  void abrirAdicionarAlimento(String refeicao) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAlimentoScreen(
          refeicao: refeicao,
          onAlimentoAdicionado: adicionarNutriente,
        ),
      ),
    );
  }

  Widget cardNutriente(String label, String valor, String asset) {
    return Column(
      children: [
        Image.asset(asset, height: 30),
        const SizedBox(height: 4),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12))
      ],
    );
  }

  Widget refeicaoBox(String nome, String asset) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: Image.asset(asset, width: 40),
        title: Text(nome),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, color: Color(0xFF0077B6)),
          onPressed: () => abrirAdicionarAlimento(nome),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        title: const Text("Dieta"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text("Meta diária: 2000 kcal", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                cardNutriente("Calorias", "$calorias kcal", 'assets/calorias.png'),
                cardNutriente("Proteínas", "$proteinas g", 'assets/proteinas.png'),
                cardNutriente("Gorduras", "$gorduras g", 'assets/gorduras.png'),
                cardNutriente("Carboidratos", "$carboidratos g", 'assets/carboidratos.png'),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Image.asset('assets/agua.png', width: 40),
              title: const Text("Água"),
              subtitle: Text("Copos: $agua"),
              trailing: IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF00B386)),
                onPressed: adicionarAgua,
              ),
            ),
            const SizedBox(height: 10),
            refeicaoBox("Café da manhã", 'assets/cafe_manha.png'),
            refeicaoBox("Lanche da manhã", 'assets/lanche.png'),
            refeicaoBox("Almoço", 'assets/almoco.png'),
            refeicaoBox("Lanche da tarde", 'assets/lanche.png'),
            refeicaoBox("Jantar", 'assets/jantar.png'),
            refeicaoBox("Ceia", 'assets/ceia.png'),
          ],
        ),
      ),
    );
  }
}

class AddAlimentoScreen extends StatelessWidget {
  final String refeicao;
  final void Function({required int cal, required int prot, required int gord, required int carb}) onAlimentoAdicionado;

  AddAlimentoScreen({super.key, required this.refeicao, required this.onAlimentoAdicionado});

  final TextEditingController nomeCtrl = TextEditingController();
  final TextEditingController calCtrl = TextEditingController();
  final TextEditingController protCtrl = TextEditingController();
  final TextEditingController gordCtrl = TextEditingController();
  final TextEditingController carbCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar alimento - $refeicao"),
        backgroundColor: const Color(0xFF0077B6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome do alimento')),
            TextField(controller: calCtrl, decoration: const InputDecoration(labelText: 'Calorias'), keyboardType: TextInputType.number),
            TextField(controller: protCtrl, decoration: const InputDecoration(labelText: 'Proteínas (g)'), keyboardType: TextInputType.number),
            TextField(controller: gordCtrl, decoration: const InputDecoration(labelText: 'Gorduras (g)'), keyboardType: TextInputType.number),
            TextField(controller: carbCtrl, decoration: const InputDecoration(labelText: 'Carboidratos (g)'), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onAlimentoAdicionado(
                  cal: int.tryParse(calCtrl.text) ?? 0,
                  prot: int.tryParse(protCtrl.text) ?? 0,
                  gord: int.tryParse(gordCtrl.text) ?? 0,
                  carb: int.tryParse(carbCtrl.text) ?? 0,
                );
                Navigator.pop(context);
              },
              child: const Text("Salvar alimento"),
            )
          ],
        ),
      ),
    );
  }
}
