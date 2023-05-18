import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';

import '../util/utils.dart';

class MakingMediPage extends StatefulWidget {
  const MakingMediPage({Key? key}) : super(key: key);

  @override
  State<MakingMediPage> createState() => _MakingMediPageState();
}

class _MakingMediPageState extends State<MakingMediPage> {
  List<String> titleList = [
    "다음과 같은 효능이 있어요",
    "다음과 같이 사용해야 해요",
    "의약품 복용 전 참고하세요",
    "주의해야하는 사항이에요",
    "주의가 필요한 음식이에요",
    "이러한 부작용이 있어요",
    "다음과같이 보관해야 해요",
  ];
  List<IconData> iconList = [
    MaterialSymbols.stars,
    MaterialSymbols.settings,
    MaterialSymbols.back_hand,
    Icons.health_and_safety_outlined,
    Icons.no_food_outlined,
    MaterialSymbols.sick,
    MaterialSymbols.desk,
  ];

  Widget myTextField(int idx) => TextFormField(
        style: const TextStyle(color: Color(0xff3600CA)),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff3600CA)),
            borderRadius: BorderRadius.circular(5.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff8559FF),
            ),
          ),
          prefixIcon: Icon(
            iconList[idx],
            color: const Color(0xff8559FF),
          ),
          filled: true,
          fillColor: const Color(0xffDFD3FF),
          labelText: titleList[idx],
          labelStyle: const TextStyle(color: Color(0xff6B35FF)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        title: Text(
          "사용자 지정 약",
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 23 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
        elevation: 0,
        toolbarHeight: 80 * fem,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
          30 * fem,
          20 * fem,
          30 * fem,
          20 * fem,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100 * fem,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20 * fem)),
                border: Border.all(color: const Color(0xff8559FF)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 80 * fem,
                      height: 80 * fem,
                      decoration: BoxDecoration(
                        color: const Color(0xffA07EFF),
                        borderRadius:
                            BorderRadius.all(Radius.circular(20 * fem)),
                        border: Border.all(color: const Color(0xff8559FF)),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_search,
                          color: Colors.white,
                          size: 35*fem,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10 * fem),
            Expanded(
              child: ListView.builder(
                itemCount: titleList.length,
                itemBuilder: (context, idx) => Padding(
                  padding: EdgeInsets.only(top: 20 * fem),
                  child: myTextField(idx),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
