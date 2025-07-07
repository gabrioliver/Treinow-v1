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

  void fazerLoginComGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login com Google em breve...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_login_moderno.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Image.asset(
                    'assets/logo_treinow.png',
                    height: 80,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "TreiNow",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Color.fromARGB(179, 20, 51, 192)),
                      labelText: 'E-mail',
                      labelStyle: const TextStyle(color: Color.fromARGB(179, 11, 38, 192)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSubmitted: (_) => fazerLogin(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _senhaController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                      labelText: 'Senha',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    obscureText: true,
                    onSubmitted: (_) => fazerLogin(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: lembrarEmail,
                        onChanged: (value) {
                          setState(() => lembrarEmail = value ?? false);
                        },
                      ),
                      const Text("Lembrar e-mail", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: carregando ? null : fazerLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5DE6DE),
                      foregroundColor: Colors.black,
                      elevation: 6,
                      shadowColor: Colors.tealAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: carregando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("ENTRAR", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: fazerLoginComGoogle,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/google_icon.png', height: 24),
                          const SizedBox(width: 12),
                          const Text(
                            'Entrar com Google',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RecoverLoginScreen()),
                      );
                    },
                    child: const Text('Esqueceu seu login?', style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text('Criar conta', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
