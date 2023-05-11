import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter/material.dart';
import 'alarm_screens/ring.dart';
import 'main_pages/homepage.dart';
import 'main_pages/listpage.dart';
import 'main_pages/mypage.dart';
import 'main_pages/searchpage.dart';

class TapBarPage extends StatefulWidget {
  final int selectedIndex;

  const TapBarPage({super.key, required this.selectedIndex});

  @override
  State<TapBarPage> createState() => _TapBarPageState();
}

class _TapBarPageState extends State<TapBarPage>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex = 0;
  static StreamSubscription? subscription;
  final _bottomBarController = BottomBarWithSheetController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    _bottomBarController.stream.listen((opened) {
      debugPrint('Bottom bar ${opened ? 'opened' : 'closed'}');
    });
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
    _selectedIndex = widget.selectedIndex;
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

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(mediList: []),
    ListPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomBarWithSheet(
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
          selectedItemTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 10.0,
          ),
        ),
        items: const [
          BottomBarWithSheetItem(
            icon: Icons.home_filled,
            label: 'Home',
          ),
          BottomBarWithSheetItem(
            icon: Icons.search,
            label: 'Search',
          ),
          BottomBarWithSheetItem(
            icon: Icons.list_alt,
            label: 'List',
          ),
          BottomBarWithSheetItem(
            icon: Icons.account_circle,
            label: 'MyPage',
          ),
        ],
        sheetChild: Center(
          child: Text(
            "Another content",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        controller: _bottomBarController,
        onSelectItem: (index) => debugPrint('$index'),
      ),
    );
  }
}
