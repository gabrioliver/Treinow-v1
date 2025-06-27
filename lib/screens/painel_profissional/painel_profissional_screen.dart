import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_nupe/theme_controller.dart';

class PainelProfissionalScreen extends StatefulWidget {
  const PainelProfissionalScreen({super.key});

  @override
  State<PainelProfissionalScreen> createState() => _PainelProfissionalScreenState();
}

class _PainelProfissionalScreenState extends State<PainelProfissionalScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final String nomeProfissional = "Karlla"; // puxar do Firebase depois

    final List<Map<String, String>> notificacoes = [
      {"usuario": "João", "mensagem": "Faltou na aula", "hora": "08:30"},
      {"usuario": "Maria", "mensagem": "Enviou comprovante", "hora": "09:15"},
    ];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Menu do Professor")),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Perfil"),
              onTap: () {},
            ),
            SwitchListTile(
              title: const Text("Tema escuro"),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
                // Atualiza o tema no MaterialApp (reconstrução via restart ou provider)
                final mode = value ? ThemeMode.dark : ThemeMode.light;
                MyAppThemeController.of(context)?.setThemeMode(mode);
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nomeProfissional,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _dashboardCard("Meus alunos", Icons.group),
                _dashboardCard("Financeiro", Icons.attach_money),
                _dashboardCard("Agenda", Icons.calendar_today),
                _dashboardCard("Dietas", Icons.food_bank_rounded),
                _dashboardCard("Treinos", Icons.fitness_center),
                _dashboardCard("Avaliações Fisio", Icons.show_chart),
                _dashboardCard("Meus anúncios", Icons.campaign),
                _dashboardCard("Notificações", Icons.notifications),
                _dashboardCard("Relatórios", Icons.bar_chart),
              ],
            ),

            const SizedBox(height: 20),
            const Text("Notificações", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: notificacoes.isEmpty
                  ? const Center(child: Text("Você não possui notificações."))
                  : ListView.builder(
                      itemCount: notificacoes.length,
                      itemBuilder: (context, index) {
                        final noti = notificacoes[index];
                        return ListTile(
                          leading: const Icon(Icons.notifications),
                          title: Text(noti['mensagem']!),
                          subtitle: Text("Usuário: ${noti['usuario']} - Horário: ${noti['hora']}"),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        // ação ao clicar
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
