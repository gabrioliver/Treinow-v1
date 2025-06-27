import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final celularController = TextEditingController();
  final crefitoController = TextEditingController();
  final crefController = TextEditingController();
  final crnController = TextEditingController();
  final idadeController = TextEditingController();
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();

  String tipoUsuario = 'aluno';
  bool carregando = false;

  Future<void> registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => carregando = true);

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      final uid = cred.user!.uid;

      // Substitui vírgula por ponto onde necessário
      String peso = pesoController.text.replaceAll(',', '.');
      String altura = alturaController.text.replaceAll(',', '.');

      final dadosUsuario = {
        'nome': nomeController.text.trim(),
        'email': emailController.text.trim(),
        'celular': celularController.text.trim(),
        'tipo': tipoUsuario,
        if (tipoUsuario == 'fisioterapeuta')
          'crefito': crefitoController.text.trim(),
        if (tipoUsuario == 'personal')
          'cref': crefController.text.trim(),
        if (tipoUsuario == 'nutricionista')
          'crn': crnController.text.trim(),
        if (tipoUsuario == 'aluno') ...{
          'idade': idadeController.text.trim(),
          'peso': peso,
          'altura': altura,
        },
      };

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .set(dadosUsuario);

      // ✅ Volta para tela de login após cadastro
      Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: ${e.message}')),
      );
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: tipoUsuario,
                decoration: const InputDecoration(labelText: 'Tipo de conta'),
                items: const [
                  DropdownMenuItem(value: 'personal', child: Text('Personal')),
                  DropdownMenuItem(value: 'nutricionista', child: Text('Nutricionista')),
                  DropdownMenuItem(value: 'fisioterapeuta', child: Text('Fisioterapeuta')),
                  DropdownMenuItem(value: 'aluno', child: Text('Aluno')),
                ],
                onChanged: (value) {
                  setState(() => tipoUsuario = value ?? 'aluno');
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) => value == null || !value.contains('@')
                    ? 'E-mail inválido'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (value) => value == null || value.length < 6
                    ? 'Senha deve ter pelo menos 6 caracteres'
                    : null,
                onFieldSubmitted: (_) => registrar(), // ✅ Enter envia
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: celularController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Celular'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe seu celular' : null,
              ),
              if (tipoUsuario == 'fisioterapeuta') ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: crefitoController,
                  decoration: const InputDecoration(labelText: 'CREFITO'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Informe o CREFITO' : null,
                ),
              ],
              if (tipoUsuario == 'personal') ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: crefController,
                  decoration: const InputDecoration(labelText: 'CREF'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Informe o CREF' : null,
                ),
              ],
              if (tipoUsuario == 'nutricionista') ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: crnController,
                  decoration: const InputDecoration(labelText: 'CRN'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Informe o CRN' : null,
                ),
              ],
              if (tipoUsuario == 'aluno') ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: idadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Idade'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Informe a idade' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: pesoController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Informe o peso' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: alturaController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Altura (cm)'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Informe a altura' : null,
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: registrar,
                  child: carregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Criar conta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
