import 'dart:collection';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/medicine_data/medicine_cnt_management.dart';
import '../medicine_data/medicine.dart';
import '../util/event.dart';
import '../util/medicine_list.dart';
import '../util/utils.dart';

class AlarmEditScreen extends StatefulWidget {
  final AlarmSettings? alarmSettings;
  final String mediIndex;

  const AlarmEditScreen({
    Key? key,
    this.alarmSettings,
    required this.mediIndex,
  }) : super(key: key);

  @override
  State<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AlarmEditScreen> {
  late bool creating;
  late TimeOfDay selectedTime;
  late bool loopAudio;
  late bool vibrate;
  late bool showNotification;
  late String assetAudio;
  List<int> idxList = [];

  @override
  void initState() {
    var splitedList = widget.mediIndex.split(',');
    splitedList.removeLast();
    for (var idx in splitedList.map((e) => int.parse(e)).toList()) {
      idxList.add(idx);
    }

    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      final dt = DateTime.now().add(const Duration(minutes: 1));
      selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      loopAudio = true;
      vibrate = true;
      showNotification = true;
      assetAudio = 'assets/mozart.mp3';
    } else {
      selectedTime = TimeOfDay(
        hour: widget.alarmSettings!.dateTime.hour,
        minute: widget.alarmSettings!.dateTime.minute,
      );
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      showNotification = widget.alarmSettings!.notificationTitle != null &&
          widget.alarmSettings!.notificationTitle!.isNotEmpty &&
          widget.alarmSettings!.notificationBody != null &&
          widget.alarmSettings!.notificationBody!.isNotEmpty;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
  } // creating 상태에 따라 요소들 초기화

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: selectedTime,
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              // change the border color
              primary: Colors.red,
              // change the text color
              onSurface: Colors.purple,
            ),
            // button colors
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.green,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (res != null) setState(() => selectedTime = res);
  } // 시계 보여주고 설정할 수 있게함

  AlarmSettings buildAlarmSettings() {
    final now = DateTime.now();
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 100000
        : widget.alarmSettings!.id;

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
      0,
      0,
    );
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      notificationTitle: showNotification ? widget.mediIndex : null,
      notificationBody: showNotification ? widget.mediIndex : null,
      assetAudioPath: assetAudio,
      stopOnNotificationOpen: false,
    );
    return alarmSettings;
  } // 알람 세팅 제작 후 반환

  // 세이브 버튼의 세이브버튼
  Future<void> saveAlarm() async {
    var buildAlarmSetting = buildAlarmSettings();
    Alarm.set(alarmSettings: buildAlarmSetting)
        .then((_) => Navigator.pop(context, true));

    // 추가하는 알람의 약들의 알람 정보를 저장해준다.
    var mediList = await MediList().getMediList();
    for (int idx in idxList) {
      Medicine medicine = mediList[idx];
      debugPrint("${medicine.itemName}: ${medicine.count}");
      if (!alarmsOfMedi.containsKey(medicine)) {
        alarmsOfMedi[medicine] = SplayTreeSet();
      }
      alarmsOfMedi[medicine]!.add(buildAlarmSetting.dateTime);
    }

    kEvents.clear();
    // 모든 약을 순회하면서 캘린더에 약의 정보를 업데이트한다.
    for (Medicine medicine in mediList) {
      int iter = 0, delay = 0;
      first: while (alarmsOfMedi[medicine] != null) {
        for (DateTime dateTime in (alarmsOfMedi[medicine]!)) {
          if (iter >= medicine.count) break first;
          DateTime key = dateTime.add(Duration(days: delay));
          if (kEvents[key] == null) {
            kEvents[key] = [];
          }
          kEvents[key]!.add(Event(medicine.itemName));
          iter++;
        }
        delay++;
      }
    }

    print("캘린더 초기화 완료");
    print(kEvents);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '알람이 추가되었습니다.',
            textAlign: TextAlign.center,
            style: SafeGoogleFont(
              'Nunito',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.3625,
              color: const Color(0xffffffff),
            ),
          ),
          backgroundColor: const Color(0xff8a60ff),
        ),
      );
    }
  }

  // 삭제버튼의 삭제기능
  Future<void> deleteAlarm() async {
    Alarm.stop(widget.alarmSettings!.id)
        .then((_) => Navigator.pop(context, true));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancel",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: const Color(0xffa07eff)),
                ),
              ), // Cencel
              TextButton(
                onPressed: saveAlarm,
                child: Text(
                  "Save",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: const Color(0xffa07eff)),
                ),
              ), // Save
            ],
          ), // Cancel, Save Button
          RawMaterialButton(
            onPressed: pickTime,
            fillColor: Colors.grey[200],
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                selectedTime.format(context),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.purple),
              ),
            ),
          ), // time show Widget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loop alarm audio',
                style: Theme.of(context).textTheme.titleMedium,
              ), // Loop alarm audio
              Switch(
                value: loopAudio,
                onChanged: (value) => setState(() => loopAudio = value),
                activeColor: const Color(0xffa07eff),
              ),
            ],
          ), // Loop alarm audio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vibrate',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: vibrate,
                onChanged: (value) => setState(() => vibrate = value),
                activeColor: const Color(0xffa07eff),
              ),
            ],
          ), // Vibrate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Show notification',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: showNotification,
                onChanged: (value) => setState(() => showNotification = value),
                activeColor: const Color(0xffa07eff),
              ),
            ],
          ), // Show notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sound',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                value: assetAudio,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'assets/mozart.mp3',
                    child: Text('Mozart'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/nokia.mp3',
                    child: Text('Nokia'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/one_piece.mp3',
                    child: Text('One Piece'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/star_wars.mp3',
                    child: Text('Star Wars'),
                  ),
                ],
                onChanged: (value) => setState(() => assetAudio = value!),
              ),
            ],
          ), // Sound
          if (!creating) // 이미 만들어졌다면
            TextButton(
              onPressed: deleteAlarm,
              child: Text(
                'Delete Alarm',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }
}
