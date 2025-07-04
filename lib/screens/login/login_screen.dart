import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'check_perfil.dart';
import 'recover_login_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool lembrarEmail = false;
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    carregarEmailSalvo();
  }

  Future<void> carregarEmailSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    final emailSalvo = prefs.getString('email_salvo');
    if (emailSalvo != null) {
      setState(() {
        _emailController.text = emailSalvo;
        lembrarEmail = true;
      });
    }
  }

  Future<void> salvarEmail(bool salvar) async {
    final prefs = await SharedPreferences.getInstance();
    if (salvar) {
      await prefs.setString('email_salvo', _emailController.text.trim());
    } else {
      await prefs.remove('email_salvo');
    }
  }

  Future<void> fazerLogin() async {
    setState(() => carregando = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );
      await salvarEmail(lembrarEmail);
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CheckPerfilScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      final msg = e.code == 'user-not-found'
          ? 'Usuário não encontrado'
          : e.code == 'wrong-password'
              ? 'Senha incorreta'
              : 'Erro ao fazer login';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 2, 2, 2), Color.fromARGB(255, 247, 246, 246)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo_treinow.png',
                  height: 100,
                ),
                const SizedBox(height: 12),
                const Text(
                  "TreiNow",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (_) => fazerLogin(),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _senhaController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onSubmitted: (_) => fazerLogin(),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Checkbox(
                      value: lembrarEmail,
                      onChanged: (value) {
                        setState(() => lembrarEmail = value ?? false);
                      },
                    ),
                    const Text("Lembrar e-mail"),
                  ],
                ),
                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: carregando ? null : fazerLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color.fromARGB(255, 231, 232, 233),
                  ),
                  child: carregando
                      ? const CircularProgressIndicator(color: Color.fromARGB(255, 10, 10, 10))
                      : const Text("Entrar"),
                ),

                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implementar login com Google
                  },
                  icon: Image.asset(
                    'assets/google_icon.png',
                    height: 20,
                  ),
                  label: const Text("Entrar com Google"),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    foregroundColor: const Color.fromARGB(255, 8, 8, 8),
                  ),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RecoverLoginScreen()),
                    );
                  },
                  child: const Text('Esqueceu seu login?'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Criar conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
