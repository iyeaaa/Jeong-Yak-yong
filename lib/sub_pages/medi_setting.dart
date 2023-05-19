import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/sub_pages/caution_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../medicine_data/medicine.dart';
import '../util/utils.dart';
import 'info_page.dart';

class MedicineSettingPage extends StatefulWidget {
  final Medicine medicine;
  final bool creating;
  final ValueChanged<Future<List<Medicine>>> update;

  const MedicineSettingPage({
    Key? key,
    required this.medicine,
    required this.creating,
    required this.update,
  }) : super(key: key);

  @override
  State<MedicineSettingPage> createState() => _MedicineSettingPageState();
}

class _MedicineSettingPageState extends State<MedicineSettingPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Medicine medicine;
  late String userEmail;
  int mediCount = 0;

  @override
  void initState() {
    super.initState();
    medicine = widget.medicine;
    userEmail = _firebaseAuth.currentUser!.email!;
    mediCount = medicine.count;
  }

  // 데이터베이스에 약 추가
  Future<void> appendToArray(double fem) async {
    _firestore.collection(userEmail).doc('mediInfo').update({
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
  }

  Future<void> changeToArray(dynamic element) async {
    _firestore.collection(userEmail).doc('mediInfo').update({
      'medicine': FieldValue.arrayRemove([element])
    });
  }

  void showAddOrChangeMessage(double fem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${medicine.itemName}을 ${widget.creating ? "추가" : "변경"}했어요.",
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

  Widget profile(double fem) {
    void showCustomDialog(BuildContext context) {
      showGeneralDialog(
        context: context,
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) {
          return Center(
            child: SizedBox(width: 300 * fem, child: loadImageExample()),
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

    return Stack(
      children: [
        SizedBox(
          width: 324 * fem,
          height: 200 * fem,
          child: Image.asset(
            'image/group-842-eqt.png',
            width: 324 * fem,
            height: 195 * fem,
          ),
        ), // 배경
        Container(
          margin: EdgeInsets.fromLTRB(20 * fem, 20 * fem, 20 * fem, 20 * fem),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50 * fem,
                        height: 50 * fem,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18 * fem),
                          color: const Color(0xffffffff),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (medicine.imageUrl == "No Image") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(milliseconds: 800),
                                  content: Text(
                                    "이미지가 없어요",
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
                            } else {
                              showCustomDialog(context);
                            }
                          },
                          child: Center(
                            child: Icon(
                              medicine.imageUrl != "No Image"
                                  ? Icons.image_outlined
                                  : Icons.image_not_supported_outlined,
                              color: const Color(0xffa07eff),
                              size: 30 * fem,
                            ),
                          ),
                        ),
                      ), // UI BOX 위젯
                      SizedBox(width: 10 * fem),
                      SizedBox(
                        width: 120 * fem,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medicine.itemName,
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16 * fem,
                                fontWeight: FontWeight.w700,
                                height: 1.5 * fem,
                                color: const Color(0xffffffff),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              medicine.entpName,
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 12 * fem,
                                fontWeight: FontWeight.w600,
                                height: 1.5 * fem,
                                color: const Color(0xffffffff),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ), // 약 이름, 회사
                    ],
                  ), // UI BOX, 약 이름, 회사
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CautionPage(
                          medicine: medicine,
                        ),
                      ),
                    ),
                    child: Container(
                      width: 90 * fem,
                      height: 30 * fem,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(99 * fem),
                      ),
                      child: Center(
                        child: Text(
                          '주의사항',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 14 * fem,
                            fontWeight: FontWeight.w800,
                            height: 1.5 * fem,
                            color: const Color(0xffa98aff),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ), // UI BOX and 주의사항
              SizedBox(height: 5 * fem),
              AutoSizeText(
                medicine.effect,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 15 * fem,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  color: const Color(0xffffffff),
                ),
              ), // 약 설명
            ],
          ),
        ), // 배경 위 위젯
      ],
    );
  }

  Widget loadImageExample() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent, width: 2),
      ),
      child: Image.network(
        medicine.imageUrl,
        width: 400,
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
    return mediList;
  }

  Widget mediInfoCard(int index, double fem) {
    var titleList = ["다음과 같은 효능이 있어요", "다음과 같이 사용해야 해요"];
    var contentList = [medicine.effect, medicine.useMethod];

    return Container(
      padding: EdgeInsets.only(bottom: 20 * fem),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'image/causionbox.png',
            ),
          ), // 배경
          Container(
            margin: EdgeInsets.fromLTRB(20 * fem, 20 * fem, 20 * fem, 0 * fem),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      titleList[index],
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 16 * fem,
                        fontWeight: FontWeight.w700,
                        height: 1.5 * fem,
                        color: const Color(0xffffffff),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoPage(
                            title: titleList[index],
                            content: contentList[index],
                          ),
                        ),
                      ),
                      child: Container(
                        width: 90 * fem,
                        height: 30 * fem,
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(99 * fem),
                        ),
                        child: Center(
                          child: Text(
                            "자세히보기",
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 14 * fem,
                              fontWeight: FontWeight.w800,
                              height: 1.5 * fem,
                              color: const Color(0xffa98aff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ), // UI BOX and 주의사항
                SizedBox(height: 10 * fem),
                Text(
                  contentList[index],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 16 * fem,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: const Color(0xffffffff),
                  ),
                ), // 약 설명
              ],
            ),
          ), // 배경 위 위젯
        ],
      ),
    );
  }

  Widget settingCount(double fem) => Padding(
        padding: EdgeInsets.only(top: 10 * fem),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "먹을 약 개수: ",
              overflow: TextOverflow.ellipsis,
              style: SafeGoogleFont(
                'Poppins',
                fontSize: 22 * fem,
                fontWeight: FontWeight.w700,
                height: 1.5,
                color: const Color(0xffa98aff),
              ),
            ),
            Container(
              width: 120 * fem,
              height: 50 * fem,
              padding: EdgeInsets.fromLTRB(12 * fem, 0, 12 * fem, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => setState(() {
                      mediCount = max(0, mediCount - 1);
                    }),
                    child: Text(
                      "-",
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 20 * fem,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Text(
                    mediCount.toString(),
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 22 * fem,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() {
                      mediCount = max(0, mediCount + 1);
                    }),
                    child: Text(
                      "+",
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 20 * fem,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30 * fem),
            child: IconButton(
              onPressed: () async {
                widget.creating
                    ? await appendToArray(fem)
                    : await changeToArray({
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
                      });
                if (!widget.creating) {
                  await appendToArray(fem);
                }
                widget.update(getMediData());
                showAddOrChangeMessage(fem);
              },
              icon: Icon(
                widget.creating ? Icons.add : Icons.save_outlined,
                size: 35 * fem,
              ),
            ),
          ),
        ],
        elevation: 0,
        toolbarHeight: 80 * fem,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_sharp),
        ),
        automaticallyImplyLeading: false,
        title: AutoSizeText(
          medicine.itemName,
          textAlign: TextAlign.start,
          maxLines: 2,
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 20 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(
              30 * fem,
              20 * fem,
              30 * fem,
              20 * fem,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                profile(fem),
                SizedBox(height: 30 * fem),
                mediInfoCard(0, fem),
                mediInfoCard(1, fem),
                settingCount(fem),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SlimyCard(
// color: Colors.transparent,
// width: 400,
// topCardHeight: 200,
// bottomCardHeight: 200,
// borderRadius: 15,
// topCardWidget: profile(fem),
// bottomCardWidget: loadImageExample(),
// slimeEnabled: true,
// ),

class DayWidget extends StatefulWidget {
  final String day;
  final double fem;

  const DayWidget({super.key, required this.fem, required this.day});

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  bool isSelected = false;
  late String day;
  late double fem;

  @override
  void initState() {
    super.initState();
    day = widget.day;
    fem = widget.fem;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        width: 40 * widget.fem,
        height: 50 * widget.fem,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffa07eff) : const Color(0xffDFD3FF),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            widget.day,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 16 * widget.fem,
              fontWeight: FontWeight.w500,
              height: 1.5 * widget.fem,
              color: const Color(0xffffffff),
            ),
          ),
        ),
      ),
    );
  }
}

// if (!widget.creating)
//   Expanded(
//     child: Center(
//       child: alarms.isNotEmpty
//           ? ListView.separated(
//               itemCount: alarms.length,
//               padding: EdgeInsets.only(top: 5 * fem),
//               separatorBuilder: (context, index) =>
//                   const Divider(),
//               itemBuilder: (context, index) {
//                 return AlarmTile(
//                   key: Key(alarms[index].id.toString()),
//                   time: TimeOfDay(
//                     hour: alarms[index].dateTime.hour,
//                     minute: alarms[index].dateTime.minute,
//                   ).format(context),
//                   onPressed: () =>
//                       navigateToAlarmScreen(alarms[index]),
//                   // edit 페이지로 이동하는 함수 호출
//                   onDismissed: () {
//                     Alarm.stop(alarms[index].id)
//                         .then((_) => loadAlarms());
//                   },
//                   name: medicine.itemName,
//                   company: medicine.entpName,
//                 ); // 알람 타일,
//               },
//             )
//           : Text(
//               "No alarms set",
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//     ),
//   ), // 알람 리스트
