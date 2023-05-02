
import 'package:flutter/material.dart';
import 'package:medicine_app/util/SearchWidget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFA07EFF),
          elevation: 0,
          toolbarHeight: 80*fem,
          // leading: ,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(30 * fem, 20 * fem, 30 * fem, 20 * fem),
            child: Column(
              children: [
                SearchWidget(fem).make(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
