
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../medicine_data/medicine.dart';

// 싱글톤 패턴
class MediList {
  static final _firebaseAuth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static final _userEmail = _firebaseAuth.currentUser!.email!;
  static Future<List<Medicine>>? _instance;

  Future<List<Medicine>> getMediList() {
    if (_instance == null) {
      return _instance = _loadMediData();
    }
    return _instance!;
  }

  void update() {
    _instance = _loadMediData();
    debugPrint("불러온 약 업데이트 성공");
  }

  Future<void> appendToArray(Medicine medicine, int mediCount) async {
    await _firestore.collection(_userEmail).doc('mediInfo').update({
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
    debugPrint("약 추가 완료");
    update();
  }

  Future<void> removeToArray(Medicine medicine) async {
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

    await _firestore.collection(_userEmail).doc('mediInfo').update({
      'medicine': FieldValue.arrayRemove([element])
    });
    update();
    debugPrint("약 삭제 완료");
  }

  Future<List<Medicine>> _loadMediData() async {
    var list = await _firestore.collection(_userEmail).doc('mediInfo').get();
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