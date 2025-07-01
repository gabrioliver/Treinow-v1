import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_nupe/theme_controller.dart';
import 'package:app_nupe/screens/painel_profissional/editar_perfil_profissional_screen.dart';

class PainelProfissionalScreen extends StatefulWidget {
  const PainelProfissionalScreen({super.key});

  @override
  State<PainelProfissionalScreen> createState() => _PainelProfissionalScreenState();
}

class _PainelProfissionalScreenState extends State<PainelProfissionalScreen> {
  bool isDarkMode = false;

  final List<Map<String, String>> notificacoes = [
    {"usuario": "João", "mensagem": "Faltou na aula", "hora": "08:30"},
    {"usuario": "Maria", "mensagem": "Enviou comprovante", "hora": "09:15"},
  ];

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    final darkMode = prefs.getBool('modo_escuro') ?? false;
    setState(() {
      isDarkMode = darkMode;
    });
    MyAppThemeController.of(context)?.setThemeMode(darkMode ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _atualizarPreferenciaTema(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modo_escuro', value);
  }

  Future<void> _confirmarLogout() async {
    final sair = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deseja sair?"),
        content: const Text("Você será desconectado da sua conta."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sair"),
          ),
        ],
      ),
    );

    if (sair == true) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Scaffold(body: Center(child: Text("Erro: sem usuário logado.")));

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Menu do Professor")),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Perfil"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditarPerfilProfissionalScreen(uidProfissional: uid),
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text("Tema escuro"),
              value: isDarkMode,
              onChanged: (value) {
                setState(() => isDarkMode = value);
                MyAppThemeController.of(context)?.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                _atualizarPreferenciaTema(value);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: _confirmarLogout,
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
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('perfis_profissionais').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Perfil não encontrado."));
          }

          final dados = snapshot.data!.data() as Map<String, dynamic>;
          final nomeProfissional = dados['nome'] ?? 'Profissional';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nomeProfissional,
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
                    _dashboardCard("Meus alunos", Icons.group, route: '/alunos'),
                    _dashboardCard("Financeiro", Icons.attach_money, route: '/financeiro'),
                    _dashboardCard("Agenda", Icons.calendar_today, route: '/agenda'),
                    _dashboardCard("Dietas", Icons.food_bank_rounded, route: '/dieta'),
                    _dashboardCard("Treinos", Icons.fitness_center, onTap: () => _showSnack("Treinos em breve")),
                    _dashboardCard("Avaliações Fisio", Icons.show_chart, onTap: () => _showSnack("Avaliações em breve")),
                    _dashboardCard("Meus anúncios", Icons.campaign, onTap: () => Navigator.pushNamed(context, '/aviso')),
                    _dashboardCard("Notificações", Icons.notifications, onTap: () => _showSnack("Notificações em breve")),
                    _dashboardCard("Relatórios", Icons.bar_chart, onTap: () => _showSnack("Relatórios em breve")),
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
                    subtitle: Text("Usuário: ${noti['usuario']} - Horário: ${noti['hora']}"),
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _dashboardCard(String title, IconData icon, {String? route, VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        if (route != null) {
          Navigator.pushNamed(context, route);
        } else if (onTap != null) {
          onTap();
        }
      },
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
}
