import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/util/medicine_card.dart';
import '../medicine_data/medicine.dart';
import '../medicine_data/medicine_cnt_management.dart';
import '../util/medicine_list.dart';
import '../util/utils.dart';

// 알림 울릴 때 페이지
class AlarmRingScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingScreen({
    Key? key,
    required this.alarmSettings,
  }) : super(key: key);

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  var toWeekDay = ["", "Mon", "Tue", "Web", "Thu", "Fri", "Sat", "Sun"];
  var toMonth = [
    "",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  var idxList = [];
  MediList mediList = MediList();
  late final Future<List<Medicine>> _futureMediList = mediList.getMediList();

  @override
  void initState() {
    super.initState();
    idxList = stringToIdxList(widget.alarmSettings.notificationBody!);
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xffFBF1FF),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    toTimeForm(widget.alarmSettings.dateTime.hour,
                        widget.alarmSettings.dateTime.minute),
                    style: SafeGoogleFont(
                      'DM Sans',
                      fontSize: 48 * fem,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20 * fem),
                  Text(
                    "${toWeekDay[widget.alarmSettings.dateTime.weekday]},"
                    " ${widget.alarmSettings.dateTime.day}"
                    " ${toMonth[widget.alarmSettings.dateTime.month]}",
                    style: SafeGoogleFont(
                      'DM Sans',
                      fontSize: 16 * fem,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ), // 시간, 날짜
            FutureBuilder(
                future: _futureMediList,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (snap.hasError) {
                    debugPrint("MediList ERROR from Ring Page");
                    return const Icon(Icons.error);
                  } else if (!snap.hasData) {
                    return const Text("loading");
                  } else {
                    return Expanded(
                      flex: 2,
                      child: ListView.builder(
                        itemCount: idxList.length,
                        itemBuilder: (context, i) =>
                            snap.data[idxList[i]].count > 0
                                ? Container(
                                    padding: EdgeInsets.fromLTRB(
                                        20 * fem, 7 * fem, 20 * fem, 7 * fem),
                                    child: SizedBox(
                                      height: 85 * fem,
                                      child: MedicineCard(
                                        fem: fem,
                                        name: snap.data[idxList[i]].itemName,
                                        company: snap.data[idxList[i]].entpName,
                                        ontap: () {},
                                        buttonName:
                                            "${snap.data[idxList[i]].count}회",
                                        isChecked: false,
                                        iconData: Icons.alarm,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      ),
                    );
                  }
                }), // 약 리스트
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await Alarm.stop(widget.alarmSettings.id);

                      final now = DateTime.now();
                      await Alarm.set(
                        alarmSettings: widget.alarmSettings.copyWith(
                          notificationTitle:
                              widget.alarmSettings.notificationTitle,
                          notificationBody:
                              widget.alarmSettings.notificationBody,
                          dateTime: DateTime(
                            now.year,
                            now.month,
                            now.day,
                            now.hour,
                            now.minute,
                            0,
                            0,
                          ).add(const Duration(days: 1)),
                        ),
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: SizedBox(
                      width: 150 * fem,
                      height: 150 * fem,
                      child: Image.asset('image/cancle.png'),
                    ),
                  ), // 끄기 버튼
                  ElevatedButton(
                    onPressed: () {
                      final now = DateTime.now();
                      Alarm.set(
                        alarmSettings: widget.alarmSettings.copyWith(
                          dateTime: DateTime(
                            now.year,
                            now.month,
                            now.day,
                            now.hour,
                            now.minute,
                            0,
                            0,
                          ).add(const Duration(minutes: 30)),
                        ),
                      ).then((_) {
                        Navigator.pop(context);
                      });
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30 * fem)),
                        ),
                      ),
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xffA07EFF)),
                      minimumSize:
                          MaterialStatePropertyAll(Size(150 * fem, 30 * fem)),
                    ),
                    child: Text(
                      "+30분",
                      style: SafeGoogleFont(
                        'DM Sans',
                        fontSize: 16 * fem,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ), // 미루기 버튼
                ],
              ),
            ), // 끄기, 미루기 버튼
          ],
        ),
      ),
    );
  }
}

String toTimeForm(int h, int m) {
  return "${h > 9 ? "$h" : "0$h"} : ${m > 9 ? "$m" : "0$m"}";
}
