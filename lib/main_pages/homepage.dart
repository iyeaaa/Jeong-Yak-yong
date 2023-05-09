import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/main_pages/searchpage.dart';
import 'package:medicine_app/util/alarm_tile.dart';
import 'package:timer_builder/timer_builder.dart';
import '../alarm_screens/edit_alarm.dart';
import '../medicine_data/medicine.dart';
import '../medicine_data/network.dart';
import '../util/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _authentication = FirebaseAuth.instance;
  late List<AlarmSettings> alarms = []; // null 이면 생성되지 않은거,
  late List<Medicine> mediList = [];
  var userEmail = "load fail";
  User? loggedUser; // Nullable
  int count = 289;
  String itemName = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    userEmail = _authentication.currentUser!.email!;
    loadAlarms();
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {
      debugPrint(e as String?);
    }
  }

  String toTimeForm(int idx) {
    int h = alarms[idx].dateTime.hour;
    int m = alarms[idx].dateTime.minute;
    return "${h > 9 ? "$h" : "0$h"} : ${m > 9 ? "$m" : "0$m"}";
  }

  // 알람 설정 페이지로 이동
  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    String itemNames = settings!.notificationBody ?? "No items";
    final res = await showModalBottomSheet<bool?>(
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
    if (res != null && res == true) loadAlarms();
  }

  String differTime() {
    var duration = alarms.first.dateTime.difference(DateTime.now());
    int h = duration.inHours;
    int m = (duration.inMinutes % 60);
    int s = (duration.inSeconds % 60);

    count = ((h * 60 * 60 + m * 60 + s) * 289 / (24 * 60 * 60)).round();

    return "${h < 10 ? "0$h" : h} : "
        "${m < 10 ? "0$m" : m} : ${s < 10 ? "0$s" : s}";
  }

  Widget refreshButton(double fem) {
    return InkWell(
      onTap: () => _refreshIndicatorKey.currentState?.show(),
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(
            Icons.refresh,
            color: const Color(0xff8a60ff),
            size: 35 * fem,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    Future<void> readMedicineFromApi() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            content: Row(
              children: [
                const CircularProgressIndicator(color: Color(0xffa07eff)),
                SizedBox(width: 15 * fem),
                Container(
                  margin: const EdgeInsets.only(left: 7),
                  child: Text(
                    "Loading...",
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 17 * fem,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      List<Medicine> tempMediList = [];
      Network network = Network(itemName: itemName);
      List<dynamic> listjson = await network.fetchMediList();

      if (context.mounted && (itemName.isEmpty || listjson.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "검색결과가 없습니다.",
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
        setState(() {
          mediList.clear();
        });
        Navigator.pop(context);
        return;
      }

      for (Map<String, dynamic> jsMedi in listjson) {
        tempMediList.add(network.fetchMedicine(jsMedi));
      }

      if (context.mounted) {
        Navigator.pop(context);
      }

      setState(() {
        tempMediList.sort(((a, b) => a.itemName.compareTo(b.itemName)));
        mediList = tempMediList;
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: () {
          loadAlarms();
          return Future.delayed(const Duration(milliseconds: 300));
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding:
                  EdgeInsets.fromLTRB(30 * fem, 30 * fem, 30 * fem, 30 * fem),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TimerBuilder.periodic(
                        const Duration(minutes: 5),
                        builder: (BuildContext context) {
                          return introduceText(fem, loggedUser!.email!);
                        },
                      ),
                      // 인사 텍스트
                      refreshButton(fem),
                      // 알림 버튼
                    ],
                  ), // 인사말과 알림버튼 위젯
                  Form(
                    child: Container(
                      margin: EdgeInsets.only(top: 20 * fem),
                      width: double.infinity,
                      height: 72 * fem,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              border:
                                  Border.all(color: const Color(0xff8a60ff)),
                            ),
                            width: 230 * fem,
                            height: double.infinity,
                            padding: EdgeInsets.only(left: 20 * fem),
                            child: Center(
                              child: TextFormField(
                                onChanged: (value) => itemName = value,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search..',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ), // Search Bar
                          InkWell(
                            onTap: () async {
                              mediList.clear();
                              await readMedicineFromApi();
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SearchPage(
                                          mediList: mediList,
                                        ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  27 * fem, 20 * fem, 27 * fem, 20 * fem),
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xff8a60ff),
                                borderRadius: BorderRadius.circular(20 * fem),
                              ),
                              child: Image.asset(
                                'image/fe-search-kxN.png',
                                width: 20 * fem,
                                height: 20 * fem,
                              ),
                            ),
                          ), // Search Button
                        ],
                      ),
                    ),
                  ), // 검색 위젯
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20 * fem, 0, 12 * fem),
                    width: double.infinity,
                    height: 195 * fem,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 324 * fem,
                          height: 195 * fem,
                          child: Image.asset(
                            'image/group-842-eqt.png',
                            width: 324 * fem,
                            height: 195 * fem,
                          ),
                        ), // 배경 위젯
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              20 * fem, 20 * fem, 20 * fem, 20 * fem),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50 * fem,
                                    height: 50 * fem,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(18 * fem),
                                      color: const Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'UI',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 16 * fem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.5 * fem,
                                          color: const Color(0xffa07eff),
                                        ),
                                      ),
                                    ),
                                  ), // UI BOX 위젯
                                  SizedBox(width: 20 * fem),
                                  Text(
                                    alarms.isNotEmpty
                                        ? '아직 안 드신 약이 있어요!'
                                        : '먹을 약이 없어요!',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 16 * fem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5 * fem,
                                      color: const Color(0xffffffff),
                                    ),
                                  ), // 아직 안드신 약이 있어요!
                                ],
                              ), // UI BOX and 약 남은 상태
                              SizedBox(height: 15 * fem),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '다음 알림까지 남은 시간',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 16 * fem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                      color: const Color(0xffffffff),
                                    ),
                                  ), // 다음 알림까지 남은시간
                                  SizedBox(height: 13 * fem),
                                  alarms.isNotEmpty
                                      ? TimerBuilder.periodic(
                                          const Duration(seconds: 1),
                                          builder: (context) {
                                          return Text(
                                            differTime(),
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 14 * fem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5,
                                              color: const Color(0xffffffff),
                                            ),
                                          );
                                        })
                                      : Text(
                                          "No Alarm",
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 14 * fem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.5,
                                            color: const Color(0xffffffff),
                                          ),
                                        ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5 * fem),
                                    width: 289 * fem,
                                    height: 10 * fem,
                                    decoration: BoxDecoration(
                                      color: const Color(0x7fffffff),
                                      borderRadius:
                                          BorderRadius.circular(99 * fem),
                                    ),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        width: (alarms.isEmpty ? 289 : count) *
                                            fem,
                                        height: 10 * fem,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(99 * fem),
                                          color: const Color(0xc6ffffff),
                                        ),
                                      ),
                                    ),
                                  ), // 진행 바
                                ],
                              ), // 다음 알림까지 남은 시간
                            ],
                          ),
                        ), // 배경 위 위젯
                      ],
                    ),
                  ), // 남은 약 체크 위젯
                  Row(
                    children: [
                      Text(
                        'My Alarm',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 20 * fem,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff090045),
                        ),
                      ),
                    ],
                  ), // My Medicine
                  alarms.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 80 * fem),
                          child: const Text("No alarms"),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: alarms.length,
                          itemBuilder: (context, idx) => Container(
                            padding: EdgeInsets.only(top: 10 * fem),
                            height: 97 * fem,
                            child: AlarmTile(
                              key: Key(alarms[idx].id.toString()),
                              onDismissed: () {
                                Alarm.stop(alarms[idx].id)
                                    .then((_) => loadAlarms());
                              },
                              ontap: () => navigateToAlarmScreen(alarms[idx]),
                              onPressed: () {},
                              name: toTimeForm(idx),
                              company:
                                  toItemName(alarms[idx].notificationBody!),
                            ),
                          ),
                        ), // 알람 리스트
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String toItemName(String body) {
  var nameentp = body.split('&').toList();
  nameentp.removeLast();
  String rtn = "";
  for (String value in nameentp) {
    rtn += '${value.substring(0, value.indexOf('#'))}, ';
  }
  return rtn;
}

Widget introduceText(double fem, String username) {
  username = username.substring(0, username.indexOf('@'));
  var curTime = DateTime.now().hour;
  var timeZone = "";

  if (6 <= curTime && curTime < 12) {
    timeZone = "Morning";
  } else if (12 <= curTime && curTime < 18) {
    timeZone = "Afternoon";
  } else if (18 <= curTime && curTime < 24) {
    timeZone = "Evening";
  } else {
    timeZone = "Night";
  }

  return Text(
    'Hello $username,\nGood $timeZone',
    style: SafeGoogleFont(
      'Poppins',
      fontSize: 22 * fem,
      fontWeight: FontWeight.w500,
      height: 1.5 * fem / fem,
      color: const Color(0xff0a0146),
    ),
  );
}

Widget loadImageExample() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent, width: 3),
    ),
    child: Image.network(
      "https://nedrug.mfds.go.kr/pbp/cmn/it"
      "emImageDownload/1OKRXo9l4DN",
      width: 100,
    ),
  );
}

// Widget myFutureBuilder() {
//   return FutureBuilder(
//     future: Network(itemName: "활명수", pageNo: 1).fetchMedicine(),
//     builder: (BuildContext context, AsyncSnapshot snapshot) {
//       //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
//       if (snapshot.hasData == false) {
//         return const CircularProgressIndicator();
//       }
//       //error가 발생하게 될 경우 반환하게 되는 부분
//       else if (snapshot.hasError) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Error: ${snapshot.error}',
//             style: const TextStyle(fontSize: 15),
//           ),
//         );
//       }
//       // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
//       else {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 (snapshot.data as Medicine).itemName,
//                 style: const TextStyle(fontSize: 15),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: 300,
//                 child: Text(
//                   (snapshot.data as Medicine).useMethod,
//                   style: const TextStyle(fontSize: 15),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//     },
//   );
// }
