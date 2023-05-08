import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicine_app/medicine_data/medicine.dart';
import 'package:medicine_app/sub_pages/medi_setting.dart';

import '../alarm_screens/edit_alarm.dart';
import '../util/medicine_card.dart';
import '../util/utils.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var name = "??";
  var userEmail = "";
  bool pressedAlarm = false;
  List<bool> isChecked = List.filled(30, false);
  List<Medicine> mediList = [];

  Future<List<Medicine>> getMediData() async {
    var list = await _firestore.collection(userEmail).doc('mediInfo').get();
    List<Medicine> tempMediList = [];
    for (var v in list.data()!['medicine']) {
      try {
        tempMediList.add(
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
          ),
        );
      } catch (e) {
        if (context.mounted) {
          debugPrint("medi load ERROR");
        }
      }
    }
    return mediList = tempMediList;
  }

  @override
  void initState() {
    super.initState();
    userEmail = _firebaseAuth.currentUser!.email!;
  }

  // 알람 설정 페이지로 이동
  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    String itemNames = "";
    for (int i = 0; i < mediList.length; i++) {
      if (isChecked[i]) {
        itemNames += "${mediList[i].itemName}#${mediList[i].entpName}&";
      }
    }

    await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: AlarmEditScreen(
            alarmSettings: settings,
            itemName: itemNames,
          ),
        );
      },
    );
    // if (res != null && res == true) loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        title: Text(
          'My List',
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 26 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
        elevation: 0,
        toolbarHeight: 80 * fem,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                pressedAlarm = !pressedAlarm;
                if (!pressedAlarm) {
                  isChecked = List.filled(30, false);
                }
              });
            },
            icon: Icon(
              pressedAlarm ? Icons.cancel_outlined : Icons.alarm_add,
              size: 33 * fem,
            ),
          ),
          SizedBox(width: 20 * fem),
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20 * fem, 20 * fem, 20 * fem, 20 * fem),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: getMediData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                if (snapshot.hasData == false) {
                  return const Center(
                    child: Text("Loading.."),
                  );
                }
                //error가 발생하게 될 경우 반환하게 되는 부분
                else if (snapshot.hasError) {
                  return const Center(
                    child: Text("ERROR!"),
                  );
                }
                // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                else {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                        return Future.delayed(
                            const Duration(milliseconds: 200));
                      },
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, idx) => InkWell(
                          onTap: () => setState(() {
                            if (pressedAlarm) {
                              isChecked[idx] = !isChecked[idx];
                            }
                          }),
                          child: Container(
                            margin: EdgeInsets.only(top: 10 * fem),
                            width: double.infinity,
                            height: 89 * fem,
                            child: MedicineCard(
                              isChecked: isChecked[idx],
                              fem: fem,
                              name: snapshot.data[idx].itemName,
                              company: snapshot.data[idx].entpName,
                              buttonName: '보기',
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedicineSettingPage(
                                      medicine: snapshot.data[idx],
                                      creating: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: pressedAlarm ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: () {
                  final alarmSettings = AlarmSettings(
                    id: 42,
                    dateTime: DateTime.now(),
                    assetAudioPath: 'assets/mozart.mp3',
                  );
                  Alarm.set(alarmSettings: alarmSettings);
                },
                backgroundColor: Colors.red,
                heroTag: null,
                child: const Text("RING NOW", textAlign: TextAlign.center),
              ), // Ring Now 버튼
              FloatingActionButton(
                backgroundColor: const Color(0xffa07eff),
                onPressed: () => navigateToAlarmScreen(null),
                child: const Icon(Icons.alarm_add_rounded, size: 30),
              ), // 알람 추가 버튼
            ],
          ),
        ),
      ),
      // 하단부 버튼
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // 버튼 위치 설정
    );
  }
}
