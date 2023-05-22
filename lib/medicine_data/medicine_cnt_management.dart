import 'dart:collection';
import 'dart:math';
import 'medicine.dart';

// 약마다 울리는 시간을 정렬된 결과로 기록함
final LinkedHashMap<Medicine, SplayTreeSet<DateTime>> alarmsOfMedi =
    LinkedHashMap();

