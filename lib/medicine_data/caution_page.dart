import 'package:flutter/material.dart';
import 'package:medicine_app/sub_pages/info_page.dart';

import '../util/utils.dart';
import 'medicine.dart';

class CautionPage extends StatefulWidget {
  final Medicine medicine;

  const CautionPage({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  @override
  State<CautionPage> createState() => _CautionPageState();
}

class _CautionPageState extends State<CautionPage> {
  late Medicine medicine;

  @override
  void initState() {
    super.initState();
    medicine = widget.medicine;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    List<String> titleList = [
      "다음과 같은 효능이 있어요",
      "다음과 같이 사용해야 해요",
      "의약품 복용 전 참고하세요",
      "주의해야하는 사항이에요",
      "주의가 필요한 음식이에요",
      "이러한 부작용이 있어요",
      "다음과같이 보관해야 해요",
    ];
    List<String> contentList = [
      medicine.effect,
      medicine.useMethod,
      medicine.warmBeforeHave,
      medicine.warmHave,
      medicine.interaction,
      medicine.sideEffect,
      medicine.depositMethod,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: false,
        title: Text(
          "주의사항",
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 23 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
        elevation: 0,
        toolbarHeight: 80 * fem,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_sharp),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(
            30 * fem,
            20 * fem,
            30 * fem,
            20 * fem,
          ),
          itemCount: 7,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(bottom: 20 * fem),
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      'image/causionbox.png',
                    ),
                  ), // 배경
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        20 * fem, 20 * fem, 20 * fem, 0 * fem),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              titleList[index],
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16 * fem,
                                fontWeight: FontWeight.w700,
                                height: 1.5 * fem,
                                color: const Color(0xffffffff),
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InfoPage(
                                    title: titleList[index],
                                    content: contentList[index],
                                  ),
                                ),
                              ),
                              child: Container(
                                width: 90 * fem,
                                height: 30 * fem,
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(99 * fem),
                                ),
                                child: Center(
                                  child: Text(
                                    "자세히보기",
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 14 * fem,
                                      fontWeight: FontWeight.w800,
                                      height: 1.5 * fem,
                                      color: const Color(0xffa98aff),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ), // UI BOX and 주의사항
                        SizedBox(height: 10 * fem),
                        Text(
                          contentList[index],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 16 * fem,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: const Color(0xffffffff),
                          ),
                        ), // 약 설명
                      ],
                    ),
                  ), // 배경 위 위젯
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
