import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/util/event.dart';
import '../medicine_data/medicine.dart';

// 싱글톤 패턴
class Collections {
  static final firebaseAuth = FirebaseAuth.instance;
  static final firestore = FirebaseFirestore.instance;
  static final userEmail = firebaseAuth.currentUser!.email!;
  static Future<List<Medicine>>? _instance;

  Future<List<Medicine>> getMediList() {
    if (_instance == null) {
      return _instance = _loadMediData();
    }
    return _instance!;
  }

  void update() {
    _instance = _loadMediData();
    debugPrint("데이터베이스에서 약 불러옴");
  }

  Future<void> medicineAdd(Medicine medicine, int mediCount) async {
    try {
      await firestore.collection(userEmail).doc('mediInfo').update({
        'medicine': FieldValue.arrayUnion([
          {
            'itemName': medicine.itemName,
            'entpName': medicine.entpName,
            'effect': medicine.effect,
            'itemCode': medicine.itemCode,
            'useMethod': medicine.useMethod,
            'warmBeforeHave': medicine.warmBeforeHave,
            'warmHave': medicine.warmHave,
            'interaction': medicine.interaction,
            'sideEffect': medicine.sideEffect,
            'depositMethod': medicine.depositMethod,
            'imageUrl': medicine.imageUrl,
            'count': mediCount,
          }
        ])
      });
      debugPrint("약 추가 완료 : ${medicine.itemName}");
      update();
    } catch (e) {
      debugPrint("약 추가 실패 : ${medicine.itemName}");
    }
  }

  Future<void> medicineRmv(Medicine medicine) async {
    try {
      var element = {
        'itemName': medicine.itemName,
        'entpName': medicine.entpName,
        'effect': medicine.effect,
        'itemCode': medicine.itemCode,
        'useMethod': medicine.useMethod,
        'warmBeforeHave': medicine.warmBeforeHave,
        'warmHave': medicine.warmHave,
        'interaction': medicine.interaction,
        'sideEffect': medicine.sideEffect,
        'depositMethod': medicine.depositMethod,
        'imageUrl': medicine.imageUrl,
        'count': medicine.count,
      };

      await firestore.collection(userEmail).doc('mediInfo').update({
        'medicine': FieldValue.arrayRemove([element])
      });
      update();
      debugPrint("약 삭제 완료 : ${medicine.itemName}");
    } catch (e) {
      debugPrint("약 삭제 실패 : ${medicine.itemName}");
    }
  }

  Future<void> scheduleAdd(String itemName, DateTime dateTime,
      bool take) async {
    try {
      Collections.firestore
          .collection(Collections.userEmail)
          .doc('mediInfo')
          .update({
        'schedule': FieldValue.arrayUnion([
          {
            'itemName': itemName,
            'dateTime': dateTime,
            'take': take,
            'memo': false,
          }
        ])
      });
      debugPrint("일정 추가 완료 : $itemName $dateTime $take");
    } catch (e) {
      debugPrint("일정 추가 실패");
      debugPrint(e.toString());
    }
  }

  Future<void> scheduleRmv(String itemName, DateTime dateTime,
      bool take) async {
    try {
      Collections.firestore
          .collection(Collections.userEmail)
          .doc('mediInfo')
          .update({
        'schedule': FieldValue.arrayRemove([
          {
            'itemName': itemName,
            'dateTime': dateTime,
            'take': take,
            'memo': false,
          }
        ])
      });
      debugPrint("일정 삭제 완료 : $itemName $dateTime $take");
    } catch (e) {
      debugPrint("일정 삭제 실패");
      debugPrint(e.toString());
    }
  }

  Future<void> memoAdd(Event event) async {
    await firestore.collection(userEmail).doc('mediInfo').update({
      'schedule': FieldValue.arrayUnion([
        {
          'dateTime': event.dateTime,
          'title': event.medicine.itemName,
          'memo': true,
          'condiState': event.conditionState,
          'condi': event.condition,
          'noteState': event.noteState,
          'note': event.note,
          'hyState': event.hypertensionState,
          'hy': event.hypertension,
          'gluState': event.glucoseState,
          'glu': event.glucose,
        }
      ])
    });
  }

  Future<void> memoRmv(Event event) async {
    await firestore.collection(userEmail).doc('mediInfo').update({
      'schedule': FieldValue.arrayRemove([
        {
          'dateTime': event.dateTime,
          'title': event.medicine.itemName,
          'memo': true,
          'condiState': event.conditionState,
          'condi': event.condition,
          'noteState': event.noteState,
          'note': event.note,
          'hyState': event.hypertensionState,
          'hy': event.hypertension,
          'gluState': event.glucoseState,
          'glu': event.glucose,
        }
      ])
    });
  }

  Future<List<Medicine>> _loadMediData() async {
    var list = await firestore.collection(userEmail).doc('mediInfo').get();
    List<Medicine> mediList = [];

    for (var v in list.data()!['medicine']) {
      try {
        mediList.add(
          Medicine(
            itemName: v['itemName'],
            entpName: v['entpName'],
            effect: v['effect'],
            itemCode: v['itemCode'],
            useMethod: v['useMethod'],
            warmBeforeHave: v['warmBeforeHave'],
            warmHave: v['warmHave'],
            interaction: v['interaction'],
            sideEffect: v['sideEffect'],
            depositMethod: v['depositMethod'],
            imageUrl: v['imageUrl'],
            count: v['count'],
          ),
        );
      } catch (e) {
        debugPrint("약 불러오기 ERROR! from Medicine List Class");
      }
    }
    debugPrint("데이터 베이스에서 약 불러오기 성공");
    mediList.sort((a, b) => a.itemName.compareTo(b.itemName));
    return mediList;
  }
}
