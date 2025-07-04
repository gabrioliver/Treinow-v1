import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AvisosScreen extends StatefulWidget {
  const AvisosScreen({super.key});

  @override
  State<AvisosScreen> createState() => _AvisosScreenState();
}

class _AvisosScreenState extends State<AvisosScreen> {
  final TextEditingController _textoAviso = TextEditingController();
  File? _imagemSelecionada;
  String _alunoSelecionado = 'Todos';
  final List<String> _alunos = ['Todos', 'João', 'Maria', 'Carlos']; // Exemplo

  Future<void> selecionarImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
      });
    }
  }

  void enviarAviso() {
    String texto = _textoAviso.text.trim();

    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite uma mensagem para o aviso")),
      );
      return;
    }

    // Aqui você pode fazer a lógica para salvar no banco ou enviar o aviso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aviso enviado para $_alunoSelecionado!'),
      ),
    );

    setState(() {
      _textoAviso.clear();
      _imagemSelecionada = null;
      _alunoSelecionado = 'Todos';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar Aviso'),
        backgroundColor: const Color(0xFF0077B6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textoAviso,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Mensagem do aviso',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: selecionarImagem,
                  icon: const Icon(Icons.image),
                  label: const Text("Inserir imagem"),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _alunoSelecionado,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _alunoSelecionado = value);
                    }
                  },
                  items: _alunos
                      .map((aluno) => DropdownMenuItem(
                            value: aluno,
                            child: Text(aluno),
                          ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_imagemSelecionada != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imagemSelecionada!,
                  height: 150,
                ),
              ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B386),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: enviarAviso,
              icon: const Icon(Icons.send),
              label: const Text("Enviar aviso"),
            )
          ],
        ),
      ),
    );
  }
}
