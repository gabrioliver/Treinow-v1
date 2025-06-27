import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool lembrarLogin = false;
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarEmailSalvo();
  }

  Future<void> _carregarEmailSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    final salvo = prefs.getString('email_salvo');
    if (salvo != null) {
      emailController.text = salvo;
      lembrarLogin = true;
      setState(() {});
    }
  }

  Future<void> _salvarEmail() async {
    final prefs = await SharedPreferences.getInstance();
    if (lembrarLogin) {
      await prefs.setString('email_salvo', emailController.text.trim());
    } else {
      await prefs.remove('email_salvo');
    }
  }

  Future<void> fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => carregando = true);

    try {
      await _salvarEmail();

      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      final uid = userCredential.user!.uid;
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();

      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário não encontrado.")),
        );
        return;
      }

      final tipo = doc.data()!['tipo'];
      if (tipo == 'aluno') {
        Navigator.pushReplacementNamed(context, '/painel_aluno');
      } else {
        Navigator.pushReplacementNamed(context, '/painel');
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${e.message}")),
      );
    } finally {
      setState(() => carregando = false);
    }
  }

  Future<void> loginComGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/painel');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro no login com Google: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) => (value == null || !value.contains('@')) ? "E-mail inválido" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (value) => (value == null || value.length < 6) ? "Senha inválida" : null,
                onFieldSubmitted: (_) => fazerLogin(), // Pressionar Enter faz login
              ),
              Row(
                children: [
                  Checkbox(
                    value: lembrarLogin,
                    onChanged: (value) => setState(() => lembrarLogin = value ?? false),
                  ),
                  const Text("Lembrar meus dados"),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: fazerLogin,
                  child: carregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Entrar"),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: loginComGoogle,
                  child: const Text("Entrar com Google"),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/recover'),
                child: const Text("Esqueceu seu login?"),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Não tem login? "),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text("Criar conta"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
