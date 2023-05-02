import 'package:flutter/material.dart';
import 'package:medicine_app/util/medicine_card.dart';
import 'package:medicine_app/util/search_widget.dart';
import '../util/utils.dart';

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
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        elevation: 0,
        toolbarHeight: 80 * fem,
        leading: const Icon(Icons.arrow_back_ios_new_sharp),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
          30 * fem,
          20 * fem,
          30 * fem,
          20 * fem,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SearchWidget(fem), // 검색 위젯
            SizedBox(height: 10 * fem),
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, idx) => Container(
                  margin: EdgeInsets.only(top: 10*fem),
                  child: MedicineCard(
                    fem: fem,
                    name: "타이레놀",
                    time: "PM 1:00",
                    count: 2,
                  ),
                ),
              ),
            ), // 약 목록 리스트 위젯
            TextButton(
              onPressed: () {},
              child: Text(
                '찾는 약이 없으신가요?',
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 14 * fem,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffa07eff),
                ),
              ),
            ) // 찾는 약이 없으신가요
          ],
        ),
      ),
    );
  }
}
