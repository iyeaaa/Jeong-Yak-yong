import 'package:flutter/material.dart';
import 'package:medicine_app/sub_pages/caution_page.dart';

import '../medicine_data/medicine.dart';
import '../util/utils.dart';

class MedicineSettingPage extends StatefulWidget {
  final Medicine medicine;

  const MedicineSettingPage({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  @override
  State<MedicineSettingPage> createState() => _MedicineSettingPageState();
}

class _MedicineSettingPageState extends State<MedicineSettingPage> {
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

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: false,
        title: Text(
          medicine.itemName,
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
        child: Container(
          padding: EdgeInsets.fromLTRB(
            30 * fem,
            20 * fem,
            30 * fem,
            20 * fem,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10 * fem),
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
                    ), // 배경
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          20 * fem, 20 * fem, 20 * fem, 20 * fem),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50 * fem,
                                    height: 50 * fem,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(18 * fem),
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
                                  SizedBox(
                                    width: 110 * fem,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          medicine.itemName,
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 16 * fem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.5 * fem,
                                            color: const Color(0xffffffff),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          medicine.entpName,
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12 * fem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.5 * fem,
                                            color: const Color(0xffffffff),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ), // 약 이름, 회사
                                ],
                              ), // UI BOX, 약 이름, 회사
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CautionPage(
                                      medicine: medicine,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: 90 * fem,
                                  height: 30 * fem,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffffffff),
                                    borderRadius:
                                        BorderRadius.circular(99 * fem),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '주의사항',
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
                          SizedBox(height: 20 * fem),
                          Text(
                            medicine.effect,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16 * fem,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              color: const Color(0xffffffff),
                            ),
                          ), // 약 설명
                        ],
                      ),
                    ), // 배경 위 위젯
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10*fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DayWidget(day: "월", fem: fem),
                    DayWidget(day: "화", fem: fem),
                    DayWidget(day: "수", fem: fem),
                    DayWidget(day: "목", fem: fem),
                    DayWidget(day: "금", fem: fem),
                    DayWidget(day: "토", fem: fem),
                    DayWidget(day: "일", fem: fem),
                  ],
                ),
              ), // 요일 선택 위젯
            ],
          ),
        ),
      ),
    );
  }
}

class DayWidget extends StatefulWidget {
  final String day;
  final double fem;

  const DayWidget({super.key, required this.fem, required this.day});

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  bool isSelected = false;
  late String day;
  late double fem;

  @override
  void initState() {
    super.initState();
    day = widget.day;
    fem = widget.fem;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        width: 40 * widget.fem,
        height: 50 * widget.fem,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffa07eff) : const Color(0xffDFD3FF),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            widget.day,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 16 * widget.fem,
              fontWeight: FontWeight.w500,
              height: 1.5 * widget.fem,
              color: const Color(0xffffffff),
            ),
          ),
        ),
      ),
    );
  }
}