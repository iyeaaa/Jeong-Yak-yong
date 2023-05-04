import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/sub_pages/caution_page.dart';

import '../alarm_screens/edit_alarm.dart';
import '../alarm_screens/ring.dart';
import '../medicine_data/medicine.dart';
import '../util/alarm_tile.dart';
import '../util/utils.dart';

class MedicineSettingPage extends StatefulWidget {
  final Medicine medicine;

  const MedicineSettingPage({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  @override
  State<MedicineSettingPage> createState() => _MedicineSettingPageState();
}

class _MedicineSettingPageState extends State<MedicineSettingPage> {
  late Medicine medicine;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  late List<AlarmSettings> alarms; // null 이면 생성되지 않은거,
  static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    medicine = widget.medicine;
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  // 알람 울리는 페이지로 이동
  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExampleAlarmRingScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

  // 알람 설정 페이지로 이동
  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: ExampleAlarmEditScreen(alarmSettings: settings),
        );
      },
    );
    if (res != null && res == true) loadAlarms();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        title: FittedBox(
          child: Text(
            medicine.itemName,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 23 * fem,
              fontWeight: FontWeight.w600,
              color: const Color(0xffffffff),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add,
              size: 35 * fem,
            ),
          ),
          SizedBox(
            width: 10 * fem,
          ),
        ],
        elevation: 0,
        toolbarHeight: 80 * fem,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_sharp),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            30 * fem,
            20 * fem,
            30 * fem,
            20 * fem,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10 * fem),
                width: double.infinity,
                height: 195 * fem,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 324 * fem,
                      height: 195 * fem,
                      child: Image.asset(
                        'image/group-842-eqt.png',
                        width: 324 * fem,
                        height: 195 * fem,
                      ),
                    ), // 배경
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          20 * fem, 20 * fem, 20 * fem, 20 * fem),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50 * fem,
                                    height: 50 * fem,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(18 * fem),
                                      color: const Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'UI',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 16 * fem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.5 * fem,
                                          color: const Color(0xffa07eff),
                                        ),
                                      ),
                                    ),
                                  ), // UI BOX 위젯
                                  SizedBox(width: 20 * fem),
                                  SizedBox(
                                    width: 110 * fem,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          medicine.itemName,
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 16 * fem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.5 * fem,
                                            color: const Color(0xffffffff),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          medicine.entpName,
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12 * fem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.5 * fem,
                                            color: const Color(0xffffffff),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ), // 약 이름, 회사
                                ],
                              ), // UI BOX, 약 이름, 회사
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CautionPage(
                                      medicine: medicine,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: 90 * fem,
                                  height: 30 * fem,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffffffff),
                                    borderRadius:
                                        BorderRadius.circular(99 * fem),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '주의사항',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 14 * fem,
                                        fontWeight: FontWeight.w800,
                                        height: 1.5 * fem,
                                        color: const Color(0xffa98aff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ), // UI BOX and 주의사항
                          SizedBox(height: 20 * fem),
                          Text(
                            medicine.effect,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16 * fem,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              color: const Color(0xffffffff),
                            ),
                          ), // 약 설명
                        ],
                      ),
                    ), // 배경 위 위젯
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(top: 10 * fem),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       DayWidget(day: "월", fem: fem),
              //       DayWidget(day: "화", fem: fem),
              //       DayWidget(day: "수", fem: fem),
              //       DayWidget(day: "목", fem: fem),
              //       DayWidget(day: "금", fem: fem),
              //       DayWidget(day: "토", fem: fem),
              //       DayWidget(day: "일", fem: fem),
              //     ],
              //   ),
              // ), // 요일 선택 위젯
              Expanded(
                child: Center(
                  child: alarms.isNotEmpty
                      ? ListView.separated(
                          itemCount: alarms.length,
                          padding: EdgeInsets.only(top: 5*fem),
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            return AlarmTile(
                              key: Key(alarms[index].id.toString()),
                              title: TimeOfDay(
                                hour: alarms[index].dateTime.hour,
                                minute: alarms[index].dateTime.minute,
                              ).format(context),
                              onPressed: () =>
                                  navigateToAlarmScreen(alarms[index]),
                              // edit 페이지로 이동하는 함수 호출
                              onDismissed: () {
                                Alarm.stop(alarms[index].id)
                                    .then((_) => loadAlarms());
                              },
                            ); // 알람 타일,
                          },
                        )
                      : Text(
                        "No alarms set",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                ),
              ), // 알람 리스트
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                final alarmSettings = AlarmSettings(
                  id: 42,
                  dateTime: DateTime.now(),
                  assetAudioPath: 'assets/mozart.mp3',
                );
                Alarm.set(alarmSettings: alarmSettings);
              },
              backgroundColor: Colors.red,
              heroTag: null,
              child: const Text("RING NOW", textAlign: TextAlign.center),
            ), // Ring Now 버튼
            FloatingActionButton(
              onPressed: () => navigateToAlarmScreen(null),
              child: const Icon(Icons.alarm_add_rounded, size: 30),
            ), // 알람 추가 버튼
          ],
        ),
      ),
      // 하단부 버튼
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // 버튼 위치 설정
    );
  }
}

class DayWidget extends StatefulWidget {
  final String day;
  final double fem;

  const DayWidget({super.key, required this.fem, required this.day});

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  bool isSelected = false;
  late String day;
  late double fem;

  @override
  void initState() {
    super.initState();
    day = widget.day;
    fem = widget.fem;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        width: 40 * widget.fem,
        height: 50 * widget.fem,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffa07eff) : const Color(0xffDFD3FF),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            widget.day,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 16 * widget.fem,
              fontWeight: FontWeight.w500,
              height: 1.5 * widget.fem,
              color: const Color(0xffffffff),
            ),
          ),
        ),
      ),
    );
  }
}
