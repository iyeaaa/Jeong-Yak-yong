import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'alarm_screens/ring.dart';
import 'main_pages/homepage.dart';
import 'main_pages/listpage.dart';
import 'main_pages/mypage.dart';
import 'main_pages/searchpage.dart';
import 'medicine_data/medicine.dart';

class TabBarPage extends StatefulWidget {
  final int selectedIndex;

  const TabBarPage({super.key, required this.selectedIndex});

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage>
    with SingleTickerProviderStateMixin {
  static StreamSubscription? subscription;
  late BottomBarWithSheetController _bottomBarController;
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late PageController _pageController;
  late String userEmail;
  late Future<List<Medicine>> futureMediList = getMediData();
  late Future<String> futureUserName = getUserName();

  @override
  void initState() {
    _bottomBarController =
        BottomBarWithSheetController(initialIndex: widget.selectedIndex);
    _bottomBarController.stream.listen((opened) {
      debugPrint('Bottom bar ${opened ? 'opened' : 'closed'}');
    });
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
    userEmail = _firebaseAuth.currentUser!.email!;
    _pageController = PageController(initialPage: widget.selectedIndex);
    super.initState();
  }

  void update(Future<List<Medicine>> newData) {
    setState(() {
      futureMediList = newData;
    });
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

  Future<String> getUserName() async {
    var firestore = await FirebaseFirestore.instance
        .collection(userEmail)
        .doc('mediInfo')
        .get();
    return firestore['name'];
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlarmRingScreen(
          alarmSettings: alarmSettings,
        ),
      ),
    );
  }

  Widget bottomPage(double fem) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            30 * fem,
            20 * fem,
            30 * fem,
            20 * fem,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 130 * fem,
                    height: 130 * fem,
                    decoration: const BoxDecoration(color: Colors.purpleAccent),
                  ),
                  Container(
                    width: 130 * fem,
                    height: 130 * fem,
                    decoration: const BoxDecoration(color: Colors.purpleAccent),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 130 * fem,
                    height: 130 * fem,
                    decoration: const BoxDecoration(color: Colors.purpleAccent),
                  ),
                  Container(
                    width: 130 * fem,
                    height: 130 * fem,
                    decoration: const BoxDecoration(color: Colors.purpleAccent),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          _bottomBarController.selectItem(value);
        },
        children: [
          HomePage(
            futureUserName: futureUserName,
            futureMediList: futureMediList,
            update: update,
          ),
          SearchPage(
            mediList: const [],
            update: update,
          ),
          ListPage(
            futureMediList: futureMediList,
            update: update,
          ),
          const MyPage(),
        ],
      ),
      bottomNavigationBar: BottomBarWithSheet(
        autoClose: false,
        duration: const Duration(milliseconds: 700),
        bottomBarTheme: const BottomBarTheme(
          mainButtonPosition: MainButtonPosition.middle,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          itemIconColor: Colors.grey,
          itemTextStyle: TextStyle(
            color: Colors.grey,
            fontSize: 10.0,
          ),
          selectedItemIconColor: Color(0xffA07EFF),
          selectedItemTextStyle: TextStyle(
              color: Color(0xffA07EFF),
              fontSize: 10.0,
              fontWeight: FontWeight.bold),
        ),
        mainActionButtonTheme: const MainActionButtonTheme(
          size: 50,
          color: Color(0xffA07EFF),
          splash: Colors.purple,
          icon: Icon(
            Icons.settings,
            color: Colors.white,
            size: 30,
          ),
        ),
        items: const [
          BottomBarWithSheetItem(icon: Icons.home_filled),
          BottomBarWithSheetItem(icon: Icons.search),
          BottomBarWithSheetItem(icon: Icons.list_alt),
          BottomBarWithSheetItem(icon: Icons.account_circle),
        ],
        sheetChild: bottomPage(fem),
        controller: _bottomBarController,
        onSelectItem: (index) => _pageController.jumpToPage(index),
      ),
    );
  }
}
