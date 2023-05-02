import 'package:flutter/material.dart';

import 'utils.dart';

class MedicineCard {
  final double fem;
  final String name;
  final String time;
  final int count;

  MedicineCard({
    required this.fem,
    required this.name,
    required this.time,
    required this.count,
  });

  Widget make() {
    return Container(
      width: double.infinity,
      height: 89 * fem,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(25 * fem),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0f08587c),
            offset: Offset(0 * fem, 15 * fem),
            blurRadius: 34.5 * fem,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10 * fem, 10 * fem, 10 * fem, 10 * fem),
            padding: EdgeInsets.fromLTRB(18 * fem, 18 * fem, 18 * fem, 18 * fem),
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffa07eff),
              borderRadius: BorderRadius.circular(20 * fem),
            ),
            child: Center(
              child: SizedBox(
                width: 32 * fem,
                height: 32 * fem,
                child: Image.asset(
                  'image/vector-Yd4.png',
                  width: 32 * fem,
                  height: 32 * fem,
                ),
              ),
            ),
          ), // 약 사진
          Container(
            margin: EdgeInsets.fromLTRB(10 * fem, 22 * fem, 0 * fem, 10.5 * fem),
            width: 150 * fem,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 16 * fem,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: const Color(0xff011e46),
                  ),
                ),
                Text(
                  // pm100MW6 (97:148)
                  time,
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 12 * fem,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: const Color(0xff011e46),
                  ),
                ),
              ],
            ),
          ), // 약 이름, 시간
          Container(
            margin: EdgeInsets.fromLTRB(0 * fem, 20.5 * fem, 0 * fem, 20.5 * fem),
            width: 64 * fem,
            height: 30 * fem,
            decoration: BoxDecoration(
              color: const Color(0xffa98aff),
              borderRadius: BorderRadius.circular(99 * fem),
            ),
            child: Center(
              child: Text(
                '$count회',
                textAlign: TextAlign.center,
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 14 * fem,
                  fontWeight: FontWeight.w800,
                  height: 1.5 * fem,
                  color: const Color(0xffffffff),
                ),
              ),
            ),
          ), // 남은 횟수
        ],
      ),
    );
  }
}
