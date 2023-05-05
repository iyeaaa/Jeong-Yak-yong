import 'package:flutter/material.dart';

import 'utils.dart';

class MedicineCardForSearch extends StatelessWidget {
  final double fem;
  final String name;
  final String company;
  final String buttonName;
  final GestureTapCallback ontap;

  const MedicineCardForSearch({
    super.key,
    required this.fem,
    required this.name,
    required this.company,
    required this.ontap,
    required this.buttonName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 89 * fem,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(23 * fem),
        border: Border.all(color: const Color(0xffa07eff)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0f08587c),
            offset: Offset(0 * fem, 15 * fem),
            blurRadius: 34.5 * fem,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(8*fem, 0, 8*fem, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 70*fem,
                  height: 70*fem,
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
                  margin:
                      EdgeInsets.fromLTRB(10 * fem, 22 * fem, 0 * fem, 10.5 * fem),
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
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        company,
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12 * fem,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: const Color(0xff011e46),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ), // 약 이름, 회사
            InkWell(
              onTap: ontap,
              child: Container(
                width: 70 * fem,
                height: 30 * fem,
                decoration: BoxDecoration(
                  color: const Color(0xffa98aff),
                  borderRadius: BorderRadius.circular(99 * fem),
                ),
                child: Center(
                  child: Text(
                    buttonName,
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
              ),
            ), // 보기 버튼
          ],
        ),
      ),
    );
  }
}
