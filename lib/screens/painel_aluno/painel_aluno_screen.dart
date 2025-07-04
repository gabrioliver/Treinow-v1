import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_nupe/theme_controller.dart';

class PainelAlunoScreen extends StatefulWidget {
  const PainelAlunoScreen({Key? key}) : super(key: key);

  @override
  State<PainelAlunoScreen> createState() => _PainelAlunoScreenState();
}

class _PainelAlunoScreenState extends State<PainelAlunoScreen> {
  String nomeAluno = '';
  bool carregando = true;
  bool isDarkMode = false;

  final List<Map<String, String>> notificacoes = [
    {"mensagem": "Seu treino foi atualizado", "hora": "10:00"},
    {"mensagem": "Nova dieta disponível", "hora": "09:15"},
  ];

  @override
  void initState() {
    super.initState();
    carregarNomeAluno();
  }

  Future<void> carregarNomeAluno() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
        setState(() {
          nomeAluno = doc['nome'] ?? 'Aluno';
          carregando = false;
        });
      }
    } catch (e) {
      print('Erro ao buscar nome do aluno: $e');
      setState(() {
        nomeAluno = 'Aluno';
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Menu do Aluno")),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Perfil"),
              onTap: () {
                // TODO: Tela de perfil
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text("Buscar Profissional"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/buscar_profissional');
              },
            ),
            SwitchListTile(
              title: const Text("Tema escuro"),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
                final modo = value ? ThemeMode.dark : ThemeMode.light;
                MyAppThemeController.of(context)?.setThemeMode(modo);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("TreiNow"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundImage: AssetImage('lib/assets/logo.png'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nomeAluno,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0077B6),
              ),
            ),
            const SizedBox(height: 20),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _dashboardCard("Treinos", Icons.fitness_center),
                _dashboardCard("Dietas", Icons.restaurant),
                _dashboardCard("Fisioterapia", Icons.accessibility_new),
                _dashboardCard("Visão Geral do Objetivo", Icons.fire_extinguisher), // NOVO
                _dashboardCard("Avaliações", Icons.folder_shared),// NOVO
                _dashboardCard("Agenda", Icons.calendar_today),
                _dashboardCard("Mensagens", Icons.message),
                _dashboardCard("Notificações", Icons.notifications),
              ],
            ),


            const SizedBox(height: 30),
            const Text("Notificações", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ...notificacoes.map((noti) => Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.notifications, color: Colors.grey),
                title: Text(noti['mensagem'] ?? ""),
                subtitle: Text("Horário: ${noti['hora']}"),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(String title, IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap ?? () => _showSnack("Em breve: $title"),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFFE1F5FE),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: const Color(0xFF0077B6)),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0077B6)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
