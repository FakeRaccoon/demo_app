import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Technician extends StatefulWidget {
  @override
  _TechnicianState createState() => _TechnicianState();
}

class _TechnicianState extends State<Technician> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  Map<DateTime, List> _holidays = {
    DateTime(2021, 1, 1): ['New Year\'s Day'],
    DateTime(2020, 1, 6): ['Epiphany'],
    DateTime(2020, 2, 14): ['Valentine\'s Day'],
    DateTime(2020, 4, 21): ['Easter Sunday'],
    DateTime(2020, 4, 22): ['Easter Monday'],
  };
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.add(Duration(days: 2)): [
        'Ambil barang',
        'Demo',
      ]
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
    _calendarController.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      _selectedEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teknisi'),
      ),
      body: Column(
        children: [
          _buildTableCalendar(),
          SizedBox(height: 20),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      builders: CalendarBuilders(),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map(
            (event) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  ListTile(
                    title: Text(event.toString()),
                    onTap: () => print('$event tapped!'),
                  ),
                  Divider(thickness: 1),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
