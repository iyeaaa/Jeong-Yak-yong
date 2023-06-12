// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:medicine_app/alarm_screens/ring.dart';
import 'package:medicine_app/login/accountpage.dart';
import 'package:medicine_app/medicine_data/medicine_cnt_management.dart';
import 'package:medicine_app/sub_pages/making_schedule.dart';
import 'package:medicine_app/sub_pages/medi_setting.dart';
import 'package:medicine_app/util/loading_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../medicine_data/medicine.dart';
import '../util/event.dart';
import '../util/collection.dart';
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
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      // _rangeStart = null; // Important to clean those
      // _rangeEnd = null;
      // _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedEvents.value = _getEventsForDay(selectedDay);
    // if (!isSameDay(_selectedDay, selectedDay)) {
    //
    // }
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

  Future<void> refreshSchedule() async {
    showLoadingBar(context);
    rmvEventsWithoutMemo();
    var medilist = await Collections().getMediList();
    await updateEvents(medilist);
    if (context.mounted) Navigator.pop(context);
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
          'Calendar',
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 26 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Center(
            child: InkWell(
              onTap: () {
                var curTime = DateTime.now();
                Collections().scheduleAdd("안녕", curTime.add(const Duration(days: -5)), true);
                Collections().scheduleAdd("안녕2", curTime.add(const Duration(days: -5)), false);

                Collections().scheduleAdd("안녕2", curTime.add(const Duration(days: -4)), false);
                Collections().scheduleAdd("안녕3", curTime.add(const Duration(days: -4)), false);
                Collections().scheduleAdd("안녕4", curTime.add(const Duration(days: -4)), false);
                Collections().scheduleAdd("안녕5", curTime.add(const Duration(days: -4)), false);
                Collections().scheduleAdd("안녕6", curTime.add(const Duration(days: -4)), true);
                Collections().scheduleAdd("안녕7", curTime.add(const Duration(days: -4)), true);

                Collections().scheduleAdd("안녕1", curTime.add(const Duration(days: -3)), false);
                Collections().scheduleAdd("안녕2", curTime.add(const Duration(days: -3)), true);
                Collections().scheduleAdd("안녕3", curTime.add(const Duration(days: -3)), true);
              },
              child: const Icon(Icons.bug_report_outlined, size: 30,),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              Collections().update();
              await refreshSchedule();
              setState(() {});
              return Future.delayed(const Duration(milliseconds: 200));
            },
            child: const Icon(
              Icons.refresh,
              size: 37,
            ),
          ),
          SizedBox(width: 25 * fem),
        ],
        elevation: 0,
        toolbarHeight: 80 * fem,
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
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
                    DateTime dateTime1 = value[i].dateTime;
                    DateTime dateTime2 = (i + 1 < value.length
                        ? value[i + 1].dateTime
                        : DateTime(9999));
                    Widget scheduleWidget() {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => value[i].memo
                                  ? MakingSchedulePage(
                                      dateTime: value[i].dateTime,
                                      creating: false,
                                      event: Event(
                                        medicine: value[i].medicine,
                                        dateTime: value[i].dateTime,
                                        noteState: value[i].noteState,
                                        note: value[i].note,
                                        conditionState: value[i].conditionState,
                                        condition: value[i].condition,
                                        hypertensionState:
                                            value[i].hypertensionState,
                                        hypertension: value[i].hypertension,
                                        glucoseState: value[i].glucoseState,
                                        glucose: value[i].glucose,
                                      ),
                                    )
                                  : MedicineSettingPage(
                                      medicine: value[i].medicine,
                                      creating: false,
                                    ),
                            ),
                          ).then((value) async {
                            await refreshSchedule();
                            setState(() {});
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(0, 5 * fem, 0, 5 * fem),
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
                                  Radius.circular(13 * fem),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 10 * fem),
                                  Icon(
                                    value[i].memo
                                        ? Icons.note_alt_outlined
                                        : Icons.medical_information,
                                    color: const Color(0xFF662fff),
                                    size: 30,
                                  ),
                                  SizedBox(width: 15 * fem),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          toTimeForm(
                                            value[i].dateTime.hour,
                                            value[i].dateTime.minute,
                                          ),
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
                                      Future<void> changeTakeToggle() async {
                                        final collection = Collections();
                                        await collection
                                            .medicineRmv(value[i].medicine);
                                        await collection.medicineAdd(
                                          value[i].medicine,
                                          value[i].medicine.count +
                                              (value[i].take ? 1 : -1),
                                        );
                                        value[i].medicine.count +=
                                            value[i].take ? 1 : -1;
                                        await collection.scheduleRmv(
                                          value[i].medicine.itemName,
                                          value[i].dateTime,
                                          value[i].take,
                                        );
                                        await collection.scheduleAdd(
                                          value[i].medicine.itemName,
                                          value[i].dateTime,
                                          !value[i].take,
                                        );
                                        setState(() {
                                          value[i].take = !value[i].take;
                                        });
                                      }

                                      if (value[i].memo) {
                                        showScaffold('약을 선택해주세요', context, fem);
                                        return;
                                      }

                                      if (value[i].medicine.entpName.isEmpty) {
                                        showScaffold(
                                            "약을 리스트에 추가해주세요", context, fem);
                                        return;
                                      }

                                      if (value[i]
                                          .dateTime
                                          .isAfter(DateTime.now())) {
                                        showScaffold(
                                            "아직 먹을 시간이 되지 않았어요", context, fem);
                                        return;
                                      }

                                      if (value[i].take) {
                                        showAlertDialog(
                                          context,
                                          "취소",
                                          '아직 약을 먹지 않으셨나요?',
                                          () => Navigator.pop(context),
                                          () async {
                                            await changeTakeToggle();
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },
                                        );
                                        return;
                                      }

                                      changeTakeToggle();
                                    },
                                    child: AnimatedContainer(
                                      width: 70 * fem,
                                      height: 50 * fem,
                                      margin: EdgeInsets.only(
                                          left: 8 * fem, right: 8 * fem),
                                      padding: EdgeInsets.all(8 * fem),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15 * fem)),
                                        border: Border.all(
                                            color: value[i].memo
                                                ? const Color(0xff0012fa)
                                                : !value[i].take
                                                    ? const Color(0xFF662fff)
                                                    : const Color(0xffff5788),
                                            width: 2 * fem),
                                      ),
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: Center(
                                        child: Text(
                                          value[i].memo
                                              ? "MEMO"
                                              : value[i].take
                                                  ? "TOOK"
                                                  : "TAKE",
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 15 * fem,
                                            fontWeight: FontWeight.w600,
                                            color: value[i].memo
                                                ? const Color(0xff0012fa)
                                                : !value[i].take
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
                                dateTime1.compareTo(dateTime2) < 0)
                              const Divider(
                                  color: Color(0xFF662fff), thickness: 1),
                          ],
                        ),
                      );
                    }

                    return value[i].fromDatabase
                        ? Dismissible(
                            key: ValueKey(value[i]),
                            background: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20 * fem),
                                color: const Color(0xffa07eff),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 30),
                              child: const Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) async {
                              showLoadingBar(context);
                              if (value[i].memo) {
                                await Collections().memoRmv(value[i]);
                              } else {
                                await Collections().scheduleRmv(
                                  value[i].medicine.itemName,
                                  value[i].dateTime,
                                  value[i].take,
                                );
                              }
                              if (context.mounted) {
                                showScaffold('일정을 삭제했어요', context, fem);
                              }
                              kEvents[value[i].dateTime]?.remove(value[i]);
                              _onDaySelected(_selectedDay!, _focusedDay);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                              debugPrint(kEvents.toString());
                            },
                            child: scheduleWidget(),
                          )
                        : scheduleWidget();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingActionButton(
          backgroundColor: const Color(0xffa07eff),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MakingSchedulePage(
                  creating: true,
                  dateTime: _selectedDay!,
                  event: Event(
                    medicine: Medicine.notExist("Schedule Title"),
                    dateTime: _selectedDay!,
                  ),
                ),
              )).then((value) {
            setState(() {
              refreshSchedule();
            });
          }),
          child: const Icon(Icons.edit_calendar, size: 30),
        ),
      ),
    );
  }
}
