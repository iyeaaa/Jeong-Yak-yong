import 'package:flutter/material.dart';
import 'package:medicine_app/medicine_data/medicine.dart';
import '../medicine_data/network.dart';
import '../util/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(30 * fem, 30 * fem, 30 * fem, 30 * fem),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  introduceText(fem), // 인사 텍스트
                  notificationButton(fem), // 알림 버튼
                ],
              ), // 인사말과 알림버튼 위젯
              searchWidget(fem), // 검색 입력, 버튼 위젯
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
                    margin: EdgeInsets.only(top: 7 * fem),
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
                  medicineCard(fem, "타이레놀정", "PM 1:00", 2), // 약1
                  const SizedBox(height: 15),
                  medicineCard(fem, "활명수", "PM 3:00", 3), // 약2
                ],
              ), // 약 목록 위젯
            ],
          ),
        ),
      ),
    );
  }
}

Widget medicineCard(double fem, var name, var time, var count) {
  return Container(
    width: double.infinity,
    height: 89 * fem,
    decoration: BoxDecoration(
      color: const Color(0xffffffff),
      borderRadius: BorderRadius.circular(25 * fem),
      boxShadow: [
        BoxShadow(
          color: const Color(0x0f08587c),
          offset: Offset(0 * fem, 15 * fem),
          blurRadius: 34.5 * fem,
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10 * fem, 10 * fem, 10 * fem, 10 * fem),
          padding: EdgeInsets.fromLTRB(18 * fem, 18 * fem, 18 * fem, 18 * fem),
          height: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xffa07eff),
            borderRadius: BorderRadius.circular(20 * fem),
          ),
          child: Center(
            child: SizedBox(
              width: 32 * fem,
              height: 32 * fem,
              child: Image.asset(
                'image/vector-Yd4.png',
                width: 32 * fem,
                height: 32 * fem,
              ),
            ),
          ),
        ), // 약 사진
        Container(
          margin: EdgeInsets.fromLTRB(10 * fem, 22 * fem, 70 * fem, 10.5 * fem),
          width: 70*fem,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 4 * fem),
                child: Text(
                  name,
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 16 * fem,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: const Color(0xff011e46),
                  ),
                ),
              ),
              Text(
                // pm100MW6 (97:148)
                time,
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 12 * fem,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: const Color(0xff011e46),
                ),
              ),
            ],
          ),
        ), // 약 이름, 시간
        Container(
          margin: EdgeInsets.fromLTRB(0 * fem, 20.5 * fem, 0 * fem, 20.5 * fem),
          width: 64 * fem,
          height: 30 * fem,
          decoration: BoxDecoration(
            color: const Color(0xffa98aff),
            borderRadius: BorderRadius.circular(99 * fem),
          ),
          child: Center(
            child: Text(
              '$count회',
              textAlign: TextAlign.center,
              style: SafeGoogleFont(
                'Poppins',
                fontSize: 14 * fem,
                fontWeight: FontWeight.w800,
                height: 1.5 * fem,
                color: const Color(0xffffffff),
              ),
            ),
          ),
        ), // 남은 횟수
      ],
    ),
  );
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

Widget introduceText(double fem) {
  return Text(
    'Hello Jody,\nGood Morning',
    style: SafeGoogleFont(
      'Poppins',
      fontSize: 22 * fem,
      fontWeight: FontWeight.w500,
      height: 1.5 * fem / fem,
      color: const Color(0xff0a0146),
    ),
  );
}

Widget searchWidget(double fem) {
  Widget searchButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(27 * fem, 20 * fem, 27 * fem, 20 * fem),
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
    );
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(30 * fem, 27 * fem, 30 * fem, 27 * fem),
      width: 220 * fem,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(20 * fem),
        boxShadow: [
          BoxShadow(
            color: const Color(0x11096c99),
            offset: Offset(0 * fem, 14 * fem),
            blurRadius: 33 * fem,
          ),
        ],
      ),
      child: Text(
        'Search..',
        style: SafeGoogleFont(
          'Poppins',
          fontSize: 14 * fem,
          fontWeight: FontWeight.w500,
          height: 1.5 * fem / fem,
          color: const Color(0xff011e46),
        ),
      ),
    );
  }

  return Container(
    padding: EdgeInsets.fromLTRB(0, 20 * fem, 0, 0),
    child: SizedBox(
      width: double.infinity,
      height: 72 * fem,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          searchBar(),
          searchButton(),
        ],
      ),
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
