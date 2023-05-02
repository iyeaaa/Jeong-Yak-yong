import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/medicine_data/medicine.dart';
import 'package:medicine_app/util/search_widget.dart';
import '../medicine_data/network.dart';
import '../util/medicine_card.dart';
import '../util/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser; // Nullable

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      print("dd");
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(30 * fem, 20 * fem, 30 * fem, 20 * fem),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  introduceText(fem, loggedUser!.email!), // 인사 텍스트
                  notificationButton(fem), // 알림 버튼
                ],
              ), // 인사말과 알림버튼 위젯
              SearchWidget(fem), // 검색 입력, 버튼 위젯
              Container(
                margin: EdgeInsets.only(top: 22 * fem),
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
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0 * fem),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My medicine',
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 20 * fem,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff090045),
                          ),
                        ), // My medicine Text
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'View All',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 14 * fem,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xffa07eff),
                            ),
                          ),
                        ), // View All Text
                      ],
                    ),
                  ), // My medicine, view all 텍스트 위젯
                  MedicineCard(
                    fem: fem,
                    name: "타이레놀",
                    time: "PM 1:00",
                    count: 2,
                  ), // 약1
                  SizedBox(height: 15 * fem),
                  MedicineCard(
                    fem: fem,
                    name: "활명수",
                    time: "PM 3:00",
                    count: 3,
                  ), // 약2
                ],
              ), // 약 목록 위젯
            ],
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

Widget myFutureBuilder() {
  return FutureBuilder(
    future: Network(itemName: "활명수", idx: 1).fetchMedicine(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
      if (snapshot.hasData == false) {
        return const CircularProgressIndicator();
      }
      //error가 발생하게 될 경우 반환하게 되는 부분
      else if (snapshot.hasError) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(fontSize: 15),
          ),
        );
      }
      // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
      else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (snapshot.data as Medicine).itemName,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: Text(
                  (snapshot.data as Medicine).useMethod,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}
