import 'package:flutter/material.dart';
import 'main_pages/homepage.dart';
import 'main_pages/listpage.dart';
import 'main_pages/mypage.dart';
import 'main_pages/searchpage.dart';

class TapBarPage extends StatefulWidget {
  const TapBarPage({super.key});

  @override
  State<TapBarPage> createState() => _TapBarPageState();
}

class _TapBarPageState extends State<TapBarPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
    ListPage(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'MyPage',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xffa07eff),
        onTap: _onItemTapped,
      ),
    );
  }
}
