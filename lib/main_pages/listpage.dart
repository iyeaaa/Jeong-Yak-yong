import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:medicine_app/medicine_data/medicine.dart';
import 'package:medicine_app/medicine_data/medicine_cnt_management.dart';
import 'package:medicine_app/sub_pages/medi_setting.dart';
import '../alarm_screens/edit_alarm.dart';
import '../util/medicine_card.dart';
import '../util/medicine_list.dart';
import '../util/utils.dart';

// 삭제할 때 메시지 출력
void showScaffoldMessage(String body, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        body,
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

class ListPage extends StatefulWidget {
  const ListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool pressedAlarm = false;
  List<bool> isChecked = List.filled(30, false);
  List<AlarmSettings> alarms = []; // null 이면 생성되지 않은거,

  @override
  void initState() {
    super.initState();
    loadAlarms();
  }

  // 알람 배열 불러오기
  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  // 알람 삭제 기능( 업데이트 해야함!! )
  void rmvAlarms(int mediIdx) {
    for (AlarmSettings alarm in alarms) {
      List<int> idxList = stringToIdxList(alarm.notificationBody ?? "");

      // 삭제하는 약과 상관 없는 알람이면 무시하기
      if (!idxList.contains(mediIdx)) continue;

      String newBody = "";
      idxList.remove(mediIdx);
      for (int element in idxList) {
        newBody += "$element,";
      }

      // 삭제하는 약 한개로만 이루어진 알람은 그냥 삭제시키기
      if (newBody.isEmpty) {
        Alarm.stop(alarm.id);
        continue;
      }

      AlarmSettings alarmSettings = AlarmSettings(
        id: alarm.id,
        dateTime: alarm.dateTime,
        assetAudioPath: alarm.assetAudioPath,
        loopAudio: alarm.loopAudio,
        vibrate: alarm.vibrate,
        fadeDuration: alarm.fadeDuration,
        notificationTitle: alarm.notificationTitle,
        notificationBody: newBody,
        enableNotificationOnKill: alarm.enableNotificationOnKill,
        stopOnNotificationOpen: alarm.stopOnNotificationOpen,
      );
      Alarm.set(alarmSettings: alarmSettings).then((value) => loadAlarms());
    }

    loadAlarms();
  }

  // 알람 설정 페이지로 이동
  void navigateToAlarmScreen(AlarmSettings? settings) {
    String itemIndex = "";

    for (int i = 0; i < MediList.mediList.length; i++) {
      if (isChecked[i] && MediList.mediList[i].count > 0) {
        itemIndex += "$i,";
      }
    }

    showModalBottomSheet<bool?>(
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
            mediIndex: itemIndex,
          ),
        );
      },
    );
    // if (res != null && res == true) loadAlarms();
  }

  // 배열에서 약 삭제
  Future<void> removeInArray(int idx, Medicine medicine) async {
    await MediList().removeToArray(medicine);
    if (context.mounted) {
      showScaffoldMessage("${medicine.itemName}을 삭제했어요", context);
    }
    rmvAlarms(idx);
    MediList.mediList.removeAt(idx);
    await loadAOM(MediList.mediList);
    rmvEventsWithoutMemo();
    updateEvents(MediList.mediList);
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
                SizedBox(height: 50 * fem),
              ],
            ), // My Medicine
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  setState(() {
                    debugPrint("List 새로고침 완료");
                  });
                  return Future.delayed(const Duration(milliseconds: 500));
                },
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: MediList.mediList.length,
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
                              key: ValueKey(MediList.mediList[idx].itemName),
                              background: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20 * fem),
                                  color: const Color(0xffa07eff),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 30),
                                child: const Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (DismissDirection direction) {
                                removeInArray(
                                  idx,
                                  MediList.mediList[idx],
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10 * fem),
                                width: double.infinity,
                                height: 89 * fem,
                                child: MedicineCard(
                                  existEmage: MediList.mediList[idx].imageUrl !=
                                      "No Image",
                                  imageOntap: () {
                                    if (MediList.mediList[idx].imageUrl ==
                                        "No Image") {
                                      showScaffoldMessage("이미지가 없어요", context);
                                    } else {
                                      showCustomDialog(
                                        context,
                                        fem,
                                        MediList.mediList[idx].imageUrl,
                                      );
                                    }
                                  },
                                  isChecked: isChecked[idx],
                                  fem: fem,
                                  name: MediList.mediList[idx].itemName,
                                  company: MediList.mediList[idx].entpName,
                                  buttonName: 'View',
                                  ontap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MedicineSettingPage(
                                          medicine: MediList.mediList[idx],
                                          creating: false,
                                        ),
                                      ),
                                    ).then((value) => setState(() {
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
