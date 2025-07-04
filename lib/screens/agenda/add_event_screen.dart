import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/agenda_event.dart';
import 'package:uuid/uuid.dart';

class AddEventScreen extends StatefulWidget {
  final DateTime selectedDate;
  const AddEventScreen({super.key, required this.selectedDate});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();
  AgendaEvent? _eventoEditando;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is DateTime) {
      _dataSelecionada = args;
    } else if (args is AgendaEvent) {
      _eventoEditando = args;
      _tituloController.text = args.titulo;
      _descricaoController.text = args.descricao;
      _dataSelecionada = args.data;
    }
  }

  Future<void> _salvarEvento() async {
    if (_formKey.currentState!.validate()) {
      final novoEvento = AgendaEvent(
        id: _eventoEditando?.id ?? const Uuid().v4(),
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        data: _dataSelecionada,
      );

      final ref = FirebaseFirestore.instance.collection('agenda').doc(novoEvento.id);

      if (_eventoEditando != null) {
        await ref.update(novoEvento.toMap());
      } else {
        await ref.set(novoEvento.toMap());
      }

      if (context.mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_eventoEditando != null ? 'Editar Evento' : 'Novo Evento'),
        backgroundColor: const Color(0xFF0077B6),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _salvarEvento,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value == null || value.isEmpty ? 'Digite um título' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(DateFormat('dd/MM/yyyy').format(_dataSelecionada)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final data = await showDatePicker(
                        context: context,
                        initialDate: _dataSelecionada,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (data != null) {
                        setState(() => _dataSelecionada = data);
                      }
                    },
                    child: const Text('Selecionar Data'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
