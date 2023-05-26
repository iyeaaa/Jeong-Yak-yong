// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../util/event.dart';
import '../util/medicine_list.dart';
import '../util/utils.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  CalenderPageState createState() => CalenderPageState();
}

class CalenderPageState extends State<CalenderPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
  //     .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // DateTime? _rangeStart;
  // DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // _rangeStart = null; // Important to clean those
        // _rangeEnd = null;
        // _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      // _rangeStart = start;
      // _rangeEnd = end;
      // _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        title: Text(
          'My Calendar',
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 26 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
        elevation: 0,
        toolbarHeight: 80 * fem,
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            // kFirstDay 부터만 접근가능
            lastDay: kLastDay,
            // kLastDay 까지만 접근가능
            focusedDay: _focusedDay,
            // _focusedDay 오늘로 선택되어있음
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            // rangeStartDay: _rangeStart,
            // rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            // 1주일, 2주일 단위로 볼수 있게함
            // rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            // 불러와서 점 찍어줌
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              markerSize: 7 * fem,
              // 점 스타일
              markerDecoration: const BoxDecoration(
                color: Color(0xFF632bff),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                Border.all(color: const Color(0xFFA07EFF), width: 2 * fem),
              ),
              todayTextStyle: SafeGoogleFont(
                'Poppins',
                fontSize: 16 * fem,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF632bff),
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFFA07EFF),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: SafeGoogleFont(
                'Poppins',
                fontSize: 16 * fem,
                fontWeight: FontWeight.w600,
                color: const Color(0xffffffff),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonDecoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFA07EFF)),
                borderRadius: BorderRadius.all(Radius.circular(20 * fem)),
              ),
              formatButtonTextStyle: SafeGoogleFont(
                'Poppins',
                fontSize: 15 * fem,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFA07EFF),
              ),
              titleTextStyle: SafeGoogleFont(
                'Poppins',
                fontSize: 20 * fem,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFA07EFF),
              ),
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: Color(0xFFA07EFF),
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: Color(0xFFA07EFF),
              ),
            ),
          ),
          SizedBox(height: 10.0 * fem),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                      20 * fem, 0 * fem, 20 * fem, 20 * fem),
                  itemCount: value.length,
                  itemBuilder: (context, i) {
                    String dateTime1 = value[i].dateTime;
                    String? dateTime2 =
                    i + 1 < value.length ? value[i + 1].dateTime : null;
                    return InkWell(
                      onTap: () => debugPrint('${value[i]}'),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 5 * fem, 0, 5 * fem),
                            padding: EdgeInsets.all(8 * fem),
                            width: double.infinity,
                            height: 65 * fem,
                            // padding: EdgeInsets.only(top: 10*fem),
                            decoration: BoxDecoration(
                                color: const Color(0xffdfd3ff),
                                border: Border.all(
                                  color: const Color(0xFFA07EFF),
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(13 * fem))),
                            child: Row(
                              children: [
                                SizedBox(width: 15 * fem),
                                const Icon(
                                  Icons.medication_liquid,
                                  color: Color(0xFF662fff),
                                ),
                                SizedBox(width: 15 * fem),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        value[i].medicine.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 15 * fem,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF662fff),
                                        ),
                                      ),
                                      Text(
                                        value[i].dateTime,
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 13 * fem,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF662fff),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (!value[i].take) {
                                      final mediList = MediList();
                                      await mediList
                                          .removeToArray(value[i].medicine);
                                      await mediList.appendToArray(
                                          value[i].medicine,
                                          value[i].medicine.count - 1);
                                      mediList.update();
                                      setState(() {
                                        value[i].take = true;
                                      });
                                    }
                                  },
                                  child: AnimatedContainer(
                                    width: 70*fem,
                                    height: 50*fem,
                                    margin: EdgeInsets.only(
                                        left: 8 * fem, right: 8 * fem),
                                    padding: EdgeInsets.all(8 * fem),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15 * fem)),
                                      border: Border.all(
                                          color: !value[i].take
                                              ? const Color(0xFF662fff)
                                              : const Color(0xffff5788),
                                          width: 2 * fem),
                                    ),
                                    duration: const Duration(milliseconds: 500),
                                    child: Center(
                                      child: Text(
                                        value[i].take ? "TOOK" : "TAKE",
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 15 * fem,
                                          fontWeight: FontWeight.w600,
                                          color: !value[i].take
                                              ? const Color(0xFF662fff)
                                              : const Color(0xffff5788),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (i != value.length - 1 &&
                              dateTime1.compareTo(dateTime2!) < 0)
                            const Divider(
                                color: Color(0xFF662fff), thickness: 1),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}