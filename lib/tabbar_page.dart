import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/login/login_page.dart';
import 'package:medicine_app/medicine_data/medicine_cnt_management.dart';
import 'package:medicine_app/util/collection.dart';
import 'package:medicine_app/util/utils.dart';
import 'alarm_screens/ring.dart';
import 'main_pages/calendarpage.dart';
import 'main_pages/chartpage.dart';
import 'main_pages/homepage.dart';
import 'main_pages/listpage.dart';
import 'main_pages/searchpage.dart';

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
  late int _selectedIndex = 0;
  late Future<String> futureUserName = getUserName();

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    _bottomBarController =
        BottomBarWithSheetController(initialIndex: widget.selectedIndex);
    _bottomBarController.stream.listen((opened) {
      debugPrint('Bottom bar ${opened ? 'opened' : 'closed'}');
    });
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadAOM(context);
    });
    super.initState();
  }

  Future<String> getUserName() async {
    return (await Collections.firestore
                .collection(Collections.userEmail)
                .doc('mediInfo')
                .get())
            .data()!['name'] ??
        "NULL";
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

  Widget bottomPage(double fem) => ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut().then(
                (value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                ),
              );
        },
        child: const Text("logout"),
      );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      body: Center(
        child: [
          HomePage(futureUserName: futureUserName),
          const SearchPage(mediList: []),
          const ListPage(),
          const CalenderPage(),
          const ChartPage(),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: SafeGoogleFont(
          'Poppins',
          fontSize: 10 * fem,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFA07EFF),
        ),
        unselectedLabelStyle: SafeGoogleFont(
          'Poppins',
          fontSize: 10 * fem,
          fontWeight: FontWeight.w600,
          color: const Color(0xffffffff),
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 23),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 23),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt, size: 23),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, size: 23),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, size: 23),
            label: 'Chart',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xffa07eff),
        onTap: _onItemTapped,
      ),
    );
  }
}
