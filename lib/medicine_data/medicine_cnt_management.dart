import 'dart:collection';
import 'package:flutter/material.dart';

import '../util/event.dart';
import 'medicine.dart';

// 약마다 울리는 시간을 정렬된 결과로 기록함
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

void addAlarmOfMedi(List<int> idxList, DateTime dateTime, List<Medicine> mediList) {
    for (int idx in idxList) {
        Medicine medicine = mediList[idx];
        if (!alarmsOfMedi.containsKey(medicine)) {
            alarmsOfMedi[medicine] = SplayTreeSet();
        }
        alarmsOfMedi[medicine]!.add(dateTime);
    }
    debugPrint("각 약들의 알람정보를 더했어요");
}

void rmvAlarmOfMedi(List<int> idxList, DateTime dateTime, List<Medicine> mediList) {
    for (int idx in idxList) {
        Medicine medicine = mediList[idx];
        alarmsOfMedi[medicine]!.remove(dateTime);
    }
    debugPrint("각 약들의 알람정보를 삭제했어요 : $alarmsOfMedi");
}

// 사용자가 설정한 메모를 제외하고 약과 관련된 event 모두 삭제
void rmvEventsWithoutMemo() {
    for (DateTime dateTime in kEvents.keys) {
        List<Event> events = kEvents[dateTime]!;
        for (Event event in events) {
            if (!event.memo) {
                events.remove(event);
            }
        }
    }
    debugPrint("kEvents에서 메모를 제외한 이벤트를 모두 삭제했어요: $kEvents");
}

void updateEvents(List<Medicine> mediList) {
    for (Medicine medicine in mediList) {
        int iter = 0, delay = 0;
        first: while (alarmsOfMedi[medicine] != null) {
            for (DateTime dateTime in (alarmsOfMedi[medicine]!)) {
                if (iter >= medicine.count) break first;
                DateTime key = dateTime.add(Duration(days: delay));
                if (kEvents[key] == null) {
                    kEvents[key] = [];
                }
                kEvents[key]!.add(Event(title: medicine.itemName, time: key));
                iter++;
            }
            delay++;
        }
    }
    debugPrint("kEvents에 알람과 관련된 정보를 새로 업데이트 했어요 : $kEvents");
}

void sortEventList() {
    for (DateTime dateTime in kEvents.keys) {
        kEvents[dateTime]!.sort((a, b) => a.time.compareTo(b.time));
    }
}