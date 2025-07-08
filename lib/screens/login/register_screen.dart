import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  DateTime? dataNascimento;
  String? tipoContaSelecionado;
  bool carregando = false;

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (data != null) {
      setState(() {
        dataNascimento = data;
      });
    }
  }

  int _calcularIdade(DateTime nascimento) {
    final hoje = DateTime.now();
    int idade = hoje.year - nascimento.year;
    if (hoje.month < nascimento.month || (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idade--;
    }
    return idade;
  }

  Future<void> registrar() async {
    if (!_formKey.currentState!.validate() || dataNascimento == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Preencha todos os campos.")));
      return;
    }

    setState(() => carregando = true);

    try {
      final credenciais = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text,
      );

      final idade = _calcularIdade(dataNascimento!);

      await FirebaseFirestore.instance.collection('usuarios').doc(credenciais.user!.uid).set({
        'nome': nomeController.text.trim(),
        'email': emailController.text.trim(),
        'celular': celularController.text.trim(),
        'dataNascimento': dataNascimento,
        'idade': idade,
        'tipo': tipoContaSelecionado?.toLowerCase(),
        'uid': credenciais.user!.uid,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Conta criada com sucesso!")));
        Navigator.pushReplacementNamed(context, '/check_perfil');
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.message}')));
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Conta")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                validator: (value) => value == null || value.isEmpty ? 'Informe seu nome' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? 'Informe seu e-mail' : null,
              ),
              TextFormField(
                controller: senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value == null || value.length < 6 ? 'Senha muito curta' : null,
              ),
              TextFormField(
                controller: celularController,
                decoration: const InputDecoration(labelText: 'Celular'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: tipoContaSelecionado,
                hint: const Text("Selecione o tipo de conta"),
                decoration: const InputDecoration(labelText: "Tipo de Conta"),
                items: ['Aluno', 'Profissional'].map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo));
                }).toList(),
                onChanged: (value) => setState(() => tipoContaSelecionado = value),
                validator: (value) => value == null ? 'Selecione um tipo de conta' : null,
              ),
              const SizedBox(height: 16),
              const Text("Data de nascimento"),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: _selecionarData,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        dataNascimento == null
                            ? 'Nenhuma data selecionada'
                            : DateFormat('dd/MM/yyyy').format(dataNascimento!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: senhaController.text.trim(),
                      );

                      final idade = DateTime.now().year - dataNascimento!.year;

                      await FirebaseFirestore.instance
                          .collection('usuarios')
                          .doc(cred.user!.uid)
                          .set({
                        'uid': cred.user!.uid,
                        'nome': nomeController.text.trim(),
                        'email': emailController.text.trim(),
                        'celular': celularController.text.trim(),
                        'tipo': tipoContaSelecionado?.toLowerCase(),
                        'dataNascimento': dataNascimento,
                        'idade': idade,
                      });

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Conta criada com sucesso!')),
                        );
                        await FirebaseAuth.instance.signOut(); // desloga o novo usuário
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao criar conta: $e')),
                      );
                    }
                  }
                },
                child: const Text("Criar Conta"),
              )

            ],
          ),
        ),
      ),
    );
  }
}
