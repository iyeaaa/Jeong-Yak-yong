import 'package:flutter/material.dart';

import 'utils.dart';

class MedicineCard extends StatefulWidget {
  final double fem;
  final String name;
  final String company;
  final String buttonName;
  final GestureTapCallback ontap;
  final bool pressedAlarm;

  const MedicineCard({
    super.key,
    required this.fem,
    required this.name,
    required this.company,
    required this.ontap,
    required this.buttonName,
    required this.pressedAlarm,
  });

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8 * widget.fem, 0, 8 * widget.fem, 0),
      // duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(23 * widget.fem),
        border: Border.all(color: const Color(0xffa07eff)),
      ),
      // curve: Curves.fastLinearToSlowEaseIn,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 70 * widget.fem,
                  height: 70 * widget.fem,
                  decoration: BoxDecoration(
                    color: const Color(0xffa07eff),
                    borderRadius: BorderRadius.circular(20 * widget.fem),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 32 * widget.fem,
                      height: 32 * widget.fem,
                      child: Image.asset(
                        'image/vector-Yd4.png',
                        width: 32 * widget.fem,
                        height: 32 * widget.fem,
                      ),
                    ),
                  ),
                ), // 약 사진
                SizedBox(width: 9 * widget.fem),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 16 * widget.fem,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: const Color(0xff011e46),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.company,
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12 * widget.fem,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: const Color(0xff011e46),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ), // 약 이름, 회사
              ],
            ),
          ), // 프로필
          InkWell(
            onTap: widget.ontap,
            child: Container(
              width: 70 * widget.fem,
              height: 30 * widget.fem,
              decoration: BoxDecoration(
                color: const Color(0xffa98aff),
                borderRadius: BorderRadius.circular(99 * widget.fem),
              ),
              child: Center(
                child: Text(
                  widget.buttonName,
                  textAlign: TextAlign.center,
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 14 * widget.fem,
                    fontWeight: FontWeight.w800,
                    height: 1.5 * widget.fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ), // 보기 버튼
        ],
      ),
    );
  }
}
