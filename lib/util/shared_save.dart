import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:medicine_app/util/event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

typedef LDL = LinkedHashMap<DateTime, List<Event>>;

late final SharedPreferences pref;

void saveFromPrefs() {
  pref.setString('Events', encodeEvent()).then((value) => debugPrint("kEvents 저장 완료"));
}

String encodeEvent() {
  String encode = "";

  for (DateTime key in kEvents.keys) {
    var valList = kEvents[key]!;

    if (valList.isEmpty) continue;

    encode += "$key&";
    for (Event event in valList) {
      encode += "${event.title};${event.subTitle}#";
    }

    encode += "@";
  }
  return encode;
}

LDL decodeEvent(String info) {
  LDL rtn = LDL(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  List<String> keyAndValues = info.split("@")..removeLast();

  for (String keyAndValue in keyAndValues) {
    List<String> kav = keyAndValue.split("&");
    String key = kav[0];
    DateTime dateTimeKey = DateTime.parse(key);
    List<String> values = kav[1].split("#")..removeLast();

    rtn[dateTimeKey] = [];

    for (String titleAndSub in values) {
      List<String> tas = titleAndSub.split(";");
      String title = tas[0];
      String subTitle = tas[1];

      rtn[DateTime.parse(key)]!.add(Event(title: title, subTitle: subTitle));
    }
  }

  return rtn;
}
