import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../medicine_data/medicine.dart';
import '../sub_pages/medi_setting.dart';
import '../util/medicine_card.dart';
import '../util/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var userEmail = "load fail";
  User? loggedUser; // Nullable

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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    userEmail = _authentication.currentUser!.email!;
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

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(30 * fem, 30 * fem, 30 * fem, 30 * fem),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    introduceText(fem, loggedUser!.email!), // 인사 텍스트
                    notificationButton(fem), // 알림 버튼
                  ],
                ), // 인사말과 알림버튼 위젯
                Form(
                  child: Container(
                    margin: EdgeInsets.only(top: 20*fem),
                    width: double.infinity,
                    height: 72 * fem,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(color: const Color(0xff8a60ff)),
                          ),
                          width: 230 * fem,
                          height: double.infinity,
                          padding: EdgeInsets.only(left: 20 * fem),
                          child: Center(
                            child: TextFormField(
                              // onChanged: (value) => itemName = value,
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
                          onTap: () {
                            // mediList.clear();
                            // readMedicineFromApi();
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
                  margin: EdgeInsets.fromLTRB(0, 20*fem, 0, 17*fem),
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
                                    borderRadius: BorderRadius.circular(18 * fem),
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
                                  '아직 안 드신 약이 있어요!',
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
                            SizedBox(height: 20 * fem),
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
                                SizedBox(height: 7 * fem),
                                Text(
                                  '00:31:24',
                                  textAlign: TextAlign.right,
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 14 * fem,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    color: const Color(0xffffffff),
                                  ),
                                ), // 숫자
                                Container(
                                  margin: EdgeInsets.only(top: 5 * fem),
                                  width: 289 * fem,
                                  height: 10 * fem,
                                  decoration: BoxDecoration(
                                    color: const Color(0x7fffffff),
                                    borderRadius: BorderRadius.circular(99 * fem),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 125 * fem,
                                      height: 10 * fem,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(99 * fem),
                                          color: const Color(0xc6ffffff),
                                        ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    // TextButton(
                    //   onPressed: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           const TapBarPage(selectedIndex: 2),
                    //     ),
                    //   ),
                    //   child: Text(
                    //     'View All',
                    //     style: SafeGoogleFont(
                    //       'Poppins',
                    //       fontSize: 14 * fem,
                    //       fontWeight: FontWeight.w400,
                    //       color: const Color(0xffa07eff),
                    //     ),
                    //   ),
                    // ), // View All Text
                  ],
                ), // My Medicine, View all 위젯
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
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 0 * fem),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, idx) => Container(
                          padding: EdgeInsets.only(top: 10 * fem),
                          height: 98 * fem,
                          child: MedicineCard(
                            fem: fem,
                            name: snapshot.data[idx].itemName,
                            company: snapshot.data[idx].entpName,
                            buttonName: '보기',
                            pressedAlarm: false,
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
                      );
                    }
                  },
                ), // 약 목록 위젯
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget notificationButton(double fem) {
  return Container(
    width: 65,
    height: 65,
    decoration: BoxDecoration(
      color: Colors.deepPurple[50],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: SizedBox(
        width: 30 * fem,
        height: 30 * fem,
        child: Image.asset(
          'image/union.png',
        ),
      ),
    ),
  );
}

Widget introduceText(double fem, String username) {
  username = username.substring(0, username.indexOf('@'));
  return Text(
    'Hello $username,\nGood Morning',
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
