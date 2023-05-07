import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import '../util/utils.dart';

// 알림 울릴 때 페이지
class AlarmRingScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingScreen({Key? key, required this.alarmSettings})
      : super(key: key);

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  var toWeekDay = ["", "Mon", "Tue", "Web", "Thu", "Fri", "Sat", "Sun"];

  var toMonth = ["", "Jan", "Feb", "Mar", "Apr",
    "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xffFBF1FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${widget.alarmSettings.dateTime.hour} :"
              " ${widget.alarmSettings.dateTime.minute}",
              style: SafeGoogleFont(
                'DM Sans',
                fontSize: 48 * fem,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
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
            Text(
              "${widget.alarmSettings.notificationBody}을(를) 먹을 시간입니다.",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text("🔔", style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
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
                        ).add(const Duration(minutes: 1)),
                      ),
                    ).then((_) => Navigator.pop(context));
                  },
                  child: Text(
                    "Snooze",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ), // snooze 버튼
                RawMaterialButton(
                  onPressed: () {
                    Alarm.stop(widget.alarmSettings.id)
                        .then((_) => Navigator.pop(context));
                  },
                  child: Text(
                    "Stop",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ), // stop 버튼
              ],
            ),
          ],
        ),
      ),
    );
  }
}
