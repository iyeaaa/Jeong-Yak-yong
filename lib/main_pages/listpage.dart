import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:medicine_app/medicine_data/medicine.dart';
import 'package:medicine_app/sub_pages/medi_setting.dart';

import '../alarm_screens/edit_alarm.dart';
import '../util/medicine_card.dart';
import '../util/utils.dart';

class ListPage extends StatefulWidget {
  final Future<List<Medicine>> _futureMediList;
  final ValueChanged<Future<List<Medicine>>> update;

  const ListPage({
    Key? key,
    required Future<List<Medicine>> futureMediList,
    required this.update,
  })  : _futureMediList = futureMediList,
        super(key: key);

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
  List<AlarmSettings> alarms = []; // null 이면 생성되지 않은거,
  late Future<List<Medicine>> _futureMediList;

  @override
  void initState() {
    super.initState();
    userEmail = _firebaseAuth.currentUser!.email!;
    loadAlarms();
    _futureMediList = widget._futureMediList;
  }

  // 알람 배열 불러오기
  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  // 알람 삭제 기능
  void rmvAlarms(String itemName, String entpName) {
    for (int i = 0; i < alarms.length; i++) {
      // alarmName은 약이 한 개 이상 선택되어야 하므로 Null이 될 수 없음.
      var alarmName = alarms[i].notificationBody!;

      // 삭제하는 약과 상관 없는 알람이면 무시하기
      if (!alarmName.contains(itemName)) continue;

      String newBody = alarmName.replaceAll('$itemName#$entpName&', '');

      // 삭제하는 약 한개로만 이루어진 알람은 그냥 삭제시키기
      if (newBody.isEmpty) {
        Alarm.stop(alarms[i].id);
        continue;
      }

      AlarmSettings alarmSettings = AlarmSettings(
        id: alarms[i].id,
        dateTime: alarms[i].dateTime,
        assetAudioPath: alarms[i].assetAudioPath,
        loopAudio: alarms[i].loopAudio,
        vibrate: alarms[i].vibrate,
        fadeDuration: alarms[i].fadeDuration,
        notificationTitle: alarms[i].notificationTitle,
        notificationBody: newBody,
        enableNotificationOnKill: alarms[i].enableNotificationOnKill,
        stopOnNotificationOpen: alarms[i].stopOnNotificationOpen,
      );
      Alarm.set(alarmSettings: alarmSettings).then((value) => loadAlarms());
    }

    loadAlarms();
  }

  // 알람 설정 페이지로 이동
  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    String itemInfo = "";
    _futureMediList.then((list) {
      for (int i = 0; i < list.length; i++) {
        if (isChecked[i] && list[i].count > 0) {
          itemInfo += "${list[i].itemName}%${list[i].entpName}@${list[i].count}#";
        }
      }
    });

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
            itemName: itemInfo,
          ),
        );
      },
    );
    // if (res != null && res == true) loadAlarms();
  }

  // 데이터 베이스에서 약 삭제
  Future<void> removeInDatabase(dynamic element) async {
    await _firestore.collection(userEmail).doc('mediInfo').update({
      'medicine': FieldValue.arrayRemove([element])
    });
  }

  // 삭제할 때 메시지 출력
  void showRmvMessage(double fem, String itemName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$itemName을 삭제했습니다.",
          textAlign: TextAlign.center,
          style: SafeGoogleFont(
            'Nunito',
            fontSize: 15 * fem,
            fontWeight: FontWeight.w400,
            height: 1.3625 * fem / fem,
            color: const Color(0xffffffff),
          ),
        ),
        backgroundColor: const Color(0xff8a60ff),
      ),
    );
  }

  // firestore에 저장된 약 목록 불러옴
  Future<List<Medicine>> getMediData() async {
    var list = await _firestore.collection(userEmail).doc('mediInfo').get();
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
        if (context.mounted) {
          debugPrint("medi load ERROR");
        }
      }
    }
    mediList.sort((a, b) => a.itemName.compareTo(b.itemName));
    return mediList;
  }

  // 배열에서 약 삭제
  Future<void> removeInArray(int idx, dynamic element, double fem) async {
    await removeInDatabase(element);
    showRmvMessage(fem, element['itemName']);
    _futureMediList.then((value) => value.removeAt(idx));
    rmvAlarms(element['itemName'], element['entpName']);
    getMediData();
    widget.update(getMediData());
  }

  void showCustomDialog(BuildContext context, double fem, String imageUrl) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: SizedBox(width: 300 * fem, child: loadImage(imageUrl)),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
    );
  }

  Widget loadImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent, width: 2),
      ),
      child: Image.network(
        imageUrl,
        width: 400,
      ),
    );
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'My Medicine',
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 20 * fem,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff090045),
                  ),
                ),
                SizedBox(height: 50 * fem),
              ],
            ), // My Medicine
            Expanded(
              child: FutureBuilder(
                future: _futureMediList,
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
                    return snapshot.data.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 230 * fem),
                            child: const Text("저장된 약이 없어요"),
                          )
                        : RefreshIndicator(
                            onRefresh: () {
                              setState(() {
                                _futureMediList = getMediData();
                                widget.update(_futureMediList);
                              });
                              return Future.delayed(
                                  const Duration(milliseconds: 200));
                            },
                            child: AnimationLimiter(
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, idx) => InkWell(
                                  onTap: () => setState(() {
                                    if (pressedAlarm) {
                                      isChecked[idx] = !isChecked[idx];
                                    }
                                  }),
                                  child: AnimationConfiguration.staggeredList(
                                    position: idx,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50,
                                      child: FadeInAnimation(
                                        child: Dismissible(
                                          key: ValueKey(snapshot.data[idx]),
                                          background: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20 * fem),
                                              color: const Color(0xffa07eff),
                                            ),
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(
                                                right: 30),
                                            child: const Icon(
                                              Icons.delete,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onDismissed:
                                              (DismissDirection direction) {
                                            var mediList = snapshot.data;
                                            removeInArray(
                                              idx,
                                              {
                                                'itemName':
                                                    mediList[idx].itemName,
                                                'entpName':
                                                    mediList[idx].entpName,
                                                'effect': mediList[idx].effect,
                                                'itemCode':
                                                    mediList[idx].itemCode,
                                                'useMethod':
                                                    mediList[idx].useMethod,
                                                'warmBeforeHave': mediList[idx]
                                                    .warmBeforeHave,
                                                'warmHave':
                                                    mediList[idx].warmHave,
                                                'interaction':
                                                    mediList[idx].interaction,
                                                'sideEffect':
                                                    mediList[idx].sideEffect,
                                                'depositMethod':
                                                    mediList[idx].depositMethod,
                                                'imageUrl':
                                                    mediList[idx].imageUrl,
                                                'count':
                                                    mediList[idx].count,
                                              },
                                              fem,
                                            );
                                          },
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(top: 10 * fem),
                                            width: double.infinity,
                                            height: 89 * fem,
                                            child: MedicineCard(
                                              existEmage:
                                                  snapshot.data[idx].imageUrl !=
                                                      "No Image",
                                              imageOntap: () {
                                                if (snapshot
                                                        .data[idx].imageUrl ==
                                                    "No Image") {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      duration: const Duration(
                                                          milliseconds: 800),
                                                      content: Text(
                                                        "이미지가 없어요",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: SafeGoogleFont(
                                                          'Nunito',
                                                          fontSize: 15 * fem,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.3625 *
                                                              fem /
                                                              fem,
                                                          color: const Color(
                                                              0xffffffff),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          const Color(
                                                              0xff8a60ff),
                                                    ),
                                                  );
                                                } else {
                                                  showCustomDialog(
                                                      context,
                                                      fem,
                                                      snapshot
                                                          .data[idx].imageUrl);
                                                }
                                              },
                                              isChecked: isChecked[idx],
                                              fem: fem,
                                              name: snapshot.data[idx].itemName,
                                              company:
                                                  snapshot.data[idx].entpName,
                                              buttonName: 'View',
                                              ontap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MedicineSettingPage(
                                                      medicine:
                                                          snapshot.data[idx],
                                                      creating: false,
                                                      update: widget.update,
                                                    ),
                                                  ),
                                                ).then((value) => setState(() {
                                                  _futureMediList = getMediData();
                                                  widget.update(_futureMediList);
                                                  if (context.mounted) {
                                                    debugPrint("Listview 새로고침");
                                                  }
                                                }));
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: pressedAlarm ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FloatingActionButton(
            backgroundColor: const Color(0xffa07eff),
            onPressed: () {
              if (isChecked.contains(true)) {
                navigateToAlarmScreen(null);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '한 개 이상의 약을 추가해 주세요.',
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
            },
            child: const Icon(Icons.alarm_add_rounded, size: 30),
          ),
        ),
      ),
    );
  }
}
