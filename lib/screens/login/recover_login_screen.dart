import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecoverLoginScreen extends StatefulWidget {
  const RecoverLoginScreen({super.key});

  @override
  State<RecoverLoginScreen> createState() => _RecoverLoginScreenState();
}

class _RecoverLoginScreenState extends State<RecoverLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future<void> enviarEmailRedefinicao() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("E-mail de redefinição enviado com sucesso.")),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao enviar e-mail de redefinição.")),
      );
    }
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar Senha")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Redefinir Senha", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                decoration: _decoration("Digite seu e-mail"),
                validator: (value) =>
                value != null && value.contains('@') ? null : "E-mail inválido",
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: enviarEmailRedefinicao,
                  child: const Text("Enviar e-mail de redefinição"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
