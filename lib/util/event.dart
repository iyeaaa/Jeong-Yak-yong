// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

import '../medicine_data/medicine.dart';

/// Example event class.
class Event {
  final Medicine medicine;
  final String dateTime;
  final bool memo;
  bool take;

  Event({
    required this.medicine,
    required this.dateTime,
    this.memo = false,
    this.take = false,
  });

  @override
  String toString() => "${medicine.itemName}: $dateTime}";
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final LinkedHashMap<DateTime, List<Event>> kEvents = LinkedHashMap(
  equals: isSameDay,
  hashCode: getHashCode,
);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
