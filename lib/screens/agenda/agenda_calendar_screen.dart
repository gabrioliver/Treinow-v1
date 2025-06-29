import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/agenda_event.dart';

class AgendaCalendarScreen extends StatefulWidget {
  const AgendaCalendarScreen({super.key});

  @override
  State<AgendaCalendarScreen> createState() => _AgendaCalendarScreenState();
}

class _AgendaCalendarScreenState extends State<AgendaCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, List<AgendaEvent>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final snapshot = await FirebaseFirestore.instance.collection('agenda').get();
    final events = <String, List<AgendaEvent>>{};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final event = AgendaEvent.fromMap({...data, 'id': doc.id});
      final dateKey = DateFormat('yyyy-MM-dd').format(event.data);

      events.putIfAbsent(dateKey, () => []).add(event);
    }

    setState(() => _events = events);
  }

  List<AgendaEvent> _getEventsForDay(DateTime day) {
    final key = DateFormat('yyyy-MM-dd').format(day);
    return _events[key] ?? [];
  }

  Future<void> _deleteEvent(AgendaEvent event) async {
    await FirebaseFirestore.instance.collection('agenda').doc(event.id).delete();
    _loadEvents();
  }

  void _openEventDetails(AgendaEvent event) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(event.titulo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${event.descricao}'),
            const SizedBox(height: 10),
            Text('Data: ${DateFormat('dd/MM/yyyy – HH:mm').format(event.data)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        title: const Text('Agenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/add_event', arguments: _selectedDay);
              if (result == true) {
                _loadEvents();
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(color: const Color(0xFF00B386), shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: const Color(0xFF0077B6), shape: BoxShape.circle),
              markerDecoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              markersMaxCount: 3,
            ),
            headerStyle: const HeaderStyle(formatButtonVisible: false),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _getEventsForDay(_selectedDay ?? _focusedDay).isEmpty
                ? const Center(child: Text('Nenhum evento para este dia.'))
                : ListView(
                    children: _getEventsForDay(_selectedDay ?? _focusedDay).map((event) {
                      return Dismissible(
                        key: Key(event.id),
                        background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 20), child: const Icon(Icons.delete, color: Colors.white)),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) => _deleteEvent(event),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.event, color: Color(0xFF0077B6)),
                            title: Text(event.titulo),
                            subtitle: Text(DateFormat('dd/MM/yyyy – HH:mm').format(event.data)),
                            onTap: () => _openEventDetails(event),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/add_event',
                                  arguments: event,
                                ).then((value) {
                                  if (value == true) _loadEvents();
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          )
        ],
      ),
    );
  }
}
