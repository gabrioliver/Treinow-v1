class AgendaEvent {
  final String id;
  final String titulo;
  final String descricao;
  final DateTime data;

  AgendaEvent({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data.toIso8601String(),
    };
  }

  factory AgendaEvent.fromMap(Map<String, dynamic> map) {
    return AgendaEvent(
      id: map['id'] ?? '',
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      data: DateTime.parse(map['data']),
    );
  }
}
