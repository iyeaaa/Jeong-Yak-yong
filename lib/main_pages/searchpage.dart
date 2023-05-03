import 'package:flutter/material.dart';
import 'package:medicine_app/util/medicine_card.dart';
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
        centerTitle: false,
        title: Text(
          'Search',
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 2 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
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
            Container(
              padding: EdgeInsets.fromLTRB(0, 20 * fem, 0, 0),
              child: SizedBox(
                width: double.infinity,
                height: 72 * fem,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20 * fem),
                      width: 220 * fem,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: const Center(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search..',
                            hintStyle: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ), // Search Bar
                    Container(
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
                    ), // Search Button
                  ],
                ),
              ),
            ), // 검색 위젯
            SizedBox(height: 10 * fem),
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, idx) => Container(
                  margin: EdgeInsets.only(top: 10 * fem),
                  child: MedicineCardForSearch(
                    fem: fem,
                    name: "타이레놀",
                    company: "동국제약",
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
