import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:medicine_app/alarm_screens/ring.dart';

import '../util/event.dart';
import 'medicine.dart';

// 약마다 울리는 시간을 정렬시켜 기록함
final LinkedHashMap<Medicine, SplayTreeSet<DateTime>> alarmsOfMedi =
    LinkedHashMap();

List<int> stringToIdxList(String idx) {
  List<int> idxList = [];
  var splitedList = idx.split(',');
  splitedList.removeLast();
  for (var idx in splitedList.map((e) => int.parse(e)).toList()) {
    idxList.add(idx);
  }
  return idxList;
}

void addAlarmOfMedi(List<int> idxList, DateTime dateTime, List<Medicine> mL) {
  for (int idx in idxList) {
    Medicine medicine = mL[idx];
    if (!alarmsOfMedi.containsKey(medicine)) {
      alarmsOfMedi[medicine] = SplayTreeSet();
    }
    alarmsOfMedi[medicine]!.add(dateTime);
  }
  debugPrint("각 약들의 알람정보를 더했어요");
}

void rmvAlarmOfMedi(List<int> idxList, DateTime dateTime, List<Medicine> mL) {
  for (int idx in idxList) {
    Medicine medicine = mL[idx];
    alarmsOfMedi[medicine]!.remove(dateTime);
  }
  debugPrint("각 약들의 알람정보를 삭제했어요 : $alarmsOfMedi");
}

// 사용자가 설정한 메모를 제외하고 약과 관련된 event 모두 삭제
// 전날까지는 변경x
void rmvEventsWithoutMemo() {
  final now = DateTime.now().day;

  for (DateTime dateTime in kEvents.keys) {
    if (now > dateTime.day) continue;
    List<Event> events = kEvents[dateTime]!;
    for (int i = events.length - 1; i >= 0; i--) {
      if (!events[i].memo) {
        events.removeAt(i);
      }
    }
  }
  debugPrint("kEvents에서 메모를 제외한 이벤트를 모두 삭제했어요: $kEvents");
}

void updateEvents(List<Medicine> mediList) {
  for (Medicine medicine in mediList) {
    int iter = 0, delay = 0;
    first:
    while (alarmsOfMedi[medicine] != null && alarmsOfMedi[medicine]!.isNotEmpty) {
      for (DateTime dateTime in (alarmsOfMedi[medicine]!)) {
        if (iter >= medicine.count) break first;
        DateTime key = dateTime.add(Duration(days: delay));
        if (kEvents[key] == null) {
          kEvents[key] = [];
        }
        kEvents[key]!.add(Event(title: medicine.itemName, subTitle: toTimeForm(key.hour, key.minute)));
        iter++;
      }
      delay++;
    }
  }
}

void sortEventList() {
  for (DateTime dateTime in kEvents.keys) {
    kEvents[dateTime]!.sort((a, b) => a.subTitle.compareTo(b.subTitle));
  }
}
